//
//  AlarmSetter.h
//  SleepTracker
//
//  Created by Cameron Johnson on 2/18/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmSetterViewDelegate;

@interface AlarmSetterView : UIViewController {
	IBOutlet UIDatePicker *datePicker;
	id <AlarmSetterViewDelegate> delegate;
}

@property (assign) id <AlarmSetterViewDelegate> delegate;

-(IBAction)addNewAlarm;

@end

@protocol AlarmSetterViewDelegate <NSObject>

@optional

- (void)AlarmSetterView:(AlarmSetterView *)controller dismissedView:(NSDate *)selectedDate;

@end
