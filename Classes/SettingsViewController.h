//
//  SettingsViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 5/17/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate> {
    IBOutlet UITableView *dataTableView;
    NSMutableArray *filledData;
}

-(NSString *)getViewType:(NSString *)inputString;
-(void)switchActivated:(id)sender;

@end
