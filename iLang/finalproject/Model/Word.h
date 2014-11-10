//
//  Word.h
//  finalproject
//
//  Created by Jahan on 19/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * This class represents a word to be learned. It contains information about the word, its translation and its learning status.
 */
@interface Word : NSManagedObject

/**
 * lastdaynr represents the number of the last learning day. On which the word lastly was trained.
 */
@property (nonatomic, retain) NSNumber * lastdaynr;
/**
 * The learning level for the word. 7 is the lowest level and 1 is the highest level.
 */
@property (nonatomic, retain) NSNumber * level;
/**
 * The order number of the word. It defines the order in which the words are taken for learning.
 */
@property (nonatomic, retain) NSNumber * nr;
/**
 * The learning status of the word (in progress, learned, new).
 */
@property (nonatomic, retain) NSString * status;
/**
 * The translation of the word.
 */
@property (nonatomic, retain) NSString * translation;
/**
 * The word itself.
 */
@property (nonatomic, retain) NSString * word;

@end
