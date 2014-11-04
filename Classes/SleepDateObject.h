//
//  SleepDateObject.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/11/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface SleepDateObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * EndDate;
@property (nonatomic, retain) NSDate * StartTime;

@end



