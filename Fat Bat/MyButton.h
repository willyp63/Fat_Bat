//
//  MyButton.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/18/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyButtonResponder;


@interface MyButton : UIView

-(id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth color:(UIColor *)color text:(NSString *)text font:(UIFont *)font responder:(id <MyButtonResponder>)responder;

-(void)setToggle:(BOOL)toggle;

@property id <MyButtonResponder> responder;

@property CGFloat cornerRadius;
@property CGFloat borderWidth;
@property UIColor *color;
@property NSString *text;
@property UIFont *font;

@property BOOL isToggleButton;
@property BOOL toggleState;

@end


//responder protocol
@protocol MyButtonResponder

-(void)buttonPressed:(MyButton *)button;

@end