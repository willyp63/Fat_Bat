//
//  LevelSelectViewController.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LevelFileHandler.h"
#import "AudioHandler.h"
#import "GameViewController.h"
#import "TitleView.h"
#import "CheckMarkView.h"

@interface LevelSelectViewController : UITableViewController

-(id)initWithAudioHandler:(AudioHandler *)audioHandler;

@property NSArray<NSString *> *lines;
@property UIView *selectionView;

@property AudioHandler *audioHandler;

@end
