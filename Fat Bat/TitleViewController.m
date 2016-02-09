//
//  TitleViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //play music
    _audioHandler = [[AudioHandler alloc] init];
    [_audioHandler setMusicURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio/fatbat_title_song" ofType:@"caf"]]];
    [_audioHandler.audioPlayer setVolume:0.25];
    
    if(_audioHandler.musicToggle){
        [_audioHandler tryPlayMusic];
    }
    
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //get ui scale factors
    CGFloat scaleY = screenSize.height / IPHONE_6S_SCREEN_HEIGHT;
    CGFloat scaleX = screenSize.width / IPHONE_6S_SCREEN_WIDTH;
    
    
    //configure navigation bar for entire app
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0];
    
    //add border layer to navigation bar
    CALayer *navigationBarBorder = [CALayer layer];
    navigationBarBorder.frame = CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height - BORDER_WIDTH,
                                           self.navigationController.navigationBar.frame.size.width, BORDER_WIDTH);
    navigationBarBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.navigationController.navigationBar.layer addSublayer:navigationBarBorder];
    
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0];
    
    
    //init and add subtitle lable
    CGRect subtitleViewFrame = CGRectMake((screenSize.width - TITLE_LABEL_WIDTH*scaleX)/2.0 + TITLE_LABEL_WIDTH/10.0, statusBarHeight + (screenSize.height - SUBTITLE_LABEL_HEIGHT*scaleY)/2.0, TITLE_LABEL_WIDTH*scaleX, SUBTITLE_LABEL_HEIGHT*scaleY);
    TitleView *subtitleView = [[TitleView alloc] initWithFrame:subtitleViewFrame text:@"and the Colored Caverns" font:[UIFont fontWithName:FONT_NAME size:SUBTITLE_FONT_SIZE*scaleX] color:[UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0] borderWidth:BORDER_WIDTH*scaleY];
    [subtitleView alternateColors:@[[UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:0.0 alpha:1.0],
                                    [UIColor colorWithRed:255.0/255.0 green:205.0/255.0 blue:105.0/255.0 alpha:1.0],
                                    [UIColor colorWithRed:255.0/255.0 green:0.0 blue:0.0 alpha:1.0],
                                    [UIColor colorWithRed:0.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0],
                                    [UIColor colorWithRed:224.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]]];
    [self.view addSubview:subtitleView];
    
    
    //init and add title lable
    CGRect titleViewFrame = CGRectMake((screenSize.width - TITLE_LABEL_WIDTH*scaleX)/2.0 - TITLE_LABEL_WIDTH/10.0, subtitleViewFrame.origin.y - GAME_BUTTON_OFFSET*2.0*scaleY - TITLE_LABEL_HEIGHT*scaleY, TITLE_LABEL_WIDTH*scaleX, TITLE_LABEL_HEIGHT*scaleY);
    TitleView *titleView = [[TitleView alloc] initWithFrame:titleViewFrame text:@"Fat Bat" font:[UIFont fontWithName:FONT_NAME size:TITLE_FONT_SIZE*scaleX] color:[UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0] borderWidth:BORDER_WIDTH*scaleY];
    [self.view addSubview:titleView];
    
    
    //init play button and add to root view
    CGRect playButtonFrame = CGRectMake((screenSize.width - PLAY_BUTTON_WIDTH*scaleX)/2.0, subtitleViewFrame.origin.y + subtitleViewFrame.size.height + GAME_BUTTON_OFFSET*6.0*scaleY, PLAY_BUTTON_WIDTH*scaleX, PLAY_BUTTON_HEIGHT*scaleY);
    MyButton *playButton = [[MyButton alloc] initWithFrame:playButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"play" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY] responder:self];
    [self.view addSubview:playButton];
    
    
    //ADD MUSIC BUTTON
    CGRect musicButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH*2.0*scaleY - GAME_BUTTON_OFFSET*scaleY, GAME_BUTTON_OFFSET*scaleY + statusBarHeight, GAME_BUTTON_WIDTH*2.0*scaleY, GAME_BUTTON_HEIGHT*scaleY);
    
    _musicButton = [[MyButton alloc] initWithFrame:musicButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"MUSIC" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY/2.0] responder:self];
    [_musicButton setIsToggleButton:YES];
    [_musicButton setToggle:!_audioHandler.musicToggle];
    [self.view addSubview:_musicButton];
    
    //ADD SOUND BUTTON
    CGRect soundButtonFrame = CGRectMake(musicButtonFrame.origin.x - GAME_BUTTON_WIDTH*2.0*scaleY - GAME_BUTTON_OFFSET*scaleY, musicButtonFrame.origin.y, musicButtonFrame.size.width, musicButtonFrame.size.height);
    
    _soundButton = [[MyButton alloc] initWithFrame:soundButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"SOUND" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY/2.0] responder:self];
    [_soundButton setIsToggleButton:YES];
    [_soundButton setToggle:!_audioHandler.soundToggle];
    [self.view addSubview:_soundButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //hide navigation bar
    self.navigationController.navigationBarHidden = YES;
    
    //set toggles
    [_musicButton setToggle:!_audioHandler.musicToggle];
    [_soundButton setToggle:!_audioHandler.soundToggle];
}

-(void)buttonPressed:(MyButton *)button{
    //PLAY BUTTON PRESSED
    if ([button.textLabel.text isEqualToString:@"play"]) {
        // Push level select view controller
        [self.navigationController pushViewController:[[LevelSelectViewController alloc] initWithAudioHandler:_audioHandler] animated:YES];
    }
    //SFX BUTTON PRESSED
    else if ([button.textLabel.text isEqualToString:@"SOUND"]) {
        [_audioHandler toggleSound];
    }
    //MUS BUTTON PRESSED
    else if ([button.textLabel.text isEqualToString:@"MUSIC"]) {
        [_audioHandler toggleMusic];
        
        if (_audioHandler.musicToggle) {
            [_audioHandler tryPlayMusic];
        }
    }
}

@end
