//
//  WorldListCell.h
//  finalproject
//
//  Created by Jahan on 12/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * This class implements a custom class for the word list table.
 */
@interface WordListCell : UITableViewCell

/**
 * A label displaying the number of a word in the list.
 */
@property (weak, nonatomic) IBOutlet UILabel *nrLabel;
/**
 * A label displaying the word.
 */
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
/**
 * A label displaying the translation of the word.
 */
    
@property (weak, nonatomic) IBOutlet UILabel *translationLabel;
/**
 * A label displaying the learning status of the word.
 */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
