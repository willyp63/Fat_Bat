//
//  GameObjectModel.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameObjectModel : NSObject

-(id)initWithFrame:(CGRect)frame;

-(void)update;

@property CGRect frame;
@property CGPoint velocity;

@end
