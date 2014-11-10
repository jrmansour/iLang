//
//  EditWordViewController.m
//  finalproject
//
//  Created by Jahan on 12/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "EditWordViewController.h"
#import "iLangDatabase.h"

@interface EditWordViewController ()<UITextInputDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *wordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *translationTextfield;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@end

@implementation EditWordViewController


- (IBAction)cancelPressed:(id)sender {
    if (self.newWord) {
        [self.word.managedObjectContext deleteObject:self.word];
    }
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)donePressed:(id)sender {
    // check if input is valid
    NSScanner* scan = [NSScanner scannerWithString:self.numberTextfield.text];
    int wordNr;
    bool wordNrOk = ([scan scanInt:&wordNr] && [scan isAtEnd]);
    if (!wordNrOk || wordNr < 0) {
        self.errorLabel.text = @"Invalid word number";
        return;
    }
    
    // fill word data
    self.word.word = self.wordTextfield.text;
    self.word.nr = [NSNumber numberWithInt:wordNr];
    self.word.translation = self.translationTextfield.text;
    NSUInteger index = self.statusSegmentedControl.selectedSegmentIndex;
    if (index == 0)
        self.word.status = STATUS_NEW;
    else if (index == 1) {
        if (![self.word.status isEqualToString: STATUS_IN_PROGRESS]) {
            self.word.status = STATUS_IN_PROGRESS;
            self.word.level = [NSNumber numberWithInt: 1];
            self.word.lastdaynr = nil;
        }
    }
    else
        self.word.status = STATUS_LEARNED;
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)hideKeyboard
{
    [self.wordTextfield resignFirstResponder];
    [self.translationTextfield resignFirstResponder];
    [self.numberTextfield resignFirstResponder];
    
    self.tap.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];
    
    
    // reset error message
    self.errorLabel.text = @"";

    // fill word data
    self.wordTextfield.text = self.word.word;
    self.numberTextfield.text = [self.word.nr stringValue];
    self.translationTextfield.text = self.word.translation;
    NSString* status = self.word.status;
    if ([status isEqualToString:STATUS_NEW])
        self.statusSegmentedControl.selectedSegmentIndex = 0;
    else if ([status isEqualToString:STATUS_IN_PROGRESS])
        self.statusSegmentedControl.selectedSegmentIndex = 1;
    else
        self.statusSegmentedControl.selectedSegmentIndex = 2;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    self.tap.enabled = YES;
    return YES;
}

// unused UITextInputDelegate methods
- (void)selectionDidChange:(id<UITextInput>)textInput {}
- (void)selectionWillChange:(id<UITextInput>)textInput {}
- (void)textWillChange:(id<UITextInput>)textInput {}
- (void)textDidChange:(id<UITextInput>)textInput {}

@end
