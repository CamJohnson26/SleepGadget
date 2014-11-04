//
//  SleepTrackerListViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 3/10/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "SleepTrackerListViewController.h"
#import "SleepDateObject.h"


@implementation SleepTrackerListViewController

@synthesize sleepDateArray;
@synthesize sleepTrackerSleepDateObject = _sleepTrackerSleepDateObject;
@synthesize context = _context;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    _context = [(SleepTrackerAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self updateTable];
    self.title = @"List";
    [dataTableView setBackgroundColor:[UIColor grayColor]];
    [dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [dataTableView setTableHeaderView:nil];
    [dataTableView setRowHeight:50.0];

	/*	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];*/
}

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
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


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
    
    // Configure the cell...
	// A date formatter for the time stamp.
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d \thh:mm"];
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
        
        // Delete the current object from our array
        [_context deleteObject:[_sleepTrackerSleepDateObject objectAtIndex:[indexPath row]]];
        
        // Delete the row from the data source.
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        // Save the context.
        NSError *error = nil;
        if (![_context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Update everything
        [self updateTable];
        [dataTableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
    [self updateTable];
    [dataTableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    self.sleepTrackerSleepDateObject = nil;
    self.context = nil;
    [super dealloc];
}


@end

