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
            [path addArcWithCenter:CGPointMake(-radius, radius) radius:radius startAngle:M_PI*3.0/2.0 endAngle:M_PI*2.0 clockwise:YES];
            
            //[path moveToPoint:CGPointMake(0.0, radius)];
            [path addLineToPoint:CGPointMake(0.0, self.bounds.size.height - radius)];
            
            [path addArcWithCenter:CGPointMake(radius, self.bounds.size.height - radius) radius:radius startAngle:M_PI endAngle:M_PI*2.0 clockwise:NO];
            
            //[path moveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - radius)];
            [path addLineToPoint:CGPointMake(self.bounds.size.width, radius)];
            
            [path addArcWithCenter:CGPointMake(self.bounds.size.width + radius, radius) radius:radius startAngle:M_PI endAngle:M_PI*3.0/2.0 clockwise:YES];
        }else{
            [path addArcWithCenter:CGPointMake(-radius, self.bounds.size.height - radius) radius:radius startAngle:M_PI/2.0 endAngle:0.0 clockwise:NO];
            
            //[path moveToPoint:CGPointMake(0.0, radius)];
            [path addLineToPoint:CGPointMake(0.0, radius)];
            
            [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:0.0 clockwise:YES];
            
            //[path moveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - radius)];
            [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - radius)];
            
            [path addArcWithCenter:CGPointMake(self.bounds.size.width + radius, self.bounds.size.height - radius) radius:radius startAngle:M_PI endAngle:M_PI/2.0 clockwise:NO];
        }
    
        
        //create ear layer and add to root layer
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
