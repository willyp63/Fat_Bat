//
//  TitleViewController.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LevelFileHandler.h"
#import "AudioHandler.h"
#import "LevelSelectViewController.h"
#import "LevelFileSelectViewController.h"
#import "MyButton.h"
#import "TitleView.h"

@interface TitleViewController : UIViewController <MyButtonResponder>

@property MyButton *resetButton;

@property AudioHandler *audioHandler;

@property MyButton *musicButton;
@property MyButton *soundButton;

@end
