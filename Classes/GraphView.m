//
//  GraphView.m
//  SleepTracker
//
//  Created by Cameron Johnson on 3/22/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "GraphView.h"


@implementation GraphView

@synthesize graphData;
@synthesize xScale;
@synthesize yScale;
@synthesize xOffset;
@synthesize yOffset;
@synthesize graphXRange;
@synthesize graphType;


-(void)awakeFromNib {
    // Initialize
    xScale = 1;
    yScale = 1;
    xOffset = 0;
    yOffset = 0;
    graphXRange = 3;
    graphYRange = 7;
    graphType = @"calendar";
    
    // Set up the size of the graph
    graphXOrigin = 0;
    graphYOrigin = 0;
    graphWidth = self.frame.size.width - 48;
    graphHeight = self.frame.size.height - 48;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*xScale = 1;
        yScale = 1;
        xOffset = 0;
        yOffset = 0;
        graphXRange = 40;*/
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Create a graph object, take its data, and draw it to the screen
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//  CGColorSpaceRef darkBlue = CGColorSpaceCreateDeviceRGB();
//	CGFloat comps[] = {0.0, 0.0, 0.4, 1.0};
//	CGColorRef color = CGColorCreate(darkBlue, comps);
//  CGContextSetFillColorWithColor(context, color);
//  CGContextFillRect(context, self.bounds);
    CGContextClearRect(context, rect);
    double x = 0;
    double y = 0;
    
    // Set up how much we see of the graph
    xScale = ((float)graphWidth) / graphXRange;
    yScale = ((float)graphHeight) / graphYRange;
    graphYRange = graphHeight / yScale;
    
    // Find the average of the lowest and highest values so we can center the graph. Add in so it factors only
    // values in the range
    float highestVal = 0;
    float lowestVal = 0;
    for (int i = 0; i < [graphData count]; i++) {
        if([[[graphData objectAtIndex:i] objectForKey:@"y"] doubleValue] >
           highestVal) {
            highestVal = [[[graphData objectAtIndex:i] objectForKey:@"y"] doubleValue];
        }
        if ([[[graphData objectAtIndex:i] objectForKey:@"y"] doubleValue] <
            lowestVal || lowestVal == 0) {
                lowestVal = [[[graphData objectAtIndex:i] objectForKey:@"y"] doubleValue];
        }
    }
    float graphMidpoint = (highestVal + lowestVal) / 2;
    float toMidpoint = graphMidpoint - graphYRange;
    float pastMidpoint = graphYRange / 2;
    yOffset = (toMidpoint + pastMidpoint) * -1;
    
    
    // To do: Make sure the graph takes up 66% of the vertical screen by adjusting the y-values
    float scaleFactor = graphYRange / (highestVal - lowestVal);
    scaleFactor *= 0.75;
    
    // Shift the graph to the end of the data
    xOffset = ([[[graphData objectAtIndex:[graphData count] - 1] objectForKey:@"x"] doubleValue] - graphXRange) + 1;
    if (xOffset <= 0) {
        xOffset = 0;
    }
    xOffset *= -1;
    
    // High val = 12
    // Low val = 3
    // graph shows 1 - 6
    // 
    
    // Set up how far apart our grid lines should be
    int intervalModifier = 7;
    if (graphXRange <= 7) {
        intervalModifier = 1;
    } else if (graphXRange <= 31) {
        intervalModifier = 7;
    } else {
        intervalModifier = 30;
    }
    float tempXInterval = graphWidth / (graphXRange / intervalModifier);
    float tempYInterval = graphWidth / graphYRange;
    [self drawAxes:context withXInterval:tempXInterval withYInterval:tempYInterval];
    
    // Draw borders
    [self drawBorders:context];
    
    // Draw labels
    [self drawLabels:context withX:tempXInterval withY:tempYInterval];
    
    // Create a shortcut so we know how much to shift the graph
    int xOffAdj = xOffset * xScale;
    int yOffAdj = yOffset * yScale;
    
    // Draw the data
    if ([graphType isEqualToString:@"line"]) {
        
        // Draw a line graph
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetLineWidth(context, 4.0);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        x = [[[graphData objectAtIndex:0] objectForKey:@"x"] doubleValue];
        y = [[[graphData objectAtIndex:0] objectForKey:@"y"] doubleValue];
        CGContextMoveToPoint(context,x*xScale + xOffAdj,(graphHeight - y*yScale) - yOffAdj);
        for (int i = 0; i < [graphData count]; i++) {
            x = [[[graphData objectAtIndex:i] objectForKey:@"x"] doubleValue];
            y = [[[graphData objectAtIndex:i] objectForKey:@"y"] doubleValue];
            
            // Scale the data on the y axis so it will fit in the viewport
            float tempY = (((((graphMidpoint - y) * scaleFactor * -1) + graphMidpoint)) * yScale);
            CGContextAddLineToPoint(context,x*xScale + xOffAdj, (graphHeight - tempY) - yOffAdj);
        }
    }
    if ([graphType isEqualToString:@"calendar"]) {
        
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
        
        // Draw a calendar graph
        float height = 0;
        int width = 192 / graphXRange;
        float yMod = graphHeight / 24;
        x = [[[graphData objectAtIndex:0] objectForKey:@"x"] doubleValue];
        y = [[[graphData objectAtIndex:0] objectForKey:@"EndDate"] floatValue];
        for (int i = 0; i < [graphData count]; i++) {
            height = [[[graphData objectAtIndex:i] objectForKey:@"y"] doubleValue];
            x = [[[graphData objectAtIndex:i] objectForKey:@"x"] doubleValue];
            y = [[[graphData objectAtIndex:i] objectForKey:@"EndDate"] floatValue];
            CGContextSetLineWidth(context, 1.0);
            CGContextFillRect(context, CGRectMake((((x + xOffset) * xScale) + ((xScale - width)/2)),graphHeight - (y * yMod), width, height * yMod));
            CGContextStrokeRect(context, CGRectMake((((x + xOffset) * xScale) + ((xScale - width)/2)),graphHeight - (y * yMod), width, height * yMod));
        }
        
    }
    
    CGContextStrokePath(context);
}

