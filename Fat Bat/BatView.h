//
//  BatView.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDefinitions.h"


@interface BatView : UIView

-(id)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth;

-(void)setAngle:(CGFloat)angle;

-(void)setIsDiving:(BOOL)isDiving;

-(BOOL)isDiving;

@end
