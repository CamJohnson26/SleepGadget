//
//  DateAndTime.h
//  SleepTracker
//
//  Created by Cameron Johnson on 2/17/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateAndTime : NSObject {

}

- (NSString *)getCurrentTime;
- (NSString *)getCurrentDate;
- (NSDate *)getCurrentNSDate;

@end
