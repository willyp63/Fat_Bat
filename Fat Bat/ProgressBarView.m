//
//  ProgressBarView.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/28/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "ProgressBarView.h"

@implementation ProgressBarView{
    CALayer *_progressLayer;
}

-(id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth color1:(UIColor *)color1 color2:(UIColor *)color2{
    self = [super initWithFrame:frame];
    if (self) {
        //set bg layer
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.backgroundColor = color2.CGColor;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        //progress bar layer
        _progressLayer = [CALayer layer];
        _progressLayer.frame = CGRectMake(0.0, 0.0, 0.0, self.bounds.size.height);
        _progressLayer.borderWidth = borderWidth;
        _progressLayer.cornerRadius = cornerRadius;
        _progressLayer.backgroundColor = color1.CGColor;
        _progressLayer.borderColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    if(progress < 0.0){progress = 0.0;}
    if (progress > 1.0) {progress = 1.0;}
    
    //move progress bar
    _progressLayer.frame = CGRectMake(0.0, 0.0, self.bounds.size.width * progress, self.bounds.size.height);
}

@end
