//
//  Alarm.h
//  SleepTracker
//
//  Created by Cameron Johnson on 2/18/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <Foundation/Foundation.h>

// We need to make this hold hours, minutes, and pm
@interface Alarm : NSObject {
	BOOL alarmEnabled;
	int alarmHours;
	int alarmMinutes;
	NSDate *alarmTime;
}

-(void)setAlarmTime:(NSDate *)alarmTime;
-(void)disableAlarm;
-(void)snoozeAlarm;
-(BOOL)isEnabled;

@property (nonatomic) int alarmHours;
@property (nonatomic) int alarmMinutes;


@end