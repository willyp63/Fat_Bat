//
//  CheckMarkView.h
//  Fat Bat
//
//  Created by Wil Pirino on 1/4/16.
//  Copyright © 2016 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

//shapes
typedef enum shape{
    BLUE_SQUARE, GREEN_CIRCLE, BLACK_DIAMOND, DOUBLE_BLACK_DIAMOND, CHECK_MARK
}Shape;

@interface ShapeMarkerView : UIView

-(id)initWithFrame:(CGRect)frame shape:(Shape)shape borderWidth:(CGFloat)borderWidth;

@end
