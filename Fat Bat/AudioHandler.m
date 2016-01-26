//
//  AudioHandler.m
//  Fat Bat
//
//  Created by Wil Pirino on 1/11/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import "AudioHandler.h"


@implementation AudioHandler

- (id)init{
    self = [super init];
    if (self) {
        //get paths for audio toggle files
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audioToggles.txt"];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"audio/audioToggles" ofType:@"txt"];
        
        NSString *audioToggleString;
        
        //check if documents file exists
        if(![[NSFileManager defaultManager] fileExistsAtPath:docPath]){
            //copy file from bundle
            audioToggleString = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
            [audioToggleString writeToFile:docPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }else{
            audioToggleString = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
        }
        
        //set toggles
        NSArray *words = [audioToggleString componentsSeparatedByString:@" "];
        if ([words[0] isEqualToString:@"NO"]) {
            _musicToggle = NO;
        }else{
            _musicToggle = YES;
        }
        if ([words[1] isEqualToString:@"NO"]) {
            _soundToggle = NO;
        }else{
            _soundToggle = YES;
        }
        
        //configure audio session
        self.audioSession = [AVAudioSession sharedInstance];
        
        if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
            [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:nil];
            self.backgroundMusicPlaying = NO;
        } else {
            [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
        }
        
        //alloc spcae for sound id's
        _sounds = [[NSMutableArray alloc] initWithCapacity:6];
        _numSounds = 0;
    }
    return self;
}

-(void)setMusicURL:(NSURL *)URL{
    //init audio player
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    _audioPlayer.numberOfLoops = -1;
    [_audioPlayer prepareToPlay];
}

- (void)tryPlayMusic {
    // If background music or other music is already playing, nothing more to do here
    if (!_musicToggle || self.backgroundMusicPlaying || [self.audioSession isOtherAudioPlaying]) {
        return;
    }
    
    //play music
    [_audioPlayer play];
    _backgroundMusicPlaying = YES;
}

-(void)stopMusic{
    [_audioPlayer stop];
    _backgroundMusicPlaying = NO;
}

-(void)pauseMusic{
    [_audioPlayer pause];
    _backgroundMusicPlaying = NO;
}

-(int)addSoundURL:(NSURL *)URL{
    //init audio player
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    [audioPlayer prepareToPlay];
    [_sounds addObject:audioPlayer];
    
    _numSounds++;
    return _numSounds - 1;
}

-(void)playSound:(int)soundNum{
    //check for valid num
    if (!_soundToggle || soundNum >= _numSounds) {
        return;
    }
    
    //play sound
    [[_sounds objectAtIndex:soundNum] play];
}

-(void)removeAllSounds{
    //alloc spcae for sound id's
    _sounds = [[NSMutableArray alloc] initWithCapacity:6];
    _numSounds = 0;
}

-(void)toggleMusic{
    _musicToggle = !_musicToggle;
    
    if (!_musicToggle) {
        [self stopMusic];
    }
    
    [self writeToggles];
}

-(void)toggleSound{
    _soundToggle = !_soundToggle;
    
    [self writeToggles];
}

-(void)writeToggles{
    //get new string
    NSString *newString = @"";
    if (_musicToggle) {
        newString = [newString stringByAppendingString:@"YES "];
    }else{
        newString = [newString stringByAppendingString:@"NO "];
    }
    if (_soundToggle) {
        newString = [newString stringByAppendingString:@"YES"];
    }else{
        newString = [newString stringByAppendingString:@"NO"];
    }
    
    //write to file
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audioToggles.txt"];
    [newString writeToFile:docPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
