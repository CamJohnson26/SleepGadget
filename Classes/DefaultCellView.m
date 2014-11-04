//
//  DefaultCellView.m
//  SleepTracker
//
//  Created by Cameron Johnson on 4/2/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "DefaultCellView.h"


@implementation DefaultCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Set the main text
-(void)setTextLabelText:(NSString *)_inputString {
    [mainLabel setText:_inputString];
}

// Set the detail text
-(void)setDetailLabelText:(NSString *)_inputString {
    [detailLabel setText:_inputString];
}

- (void)dealloc
{
    [super dealloc];
}

@end
