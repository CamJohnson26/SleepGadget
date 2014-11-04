//
//  Graph.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/22/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SleepTrackerAppDelegate.h"
#import "SleepDateObject.h"


@interface Graph : NSObject {
    NSManagedObjectContext *_context;
}

-(NSArray *)returnPoints;
-(NSArray *)returnAllHours;

@property (nonatomic, retain) NSManagedObjectContext *context;

@end
