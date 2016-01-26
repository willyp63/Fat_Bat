//
//  TitleView.h
//  Fat Bat
//
//  Created by Wil Pirino on 1/4/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView

-(id)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color borderWidth:(CGFloat)borderWidth;

-(void)alternateColors:(NSArray<UIColor *> *)colors;

@end
