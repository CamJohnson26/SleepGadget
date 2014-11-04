//
//  FirstViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 2/17/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "ClockViewController.h"


@implementation ClockViewController

@synthesize mainAlarm;
@synthesize mainTrackedData;

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Additional setup after loading the view
- (void)viewDidLoad {
	
	// Setup the music player
	mainMusicPlayer1 = [MPMusicPlayerController iPodMusicPlayer];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleNowPlayingItemChanged:) 
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
											   object:mainMusicPlayer1];
	[mainMusicPlayer1 beginGeneratingPlaybackNotifications];
	
	// Start the timer to update the clock and date
	[self startTimer];
	mainAlarm = [[Alarm alloc] init];
	mainTrackedData = [[TrackedData alloc] init];
	
	// This should set the app to ignore the silent switch
	AudioSessionInitialize (NULL, NULL, NULL, NULL);
	AudioSessionSetActive(true);
	
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, 
							 sizeof(sessionCategory),&sessionCategory);	
	
	// Update music labels
	[self updateLabels];
    
	// Call the super's viewDidLoad
    [super viewDidLoad];
}

// Called whenever the music now playing item changes
- (void)handleNowPlayingItemChanged:(id)notification {
	[self updateLabels];
	NSLog(@"Now Playing Changed");
}

// Update the music labels and images
-(void)updateLabels {
	
	// Initialize the media item
	MPMediaItem *nowPlayingMediaItem = [mainMusicPlayer1 nowPlayingItem];
	
	// Get the song title, artist, album, and album art
	NSString *songTitle = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyTitle];
	NSString *artistTitle = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtist];
	NSString *albumTitle = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	MPMediaItemArtwork *songArtwork = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtwork];
	
	// Set the label of the music player
	[currentSongLabel setText:songTitle];
	[currentArtistLabel setText:artistTitle];
	[currentAlbumLabel setText:albumTitle];
	[albumArtwork setImage:[songArtwork imageWithSize:CGSizeMake(64, 64)]];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// Update the date and time
-(void)updateDateAndTime {
	
	// Create a DateAndTime class and use it to set the label text to the current time
	DateAndTime *myDateAndTime = [[DateAndTime alloc] init];
	NSString *currentTime = [myDateAndTime getCurrentTime];
	NSString *currentDate = [myDateAndTime getCurrentDate];
	[clockLabel setText:currentTime];
	
	// Check and see if our date is correct
	if (![currentDate isEqual:[dateLabel text]]) {
		[dateLabel setText:currentDate];
	}
		
	// If the alarm is enabled
	if ([mainAlarm isEnabled]) {
		
		// Extract the current hour and minute
		NSCalendar *tempCalendar = [NSCalendar currentCalendar];
		NSDateComponents *tempComponents = [tempCalendar components:kCFCalendarUnitHour | kCFCalendarUnitMinute 
														   fromDate:[myDateAndTime getCurrentNSDate]];
		int currentHours = [tempComponents hour];
		int currentMinutes = [tempComponents minute];
		
		// Test and see if the alarm matches the current time
		if (currentHours == [mainAlarm alarmHours] && 
			currentMinutes == [mainAlarm alarmMinutes]) {
			
			// Alert the user that their alarm went off
			//	This needs to be moved to it's own class, eventually
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Alarm!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release]; 
			AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
			
			// Play a sound
			SystemSoundID bell;  
			AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Robby" ofType:@"wav"]], &bell);  
			AudioServicesPlaySystemSound (bell);
			
			// Disable the alarm
			[mainAlarm disableAlarm];
		}
	}
	
	// Release Date and Time
	[myDateAndTime release];
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
        self.title = @"Failed Banks"; 
        [fetchRequest release];
        
        NSManagedObject *sleepDateObject = [sleepTrackerSleepDateObject objectAtIndex:0];
        [sleepDateObject setValue:tempDate forKey:@"EndDate"];
        [tempDate release];
        NSError *error1 = nil;
        [context save:&error1];
		// Update the label
		[sleepTrackerButton setTitle:@"Go to Bed" forState:UIControlStateNormal];
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
            [tempDate release];
            NSError *error2 = nil;
            [context save:&error2];
            
			// Update the label
			[sleepTrackerButton setTitle:@"Wake Up" forState:UIControlStateNormal];
		}
	}
}

// Add an alarm
-(IBAction)addAlarmInitiated {
	
	// Create an alarm setter view and present it
	AlarmSetterView *mainAlarmSetter = [[AlarmSetterView alloc] init];
	mainAlarmSetter.delegate = self;
	[self presentModalViewController:mainAlarmSetter animated:YES];
	[mainAlarmSetter release];
}

// Deal with the result of creating a new alarm
- (void)AlarmSetterView:(AlarmSetterView *)controller dismissedView:(NSDate *)selectedDate {
    
	// Set an alarm 
	[mainAlarm setAlarmTime:selectedDate];
    
	// Set alarm label to whatever the current alarm is
	NSDateFormatter *temporaryDateFormatter = [[NSDateFormatter alloc] init];
	[temporaryDateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[alarmLabel setText:[temporaryDateFormatter stringFromDate:selectedDate]];
	[temporaryDateFormatter release];
}

// Pause and skip music
-(IBAction)pauseMusic {
	if ([mainMusicPlayer1 playbackState] == MPMusicPlaybackStatePlaying) {
		[mainMusicPlayer1 pause];
		NSLog(@"Paused");
	} else {
		if ([mainMusicPlayer1 playbackState] == MPMusicPlaybackStatePaused) {
			[mainMusicPlayer1 play];
			NSLog(@"Played");
		}
	}
	[self updateLabels];
}
-(IBAction)musicNextSong {
	[mainMusicPlayer1 skipToNextItem];
	[self updateLabels];
}
-(IBAction)musicLastSong {
	[mainMusicPlayer1 skipToPreviousItem];
	[self updateLabels];
}

// Start the timer, which updates the clock every 0.5 seconds and checks whether to update the date
-(void)startTimer {
	updateClockTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
								target:self 
								selector:@selector(updateDateAndTime) 
								userInfo:nil 
								repeats:YES];
}

- (void)dealloc {
	[updateClockTimer release];
	[mainAlarm release];
	[mainTrackedData release];
    [super dealloc];
}

@end
