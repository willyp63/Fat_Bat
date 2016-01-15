//
//  BatView.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "BatView.h"

@implementation BatView{
    CGFloat _borderWidth;
    BOOL _isDiving;
    CAShapeLayer *_wingLayer;
    CAShapeLayer *_pupilLayer;
    CAShapeLayer *_eyeLayer;
}

-(id)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth{
    self = [super initWithFrame:frame];
    if (self) {
        _borderWidth = borderWidth;
        _isDiving = NO;
        
        //create body layer and add to root layer
        CAShapeLayer *bodyLayer = [CAShapeLayer layer];
        bodyLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        bodyLayer.position = CGPointMake(0.0, 0.0);
        bodyLayer.lineWidth = _borderWidth;
        bodyLayer.strokeColor = [UIColor blackColor].CGColor;
        bodyLayer.fillColor = [UIColor colorWithRed:BODY_RED green:BODY_GREEN blue:BODY_BLUE alpha:1.0].CGColor;
        [self.layer addSublayer:bodyLayer];
        
        //ear path
        UIBezierPath* earPath = [UIBezierPath bezierPath];
        [earPath moveToPoint:CGPointMake(self.bounds.size.width*4.0/10.0, self.bounds.size.height/8.0)];
        [earPath addLineToPoint:CGPointMake(self.bounds.size.width*6.0/10.0, self.bounds.size.height/8.0)];
        [earPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, -self.bounds.size.height/6.0)];
        [earPath closePath];
        
        //create ear layer and add to root layer
        CAShapeLayer *earLayer = [CAShapeLayer layer];
        earLayer.path = earPath.CGPath;
        earLayer.position = CGPointMake(0.0, 0.0);
        earLayer.lineWidth = _borderWidth;
        earLayer.strokeColor = [UIColor blackColor].CGColor;
        earLayer.fillColor = [UIColor colorWithRed:EAR_WING_RED green:EAR_WING_GREEN blue:EAR_WING_BLUE alpha:1.0].CGColor;
        [self.layer addSublayer:earLayer];
        
        //create wing layer and add to root layer
        _wingLayer = [CAShapeLayer layer];
        [self setIsDiving:_isDiving];
        _wingLayer.position = CGPointMake(0.0, 0.0);
        _wingLayer.lineWidth = _borderWidth;
        _wingLayer.strokeColor = [UIColor blackColor].CGColor;
        _wingLayer.fillColor = [UIColor colorWithRed:EAR_WING_RED green:EAR_WING_GREEN blue:EAR_WING_BLUE alpha:1.0].CGColor;
        [self.layer addSublayer:_wingLayer];
        
        //create eye layer and add to root layer
        CGRect eyeRect = CGRectMake(self.bounds.size.width/2.0, 0.0, self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _eyeLayer = [CAShapeLayer layer];
        _eyeLayer.path = [UIBezierPath bezierPathWithOvalInRect:eyeRect].CGPath;
        _eyeLayer.position = CGPointMake(0.0, 0.0);
        _eyeLayer.lineWidth = _borderWidth;
        _eyeLayer.strokeColor = [UIColor blackColor].CGColor;
        _eyeLayer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_eyeLayer];
        
        //create pupil layer and add to root layer
        CGRect pupilRect = CGRectMake(eyeRect.origin.x + eyeRect.size.width*2.0/3.0, eyeRect.origin.y + eyeRect.size.height/3.0, eyeRect.size.width/3.0, eyeRect.size.height/3.0);
        _pupilLayer = [CAShapeLayer layer];
        _pupilLayer.path = [UIBezierPath bezierPathWithOvalInRect:pupilRect].CGPath;
        _pupilLayer.position = CGPointMake(0.0, 0.0);
        _pupilLayer.lineWidth = _borderWidth;
        _pupilLayer.strokeColor = [UIColor blackColor].CGColor;
        _pupilLayer.fillColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_pupilLayer];
        
        //create mouth layer and add to root layer
        CGRect mouthRect = CGRectMake(self.bounds.size.width*5.0/8.0, self.bounds.size.height*5.0/8.0, self.bounds.size.width/3.0, 0.0);
        CAShapeLayer *mouthLayer = [CAShapeLayer layer];
        mouthLayer.path = [UIBezierPath bezierPathWithRect:mouthRect].CGPath;
        mouthLayer.position = CGPointMake(0.0, 0.0);
        mouthLayer.lineWidth = _borderWidth;
        mouthLayer.strokeColor = [UIColor blackColor].CGColor;
        mouthLayer.fillColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:mouthLayer];
    }
    return  self;
}

-(void)setAngle:(CGFloat)angle{
    //transfroms all layers to angle
    for (CALayer *layer in self.layer.sublayers) {
        layer.transform = CATransform3DMakeTranslation(self.bounds.size.width/2.0, self.bounds.size.height/2.0, 0.0);
        layer.transform = CATransform3DRotate(layer.transform, angle, 0.0, 0.0, 1.0);
        layer.transform = CATransform3DTranslate(layer.transform, -self.bounds.size.width/2.0, -self.bounds.size.height/2.0, 0.0);
    }
    
    //get look angle based on diving state
    CGFloat lookAngle = LOOK_ANGLE;
    if (_isDiving) {
        lookAngle *= -1;
    }
    
    //rotate pupil to make bat look
    _pupilLayer.transform = CATransform3DTranslate(_pupilLayer.transform, self.bounds.size.width*3.0/4.0, self.bounds.size.height/4.0, 0.0);
    _pupilLayer.transform = CATransform3DRotate(_pupilLayer.transform, -(angle + lookAngle), 0.0, 0.0, 1.0);
    _pupilLayer.transform = CATransform3DTranslate(_pupilLayer.transform, -self.bounds.size.width*3.0/4.0, -self.bounds.size.height/4.0, 0.0);
    
    [self setNeedsDisplay];
}

-(void)setIsDiving:(BOOL)isDiving{
    _isDiving = isDiving;
    
    //redfine winglayer's path based on isDiving
    UIBezierPath* wingPath = [UIBezierPath bezierPath];
    
    
    if (isDiving) {
        [wingPath moveToPoint:CGPointMake(self.bounds.size.width*5.0/12.0, self.bounds.size.height/2.0)];
        [wingPath addLineToPoint:CGPointMake(-self.bounds.size.width/4.0, 0.0)];
        [wingPath addLineToPoint:CGPointMake(self.bounds.size.width/3.0, self.bounds.size.height/8.0)];
    }else{
        [wingPath moveToPoint:CGPointMake(self.bounds.size.width*5.0/12.0, self.bounds.size.height/2.0)];
        [wingPath addLineToPoint:CGPointMake(-self.bounds.size.width/3.0, self.bounds.size.height*2.0/3.0)];
        [wingPath addLineToPoint:CGPointMake(self.bounds.size.width/3.0, self.bounds.size.height*31.0/40.0)];
    }
    
    
    [wingPath closePath];
    
    _wingLayer.path = wingPath.CGPath;
    
    [self setNeedsDisplay];
}

-(BOOL)isDiving{
    return _isDiving;
}

@end
