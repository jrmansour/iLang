//
//  Word+Util.h
//  finalproject
//
//  Created by Jahan on 19/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "Word.h"

/**
* Extends class Word with additional methods.
* We cannot add them to Word class directly,
* because Word is generated from the data model.
*/
@interface Word (Util)
/**
 * This method updates the learning status of the word after a correct guess.
 * @param dayNr The day of the guess.
 */
-(void)guessedCorrectly: (NSNumber*)dayNr;
/**
 * This method updates the learning status of the word after a wrong guess.
 * @param dayNr the day of the wrong guess.
 */
-(void)guessedWrongly: (NSNumber*)dayNr;

@end
