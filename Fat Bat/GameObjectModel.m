//
//  GameObjectModel.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameObjectModel.h"

@implementation GameObjectModel

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        _frame = frame;
        _velocity = CGPointMake(0.0, 0.0);
    }
    return self;
}

-(void)update{
    _frame.origin.x += _velocity.x;
    _frame.origin.y += _velocity.y;
}

@end
