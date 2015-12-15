//
//  BatView.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "BatView.h"

@implementation BatView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //create body layer and add to root layer
        CAShapeLayer *bodyLayer = [CAShapeLayer layer];
        bodyLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        bodyLayer.position = CGPointMake(0.0, 0.0);
        bodyLayer.lineWidth = 2.0;
        bodyLayer.strokeColor = [UIColor blackColor].CGColor;
        bodyLayer.fillColor = [UIColor colorWithRed:125.0/255.0 green:0.0 blue:250.0/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:bodyLayer];
        
        //ear path
        UIBezierPath* earPath = [UIBezierPath bezierPath];
        [earPath moveToPoint:CGPointMake(self.bounds.size.width*3.0/8.0, self.bounds.size.height/8.0)];
        [earPath addLineToPoint:CGPointMake(self.bounds.size.width*5.0/8.0, self.bounds.size.height/8.0)];
        [earPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, -self.bounds.size.height/4.0)];
        [earPath closePath];
        
        //create ear layer and add to root layer
        CAShapeLayer *earLayer = [CAShapeLayer layer];
        earLayer.path = earPath.CGPath;
        earLayer.position = CGPointMake(0.0, 0.0);
        earLayer.lineWidth = 2.0;
        earLayer.strokeColor = [UIColor blackColor].CGColor;
        earLayer.fillColor = [UIColor colorWithRed:1.0 green:102.0/255.0 blue:1.0 alpha:1.0].CGColor;
        [self.layer addSublayer:earLayer];
        
        //create wing layer and add to root layer
        _wingLayer = [CAShapeLayer layer];
        [self setIsDiving:NO];
        _wingLayer.position = CGPointMake(0.0, 0.0);
        _wingLayer.lineWidth = 2.0;
        _wingLayer.strokeColor = [UIColor blackColor].CGColor;
        _wingLayer.fillColor = [UIColor colorWithRed:1.0 green:102.0/255.0 blue:1.0 alpha:1.0].CGColor;
        [self.layer addSublayer:_wingLayer];
        
        //create eye layer and add to root layer
        CGRect eyeRect = CGRectMake(self.bounds.size.width/2.0, 0.0, self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        CAShapeLayer *eyeLayer = [CAShapeLayer layer];
        eyeLayer.path = [UIBezierPath bezierPathWithOvalInRect:eyeRect].CGPath;
        eyeLayer.position = CGPointMake(0.0, 0.0);
        eyeLayer.lineWidth = 2.0;
        eyeLayer.strokeColor = [UIColor blackColor].CGColor;
        eyeLayer.fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
        [self.layer addSublayer:eyeLayer];
        
        //create pupil layer and add to root layer
        CGRect pupilRect = CGRectMake(eyeRect.origin.x + eyeRect.size.width*2.0/3.0, eyeRect.origin.y + eyeRect.size.height/3.0, eyeRect.size.width/3.0, eyeRect.size.height/3.0);
        CAShapeLayer *pupilLayer = [CAShapeLayer layer];
        pupilLayer.path = [UIBezierPath bezierPathWithOvalInRect:pupilRect].CGPath;
        pupilLayer.position = CGPointMake(0.0, 0.0);
        pupilLayer.lineWidth = 2.0;
        pupilLayer.strokeColor = [UIColor blackColor].CGColor;
        pupilLayer.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
        [self.layer addSublayer:pupilLayer];
        
        //create mouth layer and add to root layer
        CGRect mouthRect = CGRectMake(self.bounds.size.width*5.0/8.0, self.bounds.size.height*5.0/8.0, self.bounds.size.width/3.0, 0.0);
        CAShapeLayer *mouthLayer = [CAShapeLayer layer];
        mouthLayer.path = [UIBezierPath bezierPathWithRect:mouthRect].CGPath;
        mouthLayer.position = CGPointMake(0.0, 0.0);
        mouthLayer.lineWidth = 2.0;
        mouthLayer.strokeColor = [UIColor blackColor].CGColor;
        mouthLayer.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
        [self.layer addSublayer:mouthLayer];
    }
    return  self;
}

-(void)setAngle:(CGFloat)angle{
    //transfroms all layers to angle
    for (CALayer *layer in self.layer.sublayers) {
        layer.transform = CATransform3DMakeTranslation(self.bounds.size.width/2.0, self.bounds.size.width/2.0, 0.0);
        layer.transform = CATransform3DRotate(layer.transform, angle, 0.0, 0.0, 1.0);
        layer.transform = CATransform3DTranslate(layer.transform, -self.bounds.size.width/2.0, -self.bounds.size.width/2.0, 0.0);
    }
    [self setNeedsDisplay];
}

-(void)setIsDiving:(BOOL)isDiving{
    //redfine winglayer's path based on isDiving
    UIBezierPath* wingPath = [UIBezierPath bezierPath];
    [wingPath moveToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
    
    if (isDiving) {
        [wingPath addLineToPoint:CGPointMake(-self.bounds.size.width/2.0, 0.0)];
        [wingPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/8.0)];
    }else{
        [wingPath addLineToPoint:CGPointMake(-self.bounds.size.width/2.0, self.bounds.size.height*5.0/6.0)];
        [wingPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height*5.0/6.0)];
    }
    
    
    [wingPath closePath];
    
    _wingLayer.path = wingPath.CGPath;
    
    [self setNeedsDisplay];
}

@end
