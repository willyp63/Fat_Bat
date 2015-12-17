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
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:OUTER_CAVE_RED green:OUTER_CAVE_GREEN blue:OUTER_CAVE_BLUE alpha:1.0];
    
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //init and add play button to root view
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake((screenSize.width - PLAY_BUTTON_WIDTH)/2.0, (screenSize.height - PLAY_BUTTON_HEIGHT - statusBarHeight)/2.0, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT);
    playButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    playButton.layer.borderWidth = BORDER_WIDTH;
    playButton.layer.borderColor = [UIColor blackColor].CGColor;
    playButton.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    [playButton addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playButton];
    
    //init and add label to play button view
    UILabel *playButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
    playButtonLabel.text = @"play";
    playButtonLabel.textAlignment = NSTextAlignmentCenter;
    playButtonLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    [playButton addSubview:playButtonLabel];
    
    //init and add label to play button view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenSize.width - TITLE_LABEL_WIDTH)/2.0, (playButton.frame.origin.y - TITLE_LABEL_HEIGHT - statusBarHeight)/2.0, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    titleLabel.text = @"Fat Bat";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:FONT_NAME size:TITLE_FONT_SIZE];
    [self.view addSubview:titleLabel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}

-(void)playGame{
    //init level select controller
    LevelSelectViewController *viewController = [[LevelSelectViewController alloc] init];
    
    // Push the view controller.
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
