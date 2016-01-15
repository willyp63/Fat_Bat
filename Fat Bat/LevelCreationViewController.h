//
//  LevelCreationViewController.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/19/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIDefinitions.h"
#import "LevelFileHandler.h"

@interface LevelCreationViewController : UIViewController <UITextViewDelegate>

@property UITextView *textView;
@property NSString *text;

-(id)initWithText:(NSString *)text;

@end
