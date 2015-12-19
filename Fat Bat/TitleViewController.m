//
//  TitleViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController{
    UIButton *_resetButton;
    BOOL _reset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reset = NO;
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0];
    
    
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //init and add play button to root view
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake((screenSize.width - PLAY_BUTTON_WIDTH)/2.0, (screenSize.height - PLAY_BUTTON_HEIGHT - statusBarHeight)/2.0, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT);
    playButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    playButton.layer.borderWidth = BORDER_WIDTH;
    playButton.layer.borderColor = [UIColor blackColor].CGColor;
    playButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [playButton addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playButton];
    
    //init and add label to play button view
    UILabel *playButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
    playButtonLabel.text = @"play";
    playButtonLabel.textAlignment = NSTextAlignmentCenter;
    playButtonLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    [playButton addSubview:playButtonLabel];
    
    //init and add reset button to root view
    _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _resetButton.frame = CGRectMake(GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    _resetButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    _resetButton.layer.borderWidth = BORDER_WIDTH;
    _resetButton.layer.borderColor = [UIColor blackColor].CGColor;
    _resetButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [_resetButton addTarget:self action:@selector(resetGame) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_resetButton];
    
    //init and add label to reset button view
    UILabel *resetButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT)];
    resetButtonLabel.text = @"reset";
    resetButtonLabel.textAlignment = NSTextAlignmentCenter;
    resetButtonLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    [_resetButton addSubview:resetButtonLabel];
    
    //init and add label to play button view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenSize.width - TITLE_LABEL_WIDTH)/2.0, (playButton.frame.origin.y - TITLE_LABEL_HEIGHT - statusBarHeight)/2.0, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    titleLabel.text = @"Fat Bat";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:FONT_NAME size:TITLE_FONT_SIZE];
    [self.view addSubview:titleLabel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //reset reset flag
    _reset = NO;
    
    //ungray reset button
    _resetButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    //hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}

-(void)playGame{
    //init level select controller
    LevelSelectViewController *viewController = [[LevelSelectViewController alloc] init];
    
    // Push the view controller.
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)resetGame{
    //if reset do nothing
    if (_reset) {return;}
    
    //set flag
    _reset = YES;
    
    //gray reset button
    _resetButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    
    //reset levels file
    [LevelFileHandler resetLevelsFile];
}

@end
