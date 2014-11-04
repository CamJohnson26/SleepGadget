
//
//  SettingsViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 5/17/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

// Create constants for the tableview entries
//NSString* const SECTION_0 = @"Data";
//NSString* const SECTION_1 = @"Display";
//NSString* const SECTION_2 = @"Output";

#define SECTION_0 @"Data"
#define SECTION_1 @"Display"
#define SECTION_2 @"Output"
#define ENTRY_0_0 @"Target Sleep a Night"
#define ENTRY_0_1 @"Timer Delay"
#define ENTRY_0_2 @"Default Graph Type"
#define ENTRY_1_0 @"24 Hour Clock"
#define ENTRY_1_1 @"Show Seconds"
#define ENTRY_1_2 @"Default Graph Type"
#define ENTRY_2_0 @"Print Data"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)getViewType:(NSString *)inputString {
    NSString *returnString = @"blank";
    if (inputString == ENTRY_0_0) {
        returnString = @"label";
    } else if (inputString == ENTRY_0_1) {
        returnString = @"label";
    } else if (inputString == ENTRY_0_2) {
        returnString = @"label";
    } else if (inputString == ENTRY_1_0) {
        returnString = @"switch";
    } else if (inputString == ENTRY_1_1) {
        returnString = @"switch";
    } else if (inputString == ENTRY_1_2) {
        returnString = @"label";
    } else if (inputString == ENTRY_2_0) {
        returnString = @"blank";
    }
    return returnString;
}

- (void)dealloc
{
    [filledData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *data1 = [NSArray arrayWithObjects:SECTION_0, ENTRY_0_0,ENTRY_0_1, ENTRY_0_2, nil];
    NSArray *data2 = [NSArray arrayWithObjects:SECTION_1, ENTRY_1_0,ENTRY_1_1, ENTRY_1_2, nil];
    NSArray *data3 = [NSArray arrayWithObjects:SECTION_2, ENTRY_2_0, nil];
    filledData = [[NSMutableArray alloc] initWithObjects:data1,data2,data3, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [filledData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[filledData objectAtIndex:section] count] - 1;
}

-(void)switch1Activated:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UISwitch *tempSwitch = sender;
    [defaults setBool:tempSwitch.on forKey:@"24hourclock"];
    NSLog(@"%@",[defaults boolForKey:@"24hourclock"]);
}

-(void)switch2Activated:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UISwitch *tempSwitch = sender;
    [defaults setBool:tempSwitch.on forKey:@"showseconds"];
    NSLog(@"%@",[defaults boolForKey:@"showseconds"]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[filledData objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] + 1];
    //[cell setAccessoryView:[self getViewType:[[filledData objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]]];
    NSString *viewType = [self getViewType:[[filledData objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] + 1]];
    if (viewType == @"switch") {
        UISwitch *tempSwitch = [[UISwitch alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"Main 2: %@",[defaults valueForKey:@"24hourclock"]);
        NSLog(@"Main 1: %@",[defaults valueForKey:@"showseconds"]);
        if ([indexPath section] == 1 && [indexPath row] == 0) {
            [tempSwitch addTarget:self 
                           action:@selector(switch1Activated:)
                 forControlEvents:UIControlEventValueChanged];
            if ([defaults boolForKey:@"24hourclock"]) {
                tempSwitch.on = YES;
            } else {
                tempSwitch.on = NO;
            }
        } else if ([indexPath section] == 1 && [indexPath row] == 1) {
            [tempSwitch addTarget:self 
                           action:@selector(switch2Activated:)
                 forControlEvents:UIControlEventValueChanged];
            if ([defaults boolForKey:@"showseconds"]) {
                tempSwitch.on = YES;
            } else {
                tempSwitch.on = NO;
            }
        } 
        cell.accessoryView = tempSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [tempSwitch release];
    } else if (viewType == @"label") {
        cell.detailTextLabel.text = @"WASSUP!!!";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

// Handle selections
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *viewType = [self getViewType:[[filledData objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] + 1]];
    
    if (viewType == @"label") {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (viewType == @"blank") {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// Setup the tableview section headers
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // This should be the first element in the section of the array
    return [[filledData objectAtIndex:section] objectAtIndex:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


@end
