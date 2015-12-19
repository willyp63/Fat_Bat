//
//  FinishLineView.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/16/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "FinishLineView.h"

@implementation FinishLineView{
    int _numRows, _numColumns;
    CGFloat _cellSize;
}

-(id)initWithFrame:(CGRect)frame numberOfColumns:(int)numColumns{
    self = [super initWithFrame:frame];
    if (self) {
        _numColumns = numColumns;
        _cellSize = self.bounds.size.width / _numColumns;
        _numRows = self.bounds.size.height / _cellSize;
        _numRows++;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //draw checker board
    for (int x = 0; x < _numColumns; x++) {
        for (int y = 0; y < _numRows; y++) {
            
            CGFloat ix = x * _cellSize;
            CGFloat iy = y * _cellSize;
            
            UIBezierPath *cellPath = [UIBezierPath bezierPathWithRect:CGRectMake(ix, iy, _cellSize, _cellSize)];
            
            if(x % 2 == y % 2){
                [[UIColor blackColor] setFill];
            }else{
                [[UIColor whiteColor] setFill];
            }
            
            [cellPath fill];
        }
    }
    
    
}

@end
