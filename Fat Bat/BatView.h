//
//  BatView.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BODY_RED 125.0/255.0
#define BODY_GREEN 0.0/255.0
#define BODY_BLUE 250.0/255.0

#define EAR_WING_RED 255.0/255.0
#define EAR_WING_GREEN 102.0/255.0
#define EAR_WING_BLUE 255.0/255.0

@interface BatView : UIView

-(id)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth;

-(void)setAngle:(CGFloat)angle;

-(void)setIsDiving:(BOOL)isDiving;

-(BOOL)isDiving;

@end
