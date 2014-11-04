//
//  Time.h
//  SleepTracker
//
//  Created by Cameron Johnson on 5/18/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Time : NSObject {
    int hour;
    int minute;
}

-(NSString *)createString;

@property (nonatomic) int hour;
@property (nonatomic) int minute;

@end
