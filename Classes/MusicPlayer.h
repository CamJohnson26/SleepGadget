//
//  MusicPlayer.h
//  SleepTracker
//
//  Created by Cameron Johnson on 2/20/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface MusicPlayer : NSObject {
	MPMusicPlayerController *musicController;
}

-(void)startMusic;
-(void)pauseMusic;
-(void)nextSong;
-(void)lastSong;
-(NSString *)currentSong;
-(NSString *)currentArtist;
-(NSString *)currentAlbum;
-(UIImage *)currentImage;

@end
