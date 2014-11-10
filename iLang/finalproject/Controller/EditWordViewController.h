//
//  EditWordViewController.h
//  finalproject
//
//  Created by Jahan on 12/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
/**
 * This class implements the functionality to enable the user to edit a selected word.
 */
@interface EditWordViewController : UIViewController

/**
 * Word to be edited.
 */
@property (weak, nonatomic) Word *word;
/**
 * Is the word new or not?
 */
@property bool newWord;
@end
