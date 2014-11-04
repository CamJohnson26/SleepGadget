//
//  SleepTrackerListViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/10/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SleepDateObject.h"
#import "SleepTrackerAppDelegate.h"
#import "DefaultCellView.h"


@interface SleepTrackerListViewController : UITableViewController {
	NSMutableArray *sleepDateArray;
    NSArray *_sleepTrackerSleepDateObject;
    NSManagedObjectContext *_context;
    IBOutlet DefaultCellView *tblCell;
    UITableView *dataTableView;
}

@property (nonatomic, retain) NSMutableArray *sleepDateArray;
@property (nonatomic, retain) NSArray *sleepTrackerSleepDateObject;
@property (nonatomic, retain) NSManagedObjectContext *context;

-(void)updateTable;

@end