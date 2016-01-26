//
//  AudioHandler.h
//  Fat Bat
//
//  Created by Wil Pirino on 1/11/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


#define NUM_SUPPORTED_SOUNDS 6

@interface AudioHandler : NSObject

-(void)setMusicURL:(NSURL *)URL;
-(void)tryPlayMusic;
-(void)pauseMusic;
-(void)stopMusic;

-(int)addSoundURL:(NSURL *)URL;
-(void)playSound:(int)soundNum;
-(void)removeAllSounds;

-(void)toggleMusic;
-(void)toggleSound;


@property (strong, nonatomic) AVAudioSession *audioSession;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (assign) BOOL backgroundMusicPlaying;


@property (strong, nonatomic) NSMutableArray<AVAudioPlayer *> *sounds;
@property (assign) int numSounds;

@property BOOL soundToggle;
@property BOOL musicToggle;

@end
