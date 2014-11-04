
//
//  Graph.m
//  SleepTracker
//
//  Created by Cameron Johnson on 3/22/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "Graph.h"


@implementation Graph

@synthesize context = _context;

// Initialize
- (id)init {
    self = [super init];
    if (self) {
        _context = 
            [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return self;
}

// Return an array of sleep length taken from CoreData
-(NSArray *)returnAllHours {
    
    // Read coredata into an array
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"SleepDateObject" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"StartTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:dateSort]];
    [dateSort release];
    NSError *error;
    NSArray *fetchedResults = [_context executeFetchRequest:fetchRequest error:&error];
    
    // Store the sleep lengths into an array
    double allHours[[fetchedResults count]];
    double hoursSlept;
    for (int i = 0; i < [fetchedResults count]; i++) {
        NSTimeInterval timeSlept = [[(SleepDateObject *)[fetchedResults objectAtIndex:i] EndDate] timeIntervalSinceDate:[(SleepDateObject *)[fetchedResults objectAtIndex:i] StartTime]];
        hoursSlept = timeSlept / 3600.0;
        allHours[i] = hoursSlept;
    }
    NSMutableArray *allHoursSlept = [NSMutableArray arrayWithCapacity:[fetchedResults count]];
    
    // Create an array to store the proper x value given a start time
    int xValueArray[[fetchedResults count]];
    NSDate *baseDate = [[fetchedResults objectAtIndex:0] StartTime];
    
    for (int i = 0; i < [fetchedResults count]; i++) {
        NSTimeInterval timeSlept = [[(SleepDateObject *)[fetchedResults objectAtIndex:i] EndDate] timeIntervalSinceDate:baseDate];
        xValueArray[i] = timeSlept / 86400;
    }
    
    // Create an array to store the StartTime edited for the graph
    float startTimeArray[[fetchedResults count]];
    NSString *startHour = @"";
    NSString *startMinute = @"";
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"H"];
    [minuteFormat setDateFormat:@"mm"];
    float arrayVal = 0;
    for (int i = 0; i < [fetchedResults count]; i++) {
        startHour = [hourFormat stringFromDate:[[fetchedResults objectAtIndex:i] StartTime]];
        startMinute = [minuteFormat stringFromDate:[[fetchedResults objectAtIndex:i] StartTime]];
        arrayVal = [startHour floatValue] + ([startMinute floatValue] / 60.0);
        startTimeArray[i] = arrayVal;
    }
    
    // Create an array to store the EndDate edited for the graph
    float endTimeArray[[fetchedResults count]];
    NSString *endHour = @"";
    NSString *endMinute = @"";
    for (int i = 0; i < [fetchedResults count]; i++) {
        endHour = [hourFormat stringFromDate:[[fetchedResults objectAtIndex:i] EndDate]];
        endMinute = [minuteFormat stringFromDate:[[fetchedResults objectAtIndex:i] EndDate]];
        arrayVal = [endHour floatValue] + ([endMinute floatValue] / 60.0);
        endTimeArray[i] = arrayVal;
    }
    [hourFormat release];
    
    // Store all of the graph data into an array
    for (int i = 0; i < [fetchedResults count]; i++) {
        NSDictionary *tempDict = [NSDictionary 
                                  dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:allHours[i]],
                                  @"y",
                                  [NSString stringWithFormat:@"%d",xValueArray[i]],
                                  @"x",
                                  [NSNumber numberWithFloat:startTimeArray[i]],
                                  @"StartTime",
                                  [NSNumber numberWithFloat:endTimeArray[i]],
                                  @"EndDate",
                                  nil];
        [allHoursSlept addObject:tempDict];
    }
    NSArray *returnArray = [NSArray arrayWithArray:allHoursSlept];
    [fetchRequest release];
    
    return returnArray;
}

// Return some random points for testing
-(NSArray *)returnPoints {
    [NSDictionary dictionaryWithObject:@"1" forKey:@"1"];
    NSArray *tempArray = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"x",@"2",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"x",@"3",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"x",@"1",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"x",@"4",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"5",@"x",@"3",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"x",@"1",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"7",@"x",@"5",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"8",@"x",@"2",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"9",@"x",@"4",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"10",@"x",@"3",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"11",@"x",@"1",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"12",@"x",@"4",@"y",nil]
                          ,[NSDictionary dictionaryWithObjectsAndKeys:@"13",@"x",@"2",@"y",nil]
                          ,nil];
    return tempArray;
}

@end
