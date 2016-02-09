//
//  MyButton.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/18/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

-(id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth color:(UIColor *)color text:(NSString *)text font:(UIFont *)font responder:(id <MyButtonResponder>)responder{
    self = [super initWithFrame:frame];
    if (self) {
        _cornerRadius = cornerRadius;
        _borderWidth = borderWidth;
        _color = color;
        _font = font;
        _responder = responder;
        
        _toggleState = NO;
        _isToggleButton = NO;
        
        //set layer
        self.layer.borderWidth = _borderWidth;
        self.layer.cornerRadius = _cornerRadius;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = _color.CGColor;
        
        //add text label
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, _font.descender/3.0, self.bounds.size.width, self.bounds.size.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = text;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = _font;
        [self addSubview:_textLabel];
    }
    return self;
}

-(void)setToggle:(BOOL)toggle{
    _toggleState = toggle;
    if (_toggleState) {
        self.layer.backgroundColor = [UIColor grayColor].CGColor;
    }else{
        [self unhighlight];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isToggleButton) {
        if (_toggleState) {
            [self unhighlight];
        }else{
            //highlight button
            self.layer.backgroundColor = [UIColor grayColor].CGColor;
        }
        _toggleState = !_toggleState;
    }else{
        //highlight button
        self.layer.backgroundColor = [UIColor grayColor].CGColor;
        
        //unhighlight after delay
        [self performSelector:@selector(unhighlight) withObject:Nil afterDelay:0.18];
    }
    
    //call responder method
    [_responder buttonPressed:self];
}

-(void)unhighlight{
    self.layer.backgroundColor = _color.CGColor;
}

@end
