//
//  ViewController.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/12/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BatView.h"
#import "GameModel.h"

@interface GameViewController : UIViewController

-(id)initWithLevelName:(NSString *)levelName;

@property BOOL paused;

@property NSString *levelName;

@property UIButton *holdButton;
@property UIButton *pauseButton;
@property UIButton *quitButton;

@property UIView *finishLineView;

@property BatView *batView;
@property NSMutableArray<UIView *> *stalagmiteViews;

@property GameModel *model;
@property NSTimer *updateTimer;

@end

