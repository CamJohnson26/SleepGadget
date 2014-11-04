//
//  TrackedData.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/2/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TrackedData : NSObject {
	NSMutableArray *listOfTimes;
	NSMutableDictionary *listOfTimesDict;
	NSDate *dateHolder;
	BOOL isSleeping;
}

-(void)addEntry:(NSDate *)inputDate;
-(void)closeEntry:(NSDate *)inputDate;
-(NSDate *)getEntry;

@property (nonatomic,retain) NSMutableArray *listOfTimes;
@property (nonatomic,retain) NSMutableDictionary *listOfTimesDict;
@property (nonatomic,retain) NSDate *dateHolder;
@property (nonatomic) BOOL isSleeping;

@end
