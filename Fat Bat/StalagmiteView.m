//
//  StalagmiteView.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/16/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "StalagmiteView.h"

@implementation StalagmiteView

-(id)initWithFrame:(CGRect)frame color:(UIColor *)color borderWidth:(CGFloat)borderWidth facingDown:(BOOL)facingDown;{
    self = [super initWithFrame:frame];
    if (self) {
        //path
        UIBezierPath* path = [UIBezierPath bezierPath];
        CGFloat radius = self.bounds.size.width/2.0;
        
        if (facingDown) {
            [path moveToPoint:CGPointMake(-radius/2.0, borderWidth - 1.0)];
            [path addLineToPoint:CGPointMake(-radius/2.0, borderWidth)];
            [path addArcWithCenter:CGPointMake(-radius/2.0, radius/2.0 + borderWidth) radius:radius/2.0 startAngle:M_PI*3.0/2.0 endAngle:M_PI*2.0 clockwise:YES];
            [path addLineToPoint:CGPointMake(0.0, self.bounds.size.height - radius/2.0)];
            [path addArcWithCenter:CGPointMake(radius/2.0, self.bounds.size.height - radius/2.0) radius:radius/2.0 startAngle:M_PI endAngle:M_PI/2.0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width - radius/2.0, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - radius/2.0, self.bounds.size.height - radius/2.0) radius:radius/2.0 startAngle:M_PI/2.0 endAngle:0.0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width, radius/2.0 + borderWidth)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width + radius/2.0, radius/2.0 + borderWidth) radius:radius/2.0 startAngle:M_PI endAngle:M_PI*3.0/2.0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width + radius/2.0, borderWidth - 1.0)];
        }else{
            [path moveToPoint:CGPointMake(-radius/2.0, self.bounds.size.height - borderWidth + 1.0)];
            [path addLineToPoint:CGPointMake(-radius/2.0, self.bounds.size.height - borderWidth)];
            [path addArcWithCenter:CGPointMake(-radius/2.0, self.bounds.size.height - radius/2.0 - borderWidth) radius:radius/2.0 startAngle:M_PI/2.0 endAngle:0.0 clockwise:NO];
            [path addLineToPoint:CGPointMake(0.0, radius/2.0)];
            [path addArcWithCenter:CGPointMake(radius/2.0, radius/2.0) radius:radius/2.0 startAngle:M_PI endAngle:M_PI*3.0/2.0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width - radius/2.0, 0.0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - radius/2.0, radius/2.0) radius:radius/2.0 startAngle:M_PI*3.0/2.0 endAngle:M_PI*2.0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - radius/2.0 - borderWidth)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width + radius/2.0, self.bounds.size.height - radius/2.0 - borderWidth) radius:radius/2.0 startAngle:M_PI endAngle:M_PI/2.0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width + radius/2.0, self.bounds.size.height - borderWidth + 1.0)];
        }
    
        
        //create shape layer and add to root layer
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.position = CGPointMake(0.0, 0.0);
        shapeLayer.lineWidth = borderWidth;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.fillColor = color.CGColor;
        [self.layer addSublayer:shapeLayer];
    }
    return  self;
}

@end
