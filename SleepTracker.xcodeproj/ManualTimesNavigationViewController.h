//
//  ManualTimesNavigationViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 4/7/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmSetterView.h"


@interface ManualTimesNavigationViewController : UIViewController <UITableViewDelegate, UINavigationBarDelegate> {
    IBOutlet UITableView *mainTableView;
    UIDatePicker *tempPicker;
    UINavigationController *manualNavController;
    NSArray *tableViewData;
    NSMutableArray *dateArray;
    int currentSelection;
}

-(void)dateChanged:(UIDatePicker *)selectedDate;
-(void)updateTable;

@property (nonatomic,retain) NSMutableArray *dateArray;

@end
