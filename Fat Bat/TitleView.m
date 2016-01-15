//
//  TitleView.m
//  Fat Bat
//
//  Created by Wil Pirino on 1/4/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView{
    NSString *_text;
    UIFont *_font;
    UIColor *_color;
    CGFloat _borderWidth;
}

-(id)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _text = text;
        _font = font;
        _color = color;
        _borderWidth = borderWidth;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, _color, NSForegroundColorAttributeName, nil];
    CGSize textSize = [[[NSAttributedString alloc] initWithString:_text attributes:attributes] size];
    
    CGPoint drawPoint = CGPointMake((rect.size.width - textSize.width)/2.0, (rect.size.height - textSize.height)/2.0);
    
    
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    [_text drawAtPoint:drawPoint withAttributes:attributes];
    
    
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    CGContextSetTextDrawingMode(ctx, kCGTextStroke);
    CGContextSetLineWidth(ctx, _borderWidth);
    [_text drawAtPoint:drawPoint withAttributes:attributes];
}

@end