// Draw borders
-(void)drawBorders:(CGContextRef)c {
    
    /*// Frame the entire graph
    CGContextSetRGBStrokeColor(c, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(c, 2.0);
    CGContextStrokeRect(c, CGRectMake(graphXOrigin+1, graphYOrigin+1, graphWidth-1, graphHeight-1));
    CGContextStrokePath(c);*/
}

// Draw labels
-(void)drawLabels:(CGContextRef)c withX:(float)xInterval withY:(float)yInterval {
    
    // Create a shortcut so we know how much to shift the graph
    float xOffAdj = ((xOffset * xScale)-(int)(xOffset * xScale));
    float yOffAdj = ((yOffset * yScale)-(int)(yOffset * yScale));
    
    // Text Format: 
    UIFont *systemFont = [UIFont systemFontOfSize:12.0];
    [[UIColor whiteColor] set];
    NSString *labelString = @"";
    // Draw horizontal labels
    for (int i = 0; i < graphWidth; i+=xInterval) {
        /*labelString = [NSString stringWithFormat:@"%d", i];
        [labelString drawInRect:CGRectMake(self.frame.size.width - 48, i - yOffAdj, 32, 32) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];*/
    }
    
    // Draw labels for a line graph
    if (graphType == @"line") {
    
        // Draw vertical labels
        for (int i = 0; i < (int)graphHeight; i+=yInterval) {
            labelString = [NSString stringWithFormat:@"%d", (int)((i / yInterval) + (yOffset * -1))];
            [labelString drawInRect:CGRectMake(self.frame.size.width - 48, 
                                               graphHeight - ((i - yOffAdj) + 15), 
                                               32, 
                                               32) 
                           withFont:systemFont 
                      lineBreakMode:UILineBreakModeWordWrap 
                          alignment:UITextAlignmentRight];
        }
        
        // Draw horizontal labels
        for (int i = 0; i < graphWidth / xInterval; i++) {
            labelString = [NSString stringWithFormat:@"%d", (int)(i + (xOffset * -1))];
            [labelString drawInRect:CGRectMake((float)((i * (xInterval)) + xOffAdj),
                                               self.frame.size.height - 48,
                                               xInterval,
                                               32) 
                           withFont:systemFont 
                      lineBreakMode:UILineBreakModeWordWrap 
                          alignment:UITextAlignmentLeft];
        }
    }
    
    // Draw labels for a calendar graph
    if (graphType == @"calendar") {
        
        // Draw vertical labels
        /*for (int i = 0; i < 24; i++) {
            labelString = [NSString stringWithFormat:@"%d", i + 1];
            [labelString drawInRect:CGRectMake(self.frame.size.width - 48, 
                                               (graphHeight - ((graphHeight / 24) * i)), 
                                               32,
                                               32) 
                           withFont:systemFont 
                      lineBreakMode:UILineBreakModeWordWrap 
                          alignment:UITextAlignmentLeft];
        }*/
        
        // Draw horizontal labels
        for (int i = 0; i < graphWidth / xInterval; i++) {
            labelString = [NSString stringWithFormat:@"%d", (int)(i + (xOffset * -1))];
            [labelString drawInRect:CGRectMake((float)((i * (xInterval)) + xOffAdj),
                                               self.frame.size.height - 48,
                                               xInterval,
                                               32) 
                           withFont:systemFont 
                      lineBreakMode:UILineBreakModeWordWrap 
                          alignment:UITextAlignmentCenter];
        }
    }
}

