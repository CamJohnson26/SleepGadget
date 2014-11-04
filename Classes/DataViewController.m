//
//  DataViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 3/31/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "DataViewController.h"


@implementation DataViewController

@synthesize mainTrackedData;
@synthesize sleepDateArray;
@synthesize sleepTrackerSleepDateObject = _sleepTrackerSleepDateObject;
@synthesize context = _context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _context = [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Start the timer to update the clock and date
	[self startTimer];
    
    // Set up the tracked data
    mainTrackedData = [[TrackedData alloc] init];
    
    // Set up the modal view controller
    manualTimesVC = [[ManualTimesNavigationViewController alloc] init];
    editTimesVC = [[ManualTimesNavigationViewController alloc] init];
    
    // Update the table
    [self updateTable];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setOrientation:[UIDevice currentDevice].orientation animated:NO];
}
// Update the table
-(void)updateTable {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *tempSortDescripter = [[NSSortDescriptor alloc] initWithKey:@"StartTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:tempSortDescripter]];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"SleepDateObject" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.sleepTrackerSleepDateObject = [_context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    [mainTableView reloadData];
}

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_sleepTrackerSleepDateObject count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"defaultCellId";
    
    DefaultCellView *cell = (DefaultCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[DefaultCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:@"DefaultCellView" owner:self options:nil];
        cell = tblCell;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
	// A date formatter for the time stamp.
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d \th:mm"];
    }
	SleepDateObject *sleepDateObject = (SleepDateObject *)[_sleepTrackerSleepDateObject objectAtIndex:indexPath.row];
    
    [cell setTextLabelText:[dateFormatter stringFromDate:[sleepDateObject StartTime]]];
    
    // Calculate the number of hours and minutes slept and write them in
    int timeSlept = (int)[[sleepDateObject StartTime] timeIntervalSinceDate:[sleepDateObject EndDate]];
    [cell setDetailLabelText:[NSString stringWithFormat:@"%d:%02d",abs((timeSlept / 3600)),abs((timeSlept / 60))% 60]];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [mainTableView beginUpdates];

        // Delete the current object from our array
        [_context deleteObject:[_sleepTrackerSleepDateObject objectAtIndex:[indexPath row]]];
        
        // Delete the row from the data source.
        [mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        // Save the context.
        NSError *error = nil;
        if (![_context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Update everything
        [self updateTable];
        [mainTableView endUpdates];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Edit the sleep time at the selected row
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                     target:self 
                                     action:@selector(cancelButtonPressed)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                   target:self 
                                   action:@selector(saveEditButtonPressed)];
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *tempFont = [UIFont boldSystemFontOfSize:20.0];
    deleteButton.frame = CGRectMake(10, 338, 300, 44);
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = tempFont;
    [deleteButton.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
    UIImage *tempImage = [UIImage imageNamed:@"DeleteButton.png"];
    [deleteButton setBackgroundImage:tempImage forState:UIControlStateNormal];
    [deleteButton   addTarget:self 
                       action:@selector(deleteButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    
    [editTimesVC.view addSubview:deleteButton];
    [editTimesVC.navigationItem setLeftBarButtonItem:cancelButton];
    [editTimesVC.navigationItem setRightBarButtonItem:saveButton];
    [editTimesVC setTitle:@"Edit Time"];
    
    // Fill in the data
    [[editTimesVC dateArray] replaceObjectAtIndex:0 
                            withObject:[[_sleepTrackerSleepDateObject objectAtIndex:indexPath.row] StartTime]];
    [[editTimesVC dateArray] replaceObjectAtIndex:1
                            withObject:[[_sleepTrackerSleepDateObject objectAtIndex:indexPath.row] EndDate]];
    [navigationController pushViewController:editTimesVC animated:FALSE];
    [editTimesVC updateTable];
    [self presentModalViewController:navigationController animated:TRUE];
}

// Delete a sleep time
-(void)deleteButtonPressed {

    // Delete the current object from our array
    [_context deleteObject:[_sleepTrackerSleepDateObject objectAtIndex:uglyVar]];
    
    // Save the context.
    NSError *error = nil;
    if (![_context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Remove the view and update the table
    [self dismissModalViewControllerAnimated:TRUE];
    [self updateTable];
    
}
// Save an edited sleep time
-(void)saveEditButtonPressed {
    
    // Get the manual sleep times
    NSMutableArray *tempDateArray = [editTimesVC dateArray];
    
    // Add the sleep times to coredata
    NSManagedObjectContext *context = [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    SleepDateObject *sleepDateObject = (SleepDateObject *)[_sleepTrackerSleepDateObject objectAtIndex:uglyVar];
    [sleepDateObject setValue:[tempDateArray objectAtIndex:0] forKey:@"StartTime"];
    [sleepDateObject setValue:[tempDateArray objectAtIndex:1] forKey:@"EndDate"];
    NSError *error2 = nil;
    [context save:&error2];
    
    // Remove the view and update the table
    [self dismissModalViewControllerAnimated:TRUE];
    [self updateTable];
}

// Update the date and time
-(void)updateDateAndTime {
	
	// Create a DateAndTime class and use it to set the label text to the current time
	DateAndTime *myDateAndTime = [[DateAndTime alloc] init];
	NSString *currentTime = [myDateAndTime getCurrentTime];
	NSString *currentDate = [myDateAndTime getCurrentDate];
	[timeLabel setText:currentTime];
	
	// Check and see if our date is correct
	if (![currentDate isEqual:[dateLabel text]]) {
		[dateLabel setText:currentDate];
	}
	
	// Release Date and Time
	[myDateAndTime release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Start the timer, which updates the clock every 0.5 seconds and checks whether to update the date
-(void) startTimer
{
    // Run the timer on a separate thread so that input events don't freeze it
    NSThread* timerThread = 
        [[NSThread alloc] initWithTarget:self selector:@selector(startTimerThread) object:nil];
    [timerThread start];
    [timerThread release];
}

//the thread starts by sending this message
-(void) startTimerThread
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    updateClockTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                        target:self 
                                                      selector:@selector(updateDateAndTime) 
                                                      userInfo:nil 
                                                       repeats:YES];
    [runLoop run];
    [pool release];
}

// Add a sleep time
-(IBAction)sleepButton {
    
	// If we need to wake up
	if ([mainTrackedData isSleeping] == TRUE) {
		
		// Tell the tracked data we woke up
		NSDate *currentDate = [[NSDate alloc] init];
		[mainTrackedData closeEntry:currentDate];
		[currentDate release];
        
        // Store wake up time in CoreData
        NSDate *tempDate = [[NSDate alloc] init];
        NSManagedObjectContext *context = [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"SleepDateObject" inManagedObjectContext:context];
        NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"StartTime" ascending:NO];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:dateSort]];
        NSError *error;
        NSArray *sleepTrackerSleepDateObject = [context executeFetchRequest:fetchRequest error:&error];
        self.title = @"Home";
        [fetchRequest release];
        
        NSManagedObject *sleepDateObject = [sleepTrackerSleepDateObject objectAtIndex:0];
        [sleepDateObject setValue:tempDate forKey:@"EndDate"];
        [tempDate release];
        NSError *error1 = nil;
        [context save:&error1];
		// Update the label
		[sleepButton setTitle:@"Sleep" forState:UIControlStateNormal];
        UIImage *tempImage = [UIImage imageNamed:@"Start_Button.png"];
        [sleepButton setBackgroundImage:tempImage forState:UIControlStateNormal];
	}
	
	// Otherwise, if we need to go to bed
	else { 
		if ([mainTrackedData isSleeping] == FALSE) {
			
			// Store the current date.
			NSDate *currentDate = [[NSDate alloc] init];
			[mainTrackedData addEntry:currentDate];
			[currentDate release];
            
            // Store sleep time in CoreData
            NSDate *tempDate = [[NSDate alloc] init];
            
            NSManagedObjectContext *context = [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            NSManagedObject *sleepDateObject = [NSEntityDescription
                                                insertNewObjectForEntityForName:@"SleepDateObject"
                                                inManagedObjectContext:context];
            [sleepDateObject setValue:tempDate forKey:@"StartTime"];
            [sleepDateObject setValue:[NSDate date] forKey:@"EndDate"];
            [tempDate release];
            NSError *error2 = nil;
            [context save:&error2];
            
			// Update the label
			[sleepButton setTitle:@"Wake Up" forState:UIControlStateNormal];
            UIImage *tempImage = [UIImage imageNamed:@"Stop_Button.png"];
            [sleepButton setBackgroundImage:tempImage forState:UIControlStateNormal];
		}
	}
    [self updateTable];
}

// Dismiss modal view
-(void)cancelButtonPressed {
    [self dismissModalViewControllerAnimated:TRUE];
}

// Store a manual sleep time
-(void)saveButtonPressed {
    
    // Get the manual sleep times
    NSMutableArray *tempDateArray = [manualTimesVC dateArray];
    
    // Add the sleep times to coredata
    NSManagedObjectContext *context = [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSManagedObject *sleepDateObject = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"SleepDateObject"
                                        inManagedObjectContext:context];
    [sleepDateObject setValue:[tempDateArray objectAtIndex:0] forKey:@"StartTime"];
    [sleepDateObject setValue:[tempDateArray objectAtIndex:1] forKey:@"EndDate"];
    NSError *error2 = nil;
    [context save:&error2];
    
    // Remove the view and update the table
    [self dismissModalViewControllerAnimated:TRUE];
    [self updateTable];
}

// Add a manual sleep time
-(IBAction)manualButton {
    
    // Create a view to add a new sleep time from
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                   target:self 
                                   action:@selector(cancelButtonPressed)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                   target:self 
                                   action:@selector(saveButtonPressed)];
    [manualTimesVC.navigationItem setLeftBarButtonItem:cancelButton];
    [manualTimesVC.navigationItem setRightBarButtonItem:saveButton];
    [manualTimesVC setTitle:@"Manual Time"];
    [navigationController pushViewController:manualTimesVC animated:FALSE];
    [self presentModalViewController:navigationController animated:TRUE];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setOrientation:toInterfaceOrientation animated:YES];
}

-(void)setOrientation:(UIInterfaceOrientation)toInterfaceOrientation animated:(BOOL)animated {
    if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        
        // Put the view back to normal since we're rotating from landscape        
        // Show views
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [timeLabel setAlpha:1.0];
            [dateLabel setAlpha:1.0];
            [sleepButton setAlpha:1.0];
            [manualButton setAlpha:1.0];
            [backgroundImage setAlpha:1.0];
        
            // Scale back the table view
            [mainTableView setFrame:CGRectMake(0, 210, self.view.frame.size.width, self.view.frame.size.height / 2)];
            [UIView commitAnimations];
        } else {
            [timeLabel setAlpha:1.0];
            [dateLabel setAlpha:1.0];
            [sleepButton setAlpha:1.0];
            [manualButton setAlpha:1.0];
            [backgroundImage setAlpha:1.0];
            
            // Scale back the table view
            [mainTableView setFrame:CGRectMake(0, 210, self.view.frame.size.width, self.view.frame.size.height / 2)];
        }
    } else if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        
        // Configure the view so that only the main data is shown since we're rotating from portrait        
        // Hide views
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [backgroundImage setAlpha:0];
            [timeLabel setAlpha:0];
            [dateLabel setAlpha:0];
            [sleepButton setAlpha:0];
            [manualButton setAlpha:0];
            
            // Scale up the table view
            [mainTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [UIView commitAnimations];
        } else {
            [backgroundImage setAlpha:0];
            [timeLabel setAlpha:0];
            [dateLabel setAlpha:0];
            [sleepButton setAlpha:0];
            [manualButton setAlpha:0];
            
            // Scale up the table view
            [mainTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];            
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc
{
    [manualTimesVC release];
    [editTimesVC release];
    self.sleepTrackerSleepDateObject = nil;
    self.context = nil;
    [super dealloc];
}

@end
