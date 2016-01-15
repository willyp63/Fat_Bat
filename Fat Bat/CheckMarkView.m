//
//  CheckMarkView.m
//  Fat Bat
//
//  Created by Wil Pirino on 1/4/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import "CheckMarkView.h"

@implementation CheckMarkView{
    CGFloat _borderWidth;
}

-(id)initWithFrame:(CGRect)frame borderWidth:(CGFloat)borderWidth{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _borderWidth = borderWidth;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, (self.bounds.size.width/3.0) - _borderWidth/sqrt(2.0), (self.bounds.size.height*3.0/5.0) - _borderWidth/sqrt(2.0));
    CGContextAddLineToPoint(ctx, self.bounds.size.width/2.0, self.bounds.size.height*3.0/4.0);
    CGContextAddLineToPoint(ctx, (self.bounds.size.width*4.0/5.0) + _borderWidth/sqrt(5.0), (self.bounds.size.height/4.0) - _borderWidth*2.0/sqrt(5.0));
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, self.bounds.size.width/8.0);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, self.bounds.size.width/3.0, self.bounds.size.height*3.0/5.0);
    CGContextAddLineToPoint(ctx, self.bounds.size.width/2.0, self.bounds.size.height*3.0/4.0);
    CGContextAddLineToPoint(ctx, self.bounds.size.width*4.0/5.0, self.bounds.size.height/4.0);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ctx, (self.bounds.size.width/8.0) - _borderWidth*2.0);
    CGContextStrokePath(ctx);
}

@end
