//
//  Word+Util.m
//  finalproject
//
//  Created by Jahan on 19/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "Word+Util.h"

@implementation Word (Util)

-(void)guessedCorrectly: (NSNumber*)dayNr {
    if ([self.level intValue] == 1) {
        self.status = @"learned";
        NSLog(@"word %@ learned", self.word);
    }
    else {
        self.level = [NSNumber numberWithInt: [self.level intValue] - 1];
        self.lastdaynr = dayNr;
        NSLog(@"word %@ is level %d now", self.word, [self.level intValue]);
    }
}

-(void)guessedWrongly: (NSNumber*)dayNr  {
    self.level = [NSNumber numberWithInt:7];
    self.lastdaynr = dayNr;
    NSLog(@"word %@ is level %d now", self.word, [self.level intValue]);
}

@end
