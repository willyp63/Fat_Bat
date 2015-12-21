//
//  TitleViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController{
    MyButton *_resetButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure navigation bar
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0];
    
    //add border layer to navigation bar
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CALayer *navigationBarBorder = [CALayer layer];
    navigationBarBorder.frame = CGRectMake(0.0, navigationBarFrame.size.height - BORDER_WIDTH, navigationBarFrame.size.width, BORDER_WIDTH);
    navigationBarBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.navigationController.navigationBar.layer addSublayer:navigationBarBorder];
    
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0];
    
    
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    
    //init play button and add to root view
    CGRect playButtonFrame = CGRectMake((screenSize.width - PLAY_BUTTON_WIDTH)/2.0, (screenSize.height - PLAY_BUTTON_HEIGHT - statusBarHeight)/2.0, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT);
    MyButton *playButton = [[MyButton alloc] initWithFrame:playButtonFrame cornerRadius:BUTTON_CORNER_RADIUS borderWidth:BORDER_WIDTH color:[UIColor whiteColor] text:@"play" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE] responder:self];
    [self.view addSubview:playButton];
    
    
    //init reset button and add to root view
    CGRect resetButtonFrame = CGRectMake(GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    MyButton *resetButton = [[MyButton alloc] initWithFrame:resetButtonFrame cornerRadius:BUTTON_CORNER_RADIUS borderWidth:BORDER_WIDTH color:[UIColor whiteColor] text:@"reset" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE] responder:self];
    [self.view addSubview:resetButton];
    
    //init create button and add to root view
    CGRect createButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH - GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    MyButton *createButton = [[MyButton alloc] initWithFrame:createButtonFrame cornerRadius:BUTTON_CORNER_RADIUS borderWidth:BORDER_WIDTH color:[UIColor whiteColor] text:@"create" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE] responder:self];
    [self.view addSubview:createButton];
    
    
    //init and add title lable
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

-(void)buttonPressed:(MyButton *)button{
    //PLAY BUTTON PRESSED
    if ([button.text isEqualToString:@"play"]) {
        //init level select controller
        LevelSelectViewController *viewController = [[LevelSelectViewController alloc] init];
        
        // Push the view controller.
        [self.navigationController pushViewController:viewController animated:YES];
    }
    //RESET BUTTON PRESSED
    else if ([button.text isEqualToString:@"reset"]) {
        //reset levels file
        [LevelFileHandler writeLevelsToDocuments];
    }
    //create BUTTON PRESSED
    else if ([button.text isEqualToString:@"create"]) {
        //init level creation controller
        LevelFileSelectViewController *viewController = [[LevelFileSelectViewController alloc] init];
        
        // Push the view controller.
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
