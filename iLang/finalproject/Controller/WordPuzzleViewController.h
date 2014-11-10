//
//  WordPuzzleViewController.h
//  finalproject
//
//  Created by Jahan on 19/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iLangDatabase.h"

/** This view controller implements the functionality of guess words exercise */
@interface WordPuzzleViewController : UIViewController

/** The app database, needs to be set when creating the controller */
@property (nonatomic, strong) iLangDatabase *database;

@end
