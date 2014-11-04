//
//  Time.m
//  SleepTracker
//
//  Created by Cameron Johnson on 5/18/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "Time.h"


@implementation Time

@synthesize hour;
@synthesize minute;

-(NSString *)createString {
    return [NSString stringWithFormat:@"%d:%02d",hour,minute];
}

@end
