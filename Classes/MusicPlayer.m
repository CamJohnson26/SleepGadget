//
//  MusicPlayer.m
//  SleepTracker
//
//  Created by Cameron Johnson on 2/20/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "MusicPlayer.h"


@implementation MusicPlayer

// Initialize the class the first time
-(id)init {
	if (self = [super init]) {
		
		// At first, it's not enabled
		musicController = [MPMusicPlayerController iPodMusicPlayer];
		
	}
	return self;
}

// Play the music
-(void)playMusic {
	[musicController play];
}

// Pause the music
-(void)pauseMusic {
	[musicController pause];
}

// Go to the next song
-(void)nextSong {
	[musicController skipToNextItem];
}

// Go to the last song
-(void)lastSong {
	[musicController skipToPreviousItem];
}

// Return the name of the currently playing song
-(NSString *)currentSong {
	
	// Initialize the media item
	MPMediaItem *nowPlayingMediaItem = [musicController nowPlayingItem];
	
	// Return the song title
	NSString *songTitle = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyTitle];
	return songTitle;
}

// Return the name of the currently playing artist
-(NSString *)currentArtist {
	
	// Initialize the media item
	MPMediaItem *nowPlayingMediaItem = [musicController nowPlayingItem];
	
	// Return the song title
	NSString *songArtist = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtist];
	return songArtist;
}

// Return the name of the currently playing album
-(NSString *)currentAlbum {
	
	// Initialize the media item
	MPMediaItem *nowPlayingMediaItem = [musicController nowPlayingItem];
	
	// Return the song title
	NSString *songAlbum = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	return songAlbum;
}

// Return the album art
-(UIImage *)currentImage {
	
	// Initialize the media item
	MPMediaItem *nowPlayingMediaItem = [musicController nowPlayingItem];
	
	// Return the song title
	MPMediaItemArtwork *songArtwork = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtwork];
	return [songArtwork imageWithSize:CGSizeMake(64, 64)];
}

@end
