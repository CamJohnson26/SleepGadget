//
//  AnalyzeViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 5/16/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"
#import "Time.h"


@interface AnalyzeViewController : UIViewController <UITableViewDelegate> {
    IBOutlet UITableView *dataTableView;
    NSMutableArray *filledData;
    NSArray *dataToAnalyze;
    Time *returnTimeVal;
    Time *targetSleep;
    int analyzeRange;
}

-(Time *)calculateAverage:(NSString *)selection;
-(NSString *)returnAnalyzedLabel:(NSIndexPath *)index;

@end
