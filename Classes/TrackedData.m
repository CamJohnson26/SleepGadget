//
//  TrackedData.m
//  SleepTracker
//
//  Created by Cameron Johnson on 3/2/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "TrackedData.h"


@implementation TrackedData

@synthesize listOfTimes;
@synthesize listOfTimesDict;
@synthesize isSleeping;
@synthesize dateHolder;

// Initialize
-(id)init {
	if (self = [super init]) {
		
		// At first, it's not enabled
		listOfTimes = [[NSMutableArray alloc] init];
		listOfTimesDict = [[NSMutableDictionary alloc] init];
		isSleeping = FALSE;
	}
	return self;
}

// Add an entry to the array
-(void)addEntry:(NSDate *)inputDate {
	
	// Add the times to the array
	[listOfTimes addObject:inputDate];
	
	// Place the date in a temporary holder until they wake up
	dateHolder = inputDate;
	
	// Toggle it so we know we need to wake up
	isSleeping = TRUE;
}

// Close an entry
-(void)closeEntry:(NSDate *)inputDate {

	// Add the sleep and wake times to the dictionary
	[listOfTimesDict setObject:dateHolder forKey:inputDate];
	
	// Toggle it so we know not we need to go to sleep
	isSleeping = FALSE;
}

// Returns the top entry
-(NSDate *)getEntry {
	return [listOfTimes objectAtIndex:[listOfTimes count]-1];
}

- (void)dealloc {
	[listOfTimes release];
	[super dealloc];
}

@end
