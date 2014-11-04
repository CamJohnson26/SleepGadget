//
//  GraphView.h
//  SleepTracker
//
//  Created by Cameron Johnson on 3/22/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

@interface GraphView : UIView {
    NSArray *graphData;
    NSString *graphType;
    float xScale;
    float yScale;
    float xOffset;
    float yOffset;
    float graphXRange;
    float graphYRange;
    int graphXOrigin;
    int graphYOrigin;
    int graphWidth;
    int graphHeight;
}

-(void)drawLabels:(CGContextRef)c withX:(float)xInterval withY:(float)yInterval;
-(void)drawAxes:(CGContextRef)context withXInterval:(float)xInterval withYInterval:(float)yInterval;
-(void)drawBorders:(CGContextRef)c;

@property (nonatomic) float xScale;
@property (nonatomic) float yScale;
@property (nonatomic) float xOffset;
@property (nonatomic) float yOffset;
@property (nonatomic) float graphXRange;
@property (nonatomic,retain) NSArray *graphData;
@property (nonatomic,retain) NSString *graphType;

@end
