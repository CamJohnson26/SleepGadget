//
//  AlarmSetter.m
//  SleepTracker
//
//  Created by Cameron Johnson on 2/18/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "AlarmSetterView.h"


@implementation AlarmSetterView

@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Add the alarm
-(IBAction)addNewAlarm {
	
	// Tell the delegate what the alarm date should be
	if ([self.delegate respondsToSelector:@selector(AlarmSetterView:dismissedView:)]) {
		[self.delegate AlarmSetterView:self dismissedView:[datePicker date]];
	}
		
	// Delete the view since we no longer need it
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
