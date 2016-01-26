//
//  CheckMarkView.m
//  Fat Bat
//
//  Created by Wil Pirino on 1/4/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import "ShapeMarkerView.h"

@implementation ShapeMarkerView{
    CGFloat _borderWidth;
    Shape _shape;
}

-(id)initWithFrame:(CGRect)frame shape:(Shape)shape borderWidth:(CGFloat)borderWidth{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _shape = shape;
        _borderWidth = borderWidth;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    switch (_shape) {
        case GREEN_CIRCLE:{
            CGContextMoveToPoint(ctx, _borderWidth/2.0, _borderWidth/2.0);
            CGContextAddLineToPoint(ctx, self.bounds.size.width - _borderWidth/2.0, _borderWidth/2.0);
            CGContextAddLineToPoint(ctx, self.bounds.size.width - _borderWidth/2.0, self.bounds.size.height - _borderWidth/2.0);
            CGContextAddLineToPoint(ctx, _borderWidth/2.0, self.bounds.size.height - _borderWidth/2.0);
            CGContextClosePath(ctx);
            
            CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
            CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
            CGContextSetLineWidth(ctx, _borderWidth);
            CGContextDrawPath(ctx, kCGPathFillStroke);
        }break;
            
        case BLUE_SQUARE:
            
            break;
            
        case BLACK_DIAMOND:
            
            break;
            
        case DOUBLE_BLACK_DIAMOND:
            
            break;
            
        case CHECK_MARK:{
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
        }break;
            
        default:
            break;
    }
}

@end
