//
//  MatchWordsViewController.h
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iLangDatabase.h"
/**
 * This class is an implementation for the Match Words exercise.
 */
@interface MatchWordsViewController : UIViewController

/**
 * The application database must be set while creating the controller.
 */
@property (nonatomic, strong) iLangDatabase *database;

@end
