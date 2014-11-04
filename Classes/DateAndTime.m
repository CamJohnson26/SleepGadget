//
//  DateAndTime.m
//  SleepTracker
//
//  Created by Cameron Johnson on 2/17/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "DateAndTime.h"


@implementation DateAndTime

// Return the current time
- (NSString *)getCurrentTime {
	
	// Declare a date variable and something to parse it
	NSDate *currentDate = [[[NSDate alloc] init] autorelease];
	NSDateFormatter *currentDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	// Set the formatter up how it needs to be
	[currentDateFormatter setDateFormat:@"h:mm:ss"];
	
	// Return the date as a String
	return [currentDateFormatter stringFromDate:currentDate];
}

// Return the current NSDate
- (NSDate *)getCurrentNSDate {
	
	// Declare a date variable and something to parse it
	NSDate *currentDate = [[[NSDate alloc] init] autorelease];
	
	// Return it
	return currentDate;
}

// Return the current date
- (NSString *)getCurrentDate {
	
	// Declare a date variable and something to parse it
	NSDate *currentDate = [[[NSDate alloc] init] autorelease];
	NSDateFormatter *currentDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	// Set the formatter up how it needs to be
	[currentDateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	// Return the date as a String
	return [currentDateFormatter stringFromDate:currentDate];
}

@end
