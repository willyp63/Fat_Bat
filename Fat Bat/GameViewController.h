//
//  ViewController.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/12/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "UIDefinitions.h"
#import "LevelFileHandler.h"
#import "AudioHandler.h"
#import "MyButton.h"
#import "BatView.h"
#import "StalagmiteView.h"
#import "FinishLineView.h"
#import "ProgressBarView.h"
#import "GameModel.h"


@interface GameViewController : UIViewController <MyButtonResponder>


-(id)initWithLevelName:(NSString *)levelName audioHandler:(AudioHandler *)audioHandler;


@property NSString *levelName;

@property UIButton *holdButton;
@property MyButton *pauseButton;
@property MyButton *quitButton;

@property MyButton *musicButton;
@property MyButton *soundButton;

@property ProgressBarView *progressBar;

@property UIView *caveFloorView;
@property UIView *caveCeilingView;

@property UIColor *outerCaveColor;

@property FinishLineView *finishLineView;

@property BatView *batView;
@property NSMutableArray<StalagmiteView *> *stalagmiteViews;

@property GameModel *model;
@property NSTimer *updateTimer;

@property AudioHandler *audioHandler;


@end

