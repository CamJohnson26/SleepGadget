//
//  Alarm.m
//  SleepTracker
//
//  Created by Cameron Johnson on 2/18/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

@synthesize alarmMinutes;
@synthesize alarmHours;

// Initialize the class the first time
-(id)init {
	if (self = [super init]) {
		
		// At first, it's not enabled
		alarmEnabled = FALSE;
	}
	return self;
}

// Take a date and sound an alarm when that date arises
-(void)setAlarmTime:(NSDate *)newAlarmTime {
	
	// The alarm is enabled
	alarmEnabled = TRUE;
	
	// Extract the hours and minutes from the input NSDate
	NSCalendar *tempCalendar = [NSCalendar currentCalendar];
	NSDateComponents *tempComponents = [tempCalendar components:kCFCalendarUnitMinute | kCFCalendarUnitHour fromDate:newAlarmTime];
	alarmHours = [tempComponents hour];
	alarmMinutes = [tempComponents minute];
}

// Turn off the alarm
-(void)disableAlarm {
	
	// Disable the alarm
	alarmEnabled = FALSE;
}

// Add a variable to the alarm time
-(void)snoozeAlarm {
}

// Return whether the alarm is enabled
-(BOOL)isEnabled {

	// If it is, return yes, otherwise no
	return alarmEnabled;
}

// Dealloc
- (void)dealloc {
	[alarmTime release];
	[super dealloc];
}

@end
