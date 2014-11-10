//
//  MatchWordsViewController.m
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "MatchWordsViewController.h"
#import "ExerciseCompletedViewController.h"
#include <stdlib.h>
#include "Word+Util.h"

@interface MatchWordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *wordsTableView;
@property (weak, nonatomic) IBOutlet UITableView *translationsTableView;

@property (strong, nonatomic) NSMutableArray* words;
@property (strong, nonatomic) NSMutableArray* translations;

@property (strong, nonatomic) NSMutableArray* correctlyGuessedWords;
@property (strong, nonatomic) NSMutableArray* wronglyGuessedWords;

@end

@implementation MatchWordsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self generateWordList];
    
    self.correctlyGuessedWords = [[NSMutableArray alloc] init];
    self.wronglyGuessedWords = [[NSMutableArray alloc] init];
    
    // if no words to match immediatelly proceed to the completed screen
    if ([self.words count] == 0) {
        [self performSegueWithIdentifier:@"Completed" sender:self];
    }
}

- (void)generateWordList
{
    NSMutableArray* wordsInProgress = [[self.database wordsToBeTrainedToday] mutableCopy];
    unsigned long numberInProgress = [wordsInProgress count];
    
    NSLog(@"Number of words %lu", numberInProgress);
    
    NSUInteger numberSelect = (numberInProgress > 7) ? 7 : numberInProgress;
    
    // randomly select words
    self.words = [[NSMutableArray alloc] init];
    for (int idx = 0; idx < numberSelect; idx++) {
        int selectIdx = arc4random() % [wordsInProgress count];
        [self.words addObject: [wordsInProgress objectAtIndex:selectIdx]];
        [wordsInProgress removeObjectAtIndex:selectIdx];
    }
    
    // add the selected words to the translation list in a random order
    self.translations = [[NSMutableArray alloc] init];
    NSMutableArray* wordsToTake = [self.words mutableCopy];
    for (int idx = 0; idx < numberSelect; idx++) {
        int selectIdx = arc4random() % [wordsToTake count];
        [self.translations addObject: [wordsToTake objectAtIndex:selectIdx]];
        [wordsToTake removeObjectAtIndex:selectIdx];
    }

    // reload table views with the selected words
    [self.wordsTableView reloadData];
    [self.translationsTableView reloadData];
}
   
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == self.wordsTableView) {
        Word* word = [self.words objectAtIndex: indexPath.row];
        cell.textLabel.text = word.word;
    }
    else {
        Word* word = [self.translations objectAtIndex: indexPath.row];
        cell.textLabel.text = word.translation;
    }
    return cell;
}

- (UIColor*)correctAnswerColor {
    return [UIColor colorWithRed:(0/255.0) green:(245/255.0) blue:(0/255.0) alpha:0.5];
}

- (UIColor*)wrongAnswerColor {
    return [UIColor colorWithRed:(245/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.5];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selWordIdx = [self.wordsTableView indexPathForSelectedRow];
    NSIndexPath* selTranslationIdx = [self.translationsTableView indexPathForSelectedRow];
    
    if (selWordIdx && selTranslationIdx) {
        Word* selWord = [self.words objectAtIndex: selWordIdx.row];
        Word* selTranslation = [self.translations objectAtIndex: selTranslationIdx.row];
        
        UITableViewCell* wordCell = [self.wordsTableView cellForRowAtIndexPath: selWordIdx];
        UITableViewCell* translationCell = [self.translationsTableView cellForRowAtIndexPath: selTranslationIdx];
        
        if (selWord == selTranslation) {
            // correct guess
            wordCell.contentView.backgroundColor = [self correctAnswerColor];
            translationCell.contentView.backgroundColor = [self correctAnswerColor];
            
            if (![self.wronglyGuessedWords containsObject:selWord]) {
                [self.correctlyGuessedWords addObject:selWord];
            }
        }
        else {
            // wrong guess
            wordCell.contentView.backgroundColor = [self wrongAnswerColor];
            translationCell.contentView.backgroundColor = [self wrongAnswerColor];
            
            if (![self.wronglyGuessedWords containsObject:selWord]) {
                [self.wronglyGuessedWords addObject:selWord];
            }
        }
        
        self.wordsTableView.userInteractionEnabled = NO;
        self.translationsTableView.userInteractionEnabled = NO;
        
        [self.wordsTableView deselectRowAtIndexPath:selWordIdx animated:YES];
        [self.translationsTableView deselectRowAtIndexPath:selTranslationIdx animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (selWord == selTranslation) {
                [self.words removeObject:selWord];
                [self.translations removeObject:selTranslation];
                [self.wordsTableView reloadData];
                [self.translationsTableView reloadData];
            }
            self.wordsTableView.userInteractionEnabled = YES;
            self.translationsTableView.userInteractionEnabled = YES;
            
            if ([self.words count] == 0) {
                [self exerciseCompleted];
            }
        });
    }
}

- (void)exerciseCompleted
{
    DayInfo* dayInfo = [self.database getDayInfo];
    NSNumber* curDayNr = dayInfo.daynr;
    
    for (Word* word in self.correctlyGuessedWords) {
        [word guessedCorrectly: curDayNr];
    }
    
    for (Word* word in self.wronglyGuessedWords) {
        [word guessedWrongly: curDayNr];
    }
    
    [self performSegueWithIdentifier: @"Completed" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Completed"]) {
        ExerciseCompletedViewController* controller = segue.destinationViewController;
        controller.numbeOfWrong = [self.wronglyGuessedWords count];
        controller.numberOfCorect = [self.correctlyGuessedWords count];
    }
}

@end
