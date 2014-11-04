//
//  DefaultCellView.h
//  SleepTracker
//
//  Created by Cameron Johnson on 4/2/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DefaultCellView : UITableViewCell {
    IBOutlet UILabel *mainLabel;
    IBOutlet UILabel *detailLabel;
}

-(void)setTextLabelText:(NSString *)_inputString;
-(void)setDetailLabelText:(NSString *)_inputString;

@end
