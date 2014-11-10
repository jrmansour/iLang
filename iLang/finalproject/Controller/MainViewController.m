//
//  MainViewController.m
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "MainViewController.h"
#import "WordListViewController.h"
#import "MatchWordsViewController.h"
#import "AddMoreWordsViewController.h"
#import "WordPuzzleViewController.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordsLearnedLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordsInProgressLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordsTodayLabel;

@end

@implementation MainViewController

- (void)initDatabase
{
    if (!self.database) {
        NSLog(@"Init database");
        self.database = [iLangDatabase create];
        if ([[NSFileManager defaultManager] isUbiquitousItemAtURL:self.database.document.fileURL]) {
            [self startSpinner:@"Loading..."];
        }
        [self.database openWithCompletionHandler:^{
            NSLog(@"Update UI after database opened");
            [self stopSpinner];
            [self updateInfoLabels];
        }];
    }
}

- (void)startSpinner:(NSString *)activity
{
    self.navigationItem.title = activity;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)stopSpinner
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = self.title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDatabase];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateInfoLabels];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WordList"]) {
        WordListViewController* controller = segue.destinationViewController;
        controller.database = self.database;
    } else if ([segue.identifier isEqualToString:@"MatchWords"]) {
        MatchWordsViewController* controller = segue.destinationViewController;
        controller.database = self.database;
    } else if ([segue.identifier isEqualToString:@"AddMoreWords"]) {
        AddMoreWordsViewController* controller = segue.destinationViewController;
        controller.database = self.database;
    } else if ([segue.identifier isEqualToString:@"WordPuzzle"]) {
        WordPuzzleViewController* controller = segue.destinationViewController;
        controller.database = self.database;
    }
}

- (IBAction)startNewDayPressed
{
    DayInfo* dayInfo = [self.database getDayInfo];
    dayInfo.daynr = [NSNumber numberWithInt: [dayInfo.daynr intValue] + 1];
    [self performSegueWithIdentifier:@"AddMoreWords" sender:self];
}


- (void)updateInfoLabels {
    DayInfo* dayInfo = [self.database getDayInfo];
    self.dayLabel.text = [NSString stringWithFormat: @"Day %d", [dayInfo.daynr intValue]];
    
    unsigned long numberOfLearnedWords = [self.database numberOfLearnedWords];
    self.wordsLearnedLabel.text = [NSString stringWithFormat: @"%lu words learned", numberOfLearnedWords];
    
    unsigned long numberOfWordsInProgress = [[self.database wordsInProgress] count];
    self.wordsInProgressLabel.text = [NSString stringWithFormat: @"%lu words in progress", numberOfWordsInProgress];
    
    unsigned long numberOfWordsToday = [[self.database wordsToBeTrainedToday] count];
    self.wordsTodayLabel.text = [NSString stringWithFormat: @"%lu words to be trained today", numberOfWordsToday];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
