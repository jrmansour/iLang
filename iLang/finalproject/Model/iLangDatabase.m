//
//  iLangDatabase.m
//  finalproject
//
//  Created by Jahan on 13/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "iLangDatabase.h"

@interface iLangDatabase()

@end

@implementation iLangDatabase

- (NSManagedObjectContext*)managedObjectContext {
    return self.document.managedObjectContext;
}

- (void)createInitialDatabase
{
    [self.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
        NSString* path = [[NSBundle mainBundle] pathForResource: @"InitialWordList" ofType: @"plist" ];
        NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile: path];
        NSArray* wordArray = [dict objectForKey: @"Word"];
        NSArray* translationArray = [dict objectForKey: @"Translation"];
        
        for (int idx = 0; idx < [wordArray count]; idx++) {
            Word* word = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                       inManagedObjectContext:self.managedObjectContext];
            word.nr = [NSNumber numberWithInt:idx];
            word.word = [wordArray objectAtIndex:idx];
            word.translation = [translationArray objectAtIndex:idx];
            word.status = STATUS_NEW;
            word.level = [NSNumber numberWithInt:WORD_INITIAL_LEVEL];
            word.lastdaynr = nil;
            NSLog(@"Word created");
        }
        // should probably saveToURL:forSaveOperation:(UIDocumentSaveForOverwriting)completionHandler: here!.
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:
         ^(BOOL success) {
             NSLog(@"Database saved %d", success);
         }];
    }];
}

// return information about the current day
-(DayInfo*)getDayInfo
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DayInfo"];
    request.fetchLimit = 1;
    NSArray* requestRes = [self.managedObjectContext executeFetchRequest:request error:nil];
    if ([requestRes count] > 0) {
        return [requestRes objectAtIndex:0];
    }
    else {
        // if the DayInfo does not exist, create it now
        DayInfo* dayInfo = [NSEntityDescription insertNewObjectForEntityForName:@"DayInfo"
                                                   inManagedObjectContext:self.managedObjectContext];
        dayInfo.daynr = [NSNumber numberWithInt: 1];
        dayInfo.date = [NSDate date];
        return dayInfo;
    }
}

// Open or create the document here and call setupFetchedResultsController

- (void)openWithCompletionHandler: (void (^)()) completionHandler
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        // does not exist on disk, so create it
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"Database created");
            [self createInitialDatabase];
            completionHandler();
        }];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.document openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Database opened");
            completionHandler();
        }];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        NSLog(@"Database is already opened");
        completionHandler();
    }
}

+ (NSURL *)iCloudURL
{
    NSURL* cloudURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    return cloudURL;
}


+ (NSURL *)iCloudDatabaseURL
{
    NSURL* cloudURL = [iLangDatabase iCloudURL];
    NSLog(@"Cloud URL: %@", cloudURL);
    return [[cloudURL URLByAppendingPathComponent: @"Documents"] URLByAppendingPathComponent:@"iLang Database"];
}

+ (NSURL *)iCloudCoreDataLogFilesURL
{
    NSURL* cloudURL = [iLangDatabase iCloudURL];
    return [cloudURL URLByAppendingPathComponent:@"CoreData"];
}

+ (NSURL*)localDatabaseURL
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"iLang Database"];
    return url;
}

+ (void)setPersistentStoreOptionsInDocument:(UIManagedDocument *)document
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    [options setObject:[document.fileURL lastPathComponent] forKey:NSPersistentStoreUbiquitousContentNameKey];
    [options setObject:[self iCloudCoreDataLogFilesURL] forKey:NSPersistentStoreUbiquitousContentURLKey];
    
    document.persistentStoreOptions = options;
}

+ (iLangDatabase*)create
{
    NSLog(@"Initializing database");
    iLangDatabase* db = [[iLangDatabase alloc] init];
    NSURL *url = [iLangDatabase iCloudDatabaseURL];
    db.inCloud = (url != nil);
    if (!db.inCloud) {
        // if cloud not available use a local database
        url = [iLangDatabase localDatabaseURL];
    }
    db.document = [[UIManagedDocument alloc] initWithFileURL:url]; // setter will create this for us on disk
    if (db.inCloud) {
        // persistence settings for cloud
        [iLangDatabase setPersistentStoreOptionsInDocument:db.document];
    }
    return db;
}

- (int)maxWordNumber
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nr" ascending:NO]];
    request.fetchLimit = 1;
    
    NSArray* requestRes = [self.managedObjectContext executeFetchRequest:request error:nil];
    if ([requestRes count] == 0) {
        return 0;
    } else {
        Word* word = [requestRes objectAtIndex:0];
        return [word.nr intValue];
    }
}

- (NSUInteger)numberOfLearnedWords
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.predicate = [NSPredicate predicateWithFormat:@"status = %@", STATUS_LEARNED];
    NSArray* requestRes = [self.managedObjectContext executeFetchRequest:request error:nil];
    return [requestRes count];
}

- (NSArray*)wordsInProgress
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nr" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"status = %@", STATUS_IN_PROGRESS];
    NSArray* requestRes = [self.managedObjectContext executeFetchRequest:request error:nil];
    return requestRes;
}

-(int)daysToWait: (Word*)word
{
    // word was not shown yet, so show it immediately
    if (word.lastdaynr == nil) {
        return 0;
    }
    // otherwise wait time depends on the learning level of the word
    // the higher the level - the longer we need to wait
    int level = [word.level intValue];
    if (level == 1) {
        return 8;
    }
    else if (level == 2) {
        return 4;
    }
    else if (level == 3) {
        return 2;
        
    }
    else if (level == 4) {
        return 1;
    }
    else {
        // for lowest levels 5, 6, 7 the word can be repeated without waiting
        return 0;
    }
}

- (NSArray*)wordsToBeTrainedToday
{
    DayInfo* dayInfo = [self getDayInfo];
    int curDayNr = [dayInfo.daynr intValue];
    
    NSArray* wordsInProgress = [self wordsInProgress];
    
    // select words that should be trained at this day
    NSMutableArray* wordsToTake = [[NSMutableArray alloc] init];
    for (Word* word in wordsInProgress) {
        int waitDays = [self daysToWait: word];
        int lastDayNr = [word.lastdaynr intValue];
        if (waitDays == 0 || (curDayNr - lastDayNr >= waitDays)) {
            [wordsToTake addObject: word];
        }
    }
    return wordsToTake;
}

- (void)addWordsInProgress: (int)numberToAdd
{
    NSLog(@"Adding %d words", numberToAdd);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nr" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"status = %@", STATUS_NEW];
    request.fetchLimit = numberToAdd;
    NSArray* requestRes = [self.managedObjectContext executeFetchRequest:request error:nil];
    for (Word* word in requestRes) {
        NSLog(@"Adding word %@", word.word);
        word.status = STATUS_IN_PROGRESS;
        word.level = [NSNumber numberWithInt: 1];
        word.lastdaynr = nil;
    }
}

@end
