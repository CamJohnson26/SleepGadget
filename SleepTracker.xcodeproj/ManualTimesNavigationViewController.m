//
//  ManualTimesNavigationViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 4/7/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "ManualTimesNavigationViewController.h"


@implementation ManualTimesNavigationViewController

@synthesize dateArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tableViewData = [[NSArray alloc] initWithObjects:@"Sleep Time",
                                                        @"Wake Up Time",nil];
        tempPicker = [[UIDatePicker alloc] init];
        
        // When a date is selected call a certain method
        [tempPicker addTarget:self action:@selector(dateChanged:) 
         forControlEvents:UIControlEventValueChanged];
        
        dateArray = [[NSMutableArray alloc] initWithObjects:[NSDate date], [NSDate date], nil];
        self.navigationController.navigationBar.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View Stuff

// Set up the number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Set up the number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableViewData count];
}

// Customize appearance
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
    switch ([indexPath row]) {
        case 0:
            [tempFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
        case 1:
            [tempFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
        default:
            break;
    }
    cell.textLabel.text = [tableViewData objectAtIndex:[indexPath row]];
    cell.detailTextLabel.text = [tempFormatter stringFromDate:[dateArray objectAtIndex:[indexPath row]]];
    return cell;
}

// Handle what happens when something is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Tell everything else which table view choise we're using
    currentSelection = [indexPath row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Present a date picker
    UIViewController *testCont = [[UIViewController alloc] init];
    [tempPicker setDate:[dateArray objectAtIndex:[indexPath row]] animated:NO];
    [testCont.view addSubview:tempPicker];
    UIColor *dateColor = [[UIColor alloc] initWithRed:(41.0 / 255) 
                                                green:(42.0 / 255) 
                                                blue:(57.0 / 255) 
                                                alpha:1.0];
    [testCont.view setBackgroundColor:dateColor];
    [dateColor release];
    [testCont viewWillDisappear:YES];
    [self.navigationController pushViewController:testCont animated:YES];
    [testCont release];
}

#pragma mark - Navigation Bar Stuff

// Whenever a date is selected, update it
-(void)dateChanged:(UIDatePicker *)selectedDate {
    [dateArray replaceObjectAtIndex:currentSelection withObject:[selectedDate date]];
    [mainTableView reloadData];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateTable {
    [mainTableView reloadData];
}

- (void)dealloc
{
    [tempPicker release];
    [dateArray release];
    [tableViewData release];
    [super dealloc];
}

@end
