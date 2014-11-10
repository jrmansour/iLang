//
//  MainViewController.h
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iLangDatabase.h"
/**
 * This class is the implementation for the main screen in the application.
 */

@interface MainViewController : UIViewController

/**
 * The application database must be sett while creating the controller.
 */
@property (nonatomic, strong) iLangDatabase *database;

@end
