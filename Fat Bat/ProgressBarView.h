//
//  ProgressBarView.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/28/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarView : UIView

-(id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth color1:(UIColor *)color1 color2:(UIColor *)color2;

-(void)setProgress:(CGFloat)progress;

@end
