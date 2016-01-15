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
    [_audioHandler setMusicURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio/fatbat_title_song" ofType:@"mp3"]]];
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
    
    
    //init and add title lable
    CGRect titleViewFrame = CGRectMake((screenSize.width - TITLE_LABEL_WIDTH*scaleX)/2.0, statusBarHeight + screenSize.height/4.0 - TITLE_LABEL_HEIGHT*scaleY/2.0, TITLE_LABEL_WIDTH*scaleX, TITLE_LABEL_HEIGHT*scaleY);
    TitleView *titleView = [[TitleView alloc] initWithFrame:titleViewFrame text:@"Fat Bat" font:[UIFont fontWithName:FONT_NAME size:TITLE_FONT_SIZE*scaleX] color:[UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0] borderWidth:BORDER_WIDTH*scaleY];
    [self.view addSubview:titleView];
    
    
    //init play button and add to root view
    CGRect playButtonFrame = CGRectMake((screenSize.width - PLAY_BUTTON_WIDTH*scaleX)/2.0, statusBarHeight + screenSize.height*5.0/8.0 - PLAY_BUTTON_HEIGHT*scaleY/2.0, PLAY_BUTTON_WIDTH*scaleX, PLAY_BUTTON_HEIGHT*scaleY);
    MyButton *playButton = [[MyButton alloc] initWithFrame:playButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"play" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY] responder:self];
    [self.view addSubview:playButton];
    
    
    //ADD MUSIC BUTTON
    CGRect musicButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH*scaleY - GAME_BUTTON_OFFSET*scaleY, GAME_BUTTON_OFFSET*scaleY + statusBarHeight, GAME_BUTTON_WIDTH*scaleY, GAME_BUTTON_HEIGHT*scaleY);
    
    _musicButton = [[MyButton alloc] initWithFrame:musicButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"MUS" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY/2.0] responder:self];
    [_musicButton setIsToggleButton:YES];
    [_musicButton setToggle:!_audioHandler.musicToggle];
    [self.view addSubview:_musicButton];
    
    //ADD SOUND BUTTON
    CGRect soundButtonFrame = CGRectMake(musicButtonFrame.origin.x - GAME_BUTTON_WIDTH*scaleY - GAME_BUTTON_OFFSET*scaleY, musicButtonFrame.origin.y, musicButtonFrame.size.width, musicButtonFrame.size.height);
    
    _soundButton = [[MyButton alloc] initWithFrame:soundButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"SFX" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY/2.0] responder:self];
    [_soundButton setIsToggleButton:YES];
    [_soundButton setToggle:!_audioHandler.soundToggle];
    [self.view addSubview:_soundButton];
    
    
    //init reset button and add to root view
    CGRect resetButtonFrame = CGRectMake(GAME_BUTTON_OFFSET*scaleX, GAME_BUTTON_OFFSET*scaleY + statusBarHeight, GAME_BUTTON_WIDTH*scaleX, GAME_BUTTON_HEIGHT*scaleY);
    MyButton *resetButton = [[MyButton alloc] initWithFrame:resetButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"reset" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleX] responder:self];
    [self.view addSubview:resetButton];
    
     
    /*
    //init create button and add to root view
    CGRect createButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH*scaleX - GAME_BUTTON_OFFSET*scaleX, GAME_BUTTON_OFFSET*scaleY + statusBarHeight, GAME_BUTTON_WIDTH*scaleX, GAME_BUTTON_HEIGHT*scaleY);
    MyButton *createButton = [[MyButton alloc] initWithFrame:createButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"create" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleX] responder:self];
    [self.view addSubview:createButton];
    */
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
    if ([button.text isEqualToString:@"play"]) {
        // Push level select view controller
        [self.navigationController pushViewController:[[LevelSelectViewController alloc] initWithAudioHandler:_audioHandler] animated:YES];
    }
    //SFX BUTTON PRESSED
    else if ([button.text isEqualToString:@"SFX"]) {
        [_audioHandler toggleSound];
    }
    //MUS BUTTON PRESSED
    else if ([button.text isEqualToString:@"MUS"]) {
        [_audioHandler toggleMusic];
        
        if (_audioHandler.musicToggle) {
            [_audioHandler tryPlayMusic];
        }
    }
    //RESET BUTTON PRESSED
    else if ([button.text isEqualToString:@"reset"]) {
        //reset levels file
        [LevelFileHandler writeLevelsToDocuments];
    }
    //CREATE BUTTON PRESSED
    else if ([button.text isEqualToString:@"create"]) {
        // Push level creation view controller
        [self.navigationController pushViewController:[[LevelFileSelectViewController alloc] init] animated:YES];
    }
}

@end
