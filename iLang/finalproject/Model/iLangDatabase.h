//
//  iLangDatabase.h
//  finalproject
//
//  Created by Jahan on 13/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Word.h"
#import "DayInfo.h"

#define STATUS_NEW @"new"
#define STATUS_IN_PROGRESS @"in progress"
#define STATUS_LEARNED @"learned"
#define WORD_INITIAL_LEVEL 7
/**
 * This class implement the database of the application. It contains functionality to create and fill it with initial data.
 * It implements various database requests.
 */
@interface iLangDatabase : NSObject
/**
 * Reference to the CoreData document.
 */
@property (nonatomic, strong) UIManagedDocument *document;
/**
 * Reference to the managed object context.
 */
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
/**
 * True if the database is in cloud and false if it's local.
 */
@property bool inCloud;
/**
 * A class method to create the database.
 * @return The created database.
 */
+ (iLangDatabase*)create;
/**
 * Opens the database if it exists. Otherwise it will create a new local database with initial data from plist.
 * @param completionHandler A handler to be executed after openning the database.
 */
- (void)openWithCompletionHandler: (void (^)()) completionHandler;
/**
 * Finds the maximum word number in the database
 * @return The maximum word number, 0 if the database is empty.
 */
- (int)maxWordNumber;
/**
 * Determines the number of words with the status learned.
 * @return number of words with the status learned.
 */
- (NSUInteger)numberOfLearnedWords;
/**
 * Finds all words with status in progress.
 * @return An array of words with status in progress.
 */
- (NSArray*)wordsInProgress;
/**
 * Finds all words that have to be trained today.
 * @return An array of words to be trained today.
 */

- (NSArray*)wordsToBeTrainedToday;
/**
 * Adds more words to be learned.
 * @param numberToAdd number of words to be added to learn..
 */
- (void)addWordsInProgress: (int)numberToAdd;
/**
 * Returns information about the current day
 * return information about the current day
 */
-(DayInfo*)getDayInfo;

@end