-(void)drawAxes:(CGContextRef)context withXInterval:(float)xInterval withYInterval:(float)yInterval {
    
    // Create a shortcut so we know how much to shift the graph
    float xOffAdj = ((xOffset * xScale)-(int)(xOffset * xScale));
    //float yOffAdj = ((yOffset * yScale)-(int)(yOffset * yScale));
    
    /*// Draw axes
    CGContextSetRGBStrokeColor(context, 0.4, 0.4, 0.4, 1.0);
    CGContextSetLineWidth(context, 3.0);
    
    // X
    CGContextMoveToPoint(context,xScale + xOffAdj,yScale - yOffAdj);
    CGContextAddLineToPoint(context,xScale + xOffAdj,self.frame.size.height - yOffAdj);
    
    // Y
    CGContextMoveToPoint(context,xScale + xOffAdj,(self.frame.size.height - yScale) - yOffAdj);
    CGContextAddLineToPoint(context,self.frame.size.width + xOffAdj,(self.frame.size.height - yScale) - yOffAdj);
    CGContextStrokePath(context);*/

    // Draw grid lines
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.5);
    CGContextSetLineWidth(context, 1.0);
    
    // Draw horizontal grid lines
    /*for (int i = 0; i <= (((int)graphHeight) / (int)yInterval); i++) {
        CGContextMoveToPoint(context,0,(float)(i * yInterval) - yOffAdj);
        CGContextAddLineToPoint(context,graphWidth,(float)(i * yInterval) - yOffAdj);
    }*/
    
    // Draw X axis
    CGContextMoveToPoint(context,0,graphHeight);
    CGContextAddLineToPoint(context,graphWidth + 48,graphHeight);
    
    // Draw vertical grid lines
   for (int i = 0; i <= graphWidth / xInterval; i++) {
        CGContextMoveToPoint(context,(float)((i * (xInterval)) + xOffAdj),0);
        CGContextAddLineToPoint(context,(float)((i * (xInterval)) + xOffAdj),graphHeight);
    }
    
    CGContextStrokePath(context);
}

- (void)dealloc
{
    [graphData release];
    [super dealloc];
}

@end
