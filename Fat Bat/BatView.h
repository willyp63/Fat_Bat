//
//  BatView.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatView : UIView

-(void)setAngle:(CGFloat)angle;

-(void)setIsDiving:(BOOL)isDiving;

@property CAShapeLayer *wingLayer;

@end
