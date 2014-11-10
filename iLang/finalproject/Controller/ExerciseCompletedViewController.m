//
//  ExerciseCompletedViewController.m
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "ExerciseCompletedViewController.h"

@interface ExerciseCompletedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *correctGuesses;
@property (weak, nonatomic) IBOutlet UILabel *wrongGuesses;
@property (weak, nonatomic) IBOutlet UILabel *wellDone;

@end

@implementation ExerciseCompletedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.correctGuesses.text = [NSString  stringWithFormat:@"%d", self.numberOfCorect];
    self.wrongGuesses.text = [NSString stringWithFormat:@"%d", self.numbeOfWrong];
    
    int totalWords = self.numberOfCorect + self.numbeOfWrong;
    float correctRatio = (totalWords == 0) ? 0.0 : ((float)self.numberOfCorect) / totalWords;
    if (correctRatio >= 0.9) {
        self.wellDone.text = @"Excellent!";
    }
    else if (correctRatio >= 0.7) {
        self.wellDone.text = @"Well done!";
    }
    else if (correctRatio >= 0.5) {
        self.wellDone.text = @"Not bad!";
    }
    else {
        self.wellDone.text = @"Try once again";
    }
    
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)completePressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated: YES];
    
}

@end
