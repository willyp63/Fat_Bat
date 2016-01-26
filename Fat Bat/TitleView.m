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
    
    BOOL _alternateColors;
    NSArray <UIColor *> *_colors;
}

-(id)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _text = text;
        _font = font;
        _color = color;
        _borderWidth = borderWidth;
        
        _alternateColors = NO;
    }
    return self;
}

-(void)alternateColors:(NSArray<UIColor *> *)colors{
    _alternateColors = YES;
    _colors = colors;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (!_alternateColors) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, _color, NSForegroundColorAttributeName, nil];
        CGSize textSize = [[[NSAttributedString alloc] initWithString:_text attributes:attributes] size];
    
        CGPoint drawPoint = CGPointMake((rect.size.width - textSize.width)/2.0, (rect.size.height - textSize.height)/2.0);
    
    
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        [_text drawAtPoint:drawPoint withAttributes:attributes];
    
    
        attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        CGContextSetTextDrawingMode(ctx, kCGTextStroke);
        CGContextSetLineWidth(ctx, _borderWidth);
        [_text drawAtPoint:drawPoint withAttributes:attributes];
    }else{
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, _color, NSForegroundColorAttributeName, nil];
        CGSize textSize = [[[NSAttributedString alloc] initWithString:_text attributes:attributes] size];
        CGFloat letterX = (rect.size.width - textSize.width)/2.0;
        
        for (int i = 0; i < _text.length; i++) {
            NSString *letter = [_text substringWithRange:NSMakeRange(i, 1)];
            
            CGPoint drawPoint = CGPointMake(letterX, (rect.size.height - textSize.height)/2.0);
            letterX += [[NSAttributedString alloc] initWithString:letter attributes:attributes].size.width;
            
            attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, _colors[i%_colors.count], NSForegroundColorAttributeName, nil];
            CGContextSetTextDrawingMode(ctx, kCGTextFill);
            [letter drawAtPoint:drawPoint withAttributes:attributes];
            
            attributes = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
            CGContextSetTextDrawingMode(ctx, kCGTextStroke);
            CGContextSetLineWidth(ctx, _borderWidth);
            [letter drawAtPoint:drawPoint withAttributes:attributes];
            
            
        }
    }
}

@end
