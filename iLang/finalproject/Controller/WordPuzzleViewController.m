//
//  WordPuzzleViewController.m
//  finalproject
//
//  Created by Jahan on 19/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "WordPuzzleViewController.h"
#import "Word+Util.h"
#import "ExerciseCompletedViewController.h"

@interface WordPuzzleViewController () <UITextInputDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (weak, nonatomic) IBOutlet UILabel *resultField;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) NSArray *words;
@property int curWordIdx;
@property int numberOfCorrect;
@property int numberOfWrong;
@property int lastGuessedIdx;

@property bool waitingForAnswer;

@end

@implementation WordPuzzleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];
	
    self.words = [self.database wordsToBeTrainedToday];
    self.curWordIdx = 0;
    self.numberOfCorrect = 0;
    self.numberOfWrong = 0;
    self.lastGuessedIdx = -1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupQuestion];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (self.waitingForAnswer) {
        self.tap.enabled = YES;
        return YES;
    }
    else {
        return NO;
    }
}

// unused UITextInputDelegate methods
- (void)selectionDidChange:(id<UITextInput>)textInput {}
- (void)selectionWillChange:(id<UITextInput>)textInput {}
- (void)textWillChange:(id<UITextInput>)textInput {}
- (void)textDidChange:(id<UITextInput>)textInput {}

-(void)hideKeyboard
{
    [self.answerField resignFirstResponder];
    self.tap.enabled = NO;
}

- (IBAction)enterPressed:(id)sender {
    if (self.waitingForAnswer) {
        // Enter button pressed
        Word* curWord = [self.words objectAtIndex: self.curWordIdx];
        
        [self.answerField endEditing:YES];
        NSString* guessedWord = self.answerField.text;
        // trim space characters
        guessedWord = [guessedWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        DayInfo* dayInfo = [self.database getDayInfo];
        NSNumber* curDayNr = dayInfo.daynr;
        
        if ([guessedWord isEqualToString:curWord.word]) {
            self.resultField.text = @"Correct";
            [curWord guessedCorrectly:curDayNr];
            self.navigationItem.rightBarButtonItem.title = @"Next";
            self.waitingForAnswer = false;
            if (self.lastGuessedIdx != self.curWordIdx)
                self.numberOfCorrect++;
        }
        else {
            self.resultField.text = @"Wrong";
            [curWord guessedWrongly:curDayNr];
            if (self.lastGuessedIdx != self.curWordIdx)
                self.numberOfWrong++;
        }
        
        self.lastGuessedIdx = self.curWordIdx;
    }
    else {
        // Next button pressed
        self.curWordIdx++;
        [self setupQuestion];
    }
    
}

- (IBAction)skipPressed:(id)sender {
    self.curWordIdx++;
    [self setupQuestion];
}

- (IBAction)revealPressed:(id)sender {
    if (!self.waitingForAnswer) {
        // ignore
        return;
    }
    Word* curWord = [self.words objectAtIndex: self.curWordIdx];
    self.answerField.text = curWord.word;
    self.resultField.text = @"";
    
    DayInfo* dayInfo = [self.database getDayInfo];
    NSNumber* curDayNr = dayInfo.daynr;
    [curWord guessedWrongly:curDayNr];
    if (self.lastGuessedIdx != self.curWordIdx)
        self.numberOfWrong++;
    
    self.navigationItem.rightBarButtonItem.title = @"Next";
    self.waitingForAnswer = false;
}

-(void) setupQuestion
{
    if (self.curWordIdx < [self.words count]) {
        Word* curWord = [self.words objectAtIndex: self.curWordIdx];
        self.questionLabel.text = curWord.translation;
        self.answerField.text = @"";
        self.resultField.text = @"";
        self.navigationItem.rightBarButtonItem.title = @"Enter";
        self.waitingForAnswer = true;
    }
    else {
        [self performSegueWithIdentifier:@"Completed" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Completed"]) {
        ExerciseCompletedViewController* controller = segue.destinationViewController;
        controller.numbeOfWrong = self.numberOfWrong;
        controller.numberOfCorect = self.numberOfCorrect;
    }
}

@end
