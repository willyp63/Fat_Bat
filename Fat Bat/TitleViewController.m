//
//  TitleViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController

static CGFloat BUTTON_WIDTH = 160.0;
static CGFloat BUTTON_HEIGHT = 80.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //init and add pause button to root view
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake((screenSize.width - BUTTON_WIDTH)/2.0, (screenSize.height - BUTTON_HEIGHT - statusBarHeight)/2.0, BUTTON_WIDTH, BUTTON_HEIGHT);
    playButton.layer.borderWidth = 4.0;
    playButton.layer.borderColor = [UIColor blackColor].CGColor;
    playButton.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    [playButton addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playButton];
    
    //init and add label to pause button view
    UILabel *playButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    playButtonLabel.text = @"play";
    playButtonLabel.textAlignment = NSTextAlignmentCenter;
    playButtonLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [playButton addSubview:playButtonLabel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)playGame{
    LevelSelectViewController *viewController = [[LevelSelectViewController alloc] init];
    
    // Push the view controller.
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
