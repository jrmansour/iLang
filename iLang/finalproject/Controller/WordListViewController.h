//
//  WorldListViewController.h
//  finalproject
//
//  Created by Jahan on 12/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "iLangDatabase.h"

/**
* This class is the view controller for the screen which displays the list of words in the database
* and it alows the user to edit it.
 */
@interface WordListViewController : UIViewController

/**
 *Database of the application. It must be set while creating the controller.
 */
@property (nonatomic, strong) iLangDatabase *database;

@end
