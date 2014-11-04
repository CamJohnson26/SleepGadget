//
//  DataViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/31/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateAndTime.h"
#import "Alarm.h"
#import "TrackedData.h"
#import "SleepTrackerAppDelegate.h"
#import "SleepDateObject.h"
#import "DefaultCellView.h"
#import "ManualTimesNavigationViewController.h"

@interface DataViewController : UIViewController <UITableViewDelegate> {
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UITableView *mainTableView;
    IBOutlet UIButton *sleepButton;
    IBOutlet UIButton *manualButton;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet DefaultCellView *tblCell;
    NSMutableArray *sleepDateArray;
    NSArray *_sleepTrackerSleepDateObject;
    NSManagedObjectContext *_context;
    NSTimer *updateClockTimer;
	TrackedData *mainTrackedData;
    ManualTimesNavigationViewController  *manualTimesVC;
    ManualTimesNavigationViewController  *editTimesVC;
    int uglyVar;
}

-(void)updateTable;
-(IBAction)sleepButton;
-(IBAction)manualButton;
-(void)updateDateAndTime;
-(void)startTimer;
-(void)deleteButtonPressed;
-(void)cancelButtonPressed;
-(void)saveButtonPressed;
-(void)saveEditButtonPressed;
-(void)setOrientation:(UIInterfaceOrientation)toInterfaceOrientation animated:(BOOL)animated;

@property (nonatomic,retain) TrackedData *mainTrackedData;
@property (nonatomic, retain) NSMutableArray *sleepDateArray;
@property (nonatomic, retain) NSArray *sleepTrackerSleepDateObject;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end
