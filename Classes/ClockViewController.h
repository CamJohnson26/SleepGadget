//
//  FirstViewController.h
//  SleepTracker
//
//  Created by Cameron Johnson on 2/17/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DateAndTime.h"
#import "AlarmSetterView.h"
#import "Alarm.h"
#import "MusicPlayer.h"
#import "TrackedData.h"
#import "SleepTrackerAppDelegate.h"
#import "SleepDateObject.h"

@interface ClockViewController : UIViewController <AlarmSetterViewDelegate> {
	IBOutlet UILabel *clockLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *alarmLabel;
	IBOutlet UILabel *currentSongLabel;
	IBOutlet UILabel *currentArtistLabel;
	IBOutlet UILabel *currentAlbumLabel;
	IBOutlet UIButton *sleepTrackerButton;
	IBOutlet UIImageView *albumArtwork;
	NSTimer *updateClockTimer;
	MPMusicPlayerController *mainMusicPlayer1;
	TrackedData *mainTrackedData;
	Alarm *mainAlarm;
}

-(void)updateLabels;
-(void)updateDateAndTime;
- (void)handleNowPlayingItemChanged:(id)notification;
-(void)startTimer;
-(IBAction)addAlarmInitiated;
-(IBAction)pauseMusic;
-(IBAction)musicNextSong;
-(IBAction)musicLastSong;
-(IBAction)sleepButton;

@property (nonatomic,retain) TrackedData *mainTrackedData;
@property (nonatomic,retain) Alarm *mainAlarm;

@end
