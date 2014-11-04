//
//  GraphViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/22/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet GraphView *graphViewMain;
    IBOutlet UISegmentedControl *timeSegmentedControl;
    IBOutlet UIButton *lineButton;
    IBOutlet UIButton *calendarButton;
    int selectedGraphType;
}

-(IBAction)resetRange;
-(IBAction)lineButtonPushed;
-(IBAction)calendarButtonPushed;

@end
