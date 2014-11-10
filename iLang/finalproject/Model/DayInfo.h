//
//  DayInfo.h
//  finalproject
//
//  Created by Jahan on 19/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * This class contains information about the current learning day.
 */
@interface DayInfo : NSManagedObject

/**
 * The date on which the current learning day began.
 */
@property (nonatomic, retain) NSDate * date;
/**
 * The number identifiying the current day.
 */
@property (nonatomic, retain) NSNumber * daynr;

@end
