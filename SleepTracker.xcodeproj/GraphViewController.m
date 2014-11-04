//
//  GraphViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 3/22/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#define CHOICE_0 3
#define CHOICE_1 7
#define CHOICE_2 31
#define CHOICE_3 93
#define CHOICE_4 183
#define CHOICE_5 365
#define CHOICE_6 730

#import "GraphViewController.h"

@implementation GraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    
    // Reload the graph data every time it shows up
    
    // Set up the view's title on the tab bar
    [self resetRange];
    GraphView *tempGraphView = [[GraphView alloc] init];
    Graph *tempGraph = [[Graph alloc] init];
    [tempGraph returnAllHours]; 
    [graphViewMain setGraphData:[tempGraph returnAllHours]];
    [graphViewMain setNeedsDisplay];
    //[self setView:tempGraphView];
    [tempGraphView release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedGraphType = 1;
}

-(IBAction)lineButtonPushed {
    
    // Change the buttons into each other
    [lineButton setBackgroundImage:[UIImage imageNamed:@"GraphButton.png"] forState:UIControlStateNormal];
    [calendarButton setBackgroundImage:[UIImage imageNamed:@"alpha.png"] forState:UIControlStateNormal];
    selectedGraphType = 0;
    [lineButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [calendarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSLog(@"Hey");
    [self resetRange];
}
-(IBAction)calendarButtonPushed {
    
    // Change the buttons into each other
    [calendarButton setBackgroundImage:[UIImage imageNamed:@"GraphButton.png"] forState:UIControlStateNormal];
    [lineButton setBackgroundImage:[UIImage imageNamed:@"alpha.png"] forState:UIControlStateNormal];
    selectedGraphType = 1;
    [lineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calendarButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    NSLog(@"Yo");
    [self resetRange];
}

// Based on the user's selection, reset the size and type of the graph
-(IBAction)resetRange {
    switch ([timeSegmentedControl selectedSegmentIndex]) {
        case 0:
            graphViewMain.graphXRange = CHOICE_0;
            [graphViewMain setNeedsDisplay];
            break;
        case 1:
            graphViewMain.graphXRange = CHOICE_1;
            [graphViewMain setNeedsDisplay];
            break;
        case 2:
            graphViewMain.graphXRange = CHOICE_2;
            [graphViewMain setNeedsDisplay];
            break;
        case 3:
            graphViewMain.graphXRange = CHOICE_3;
            [graphViewMain setNeedsDisplay];
            break;
        case 4:
            graphViewMain.graphXRange = CHOICE_4;
            [graphViewMain setNeedsDisplay];
            break;
        case 5:
            graphViewMain.graphXRange = CHOICE_5;
            [graphViewMain setNeedsDisplay];
            break;
        case 6:
            graphViewMain.graphXRange = CHOICE_6;
            [graphViewMain setNeedsDisplay];
            break;
        default:
            graphViewMain.graphXRange = [graphViewMain.graphData count];
            [graphViewMain setNeedsDisplay];
            break;
    }
    
    switch (selectedGraphType) {
        case 0:
            graphViewMain.graphType = @"line";
            break;
        case 1:
            graphViewMain.graphType = @"calendar";
            break;
        default:
            graphViewMain.graphType = @"";
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   return(UIInterfaceOrientationIsPortrait(interfaceOrientation) ||
          UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

@end
