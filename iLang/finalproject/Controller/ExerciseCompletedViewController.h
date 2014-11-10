//
//  ExerciseCompletedViewController.h
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
/** This class is an implementation for the view controller screen Exercsise comleted
 shwon after an exercise has been completed. It will show the user how many words are guessed correctly
 and how many are wrong.*/

@interface ExerciseCompletedViewController : UIViewController

/** Number of the correctly guessed words in the exercise.*/
@property int numberOfCorect;
/** Number of the wrongly guessed words in the exersice.*/
@property int numbeOfWrong;

@end
