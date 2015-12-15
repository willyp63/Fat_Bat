//
//  GameModel.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel{
    CGFloat _subDivisionSize;
}


-(id)initWithBatFrame:(CGRect)batFrame caveFrame:(CGRect)caveFrame filePath:(NSString *)filePath{
    self = [super init];
    if (self) {
        _state = IN_PROGRESS;
        _time = 0;
        
        _bat = [[GameObjectModel alloc] initWithFrame:batFrame];
        _subDivisionSize = batFrame.size.width;
        _caveFrame = caveFrame;
        
        _isDiving = NO;
        
        _finishLine = caveFrame.origin.x + caveFrame.size.width;
        
        //spereate file into lines
        NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        //init stalagmite location array
        _numStalagmite = (int)lines.count - 1;
        _stalagmiteLocations = (CGPoint *)malloc(sizeof(CGPoint)*_numStalagmite);
        _nextStalagmiteIndex = 0;
        
        _stalagmite = [[NSMutableArray alloc] initWithCapacity:_numStalagmite];
        
        //get finish time from first line
        _finishTime = [lines[0] intValue];
        
        //add a character for each remaining line
        for (int i = 1; i < lines.count; i++) {
            //seperate line into words
            NSString *line = lines[i];
            NSArray *words = [line componentsSeparatedByString:@" "];
            
            _stalagmiteLocations[i - 1].x = [words[0] intValue];
            _stalagmiteLocations[i - 1].y = [words[1] intValue];
        }
    }
    return self;
}

-(void)update{
    //increment time
    _time++;
    
    
    //get bat velocity and apply gravity force
    CGPoint batVelocity = [_bat velocity];
    batVelocity.y += GRAVITY_FORCE;
    
    //if diving apply dive force
    if (_isDiving) {
        batVelocity.y += DIVE_FORCE;
    }
    
    //limit y velocity
    if (batVelocity.y > TERMINAL_Y_VELOCITY) {
        batVelocity.y = TERMINAL_Y_VELOCITY;
    }else if (batVelocity.y < -TERMINAL_Y_VELOCITY) {
        batVelocity.y = -TERMINAL_Y_VELOCITY;
    }
    
    //set velocity and update
    [_bat setVelocity:batVelocity];
    [_bat update];
    
    //get bat frame
    CGRect batFrame = [_bat frame];
    
    //check for bounce off floor
    if (batFrame.origin.y + batFrame.size.height > _caveFrame.origin.y + _caveFrame.size.height) {
        //calc position and time diff from minimum frame to current frame
        CGFloat positionDiff = batFrame.origin.y + batFrame.size.height - _caveFrame.origin.y - _caveFrame.size.height;
        CGFloat timeDiff = positionDiff / batVelocity.y;
        
        //calc velocity and position diff to correct for bounce
        CGFloat velocityDiff = GRAVITY_FORCE*timeDiff;
        if (velocityDiff < 0.0) velocityDiff = 0.0;
        positionDiff = timeDiff*(batVelocity.y - 2*GRAVITY_FORCE*timeDiff);
        if(positionDiff < 0.0) positionDiff = 0.0;
        
        //set frame and velocity
        batFrame.origin.y = _caveFrame.origin.y + _caveFrame.size.height - batFrame.size.height - positionDiff;
        batVelocity.y -= velocityDiff;
        batVelocity.y *= -1;
        [_bat setFrame:batFrame];
        [_bat setVelocity:batVelocity];
        
        //set bounce update properties
        _didBounce = YES;
        _bounceFrameY = _caveFrame.origin.y + _caveFrame.size.height - batFrame.size.height;
        _timeToBounce = 1.0 - timeDiff;
    }
    //check for bounce off ceiling
    else if (batFrame.origin.y < _caveFrame.origin.y) {
        //invert y velocity
        batVelocity.y *= -1;
        
        //calc position and time diff from maximum frame to current frame
        CGFloat positionDiff = _caveFrame.origin.y - batFrame.origin.y;
        CGFloat timeDiff = positionDiff / batVelocity.y;
        
        //calc velocity and position diff to correct for bounce
        CGFloat velocityDiff = GRAVITY_FORCE*timeDiff;
        if (velocityDiff < 0.0) velocityDiff = 0.0;
        positionDiff = timeDiff*(batVelocity.y - 2*GRAVITY_FORCE*timeDiff);
        if(positionDiff < 0.0) positionDiff = 0.0;
        
        //set frame and velocity
        batFrame.origin.y = _caveFrame.origin.y + positionDiff;
        batVelocity.y -= velocityDiff;
        [_bat setFrame:batFrame];
        [_bat setVelocity:batVelocity];
        
        //set bounce update properties
        _didBounce = YES;
        _bounceFrameY = _caveFrame.origin.y;
        _timeToBounce = 1.0 - timeDiff;
    }
    //did not bounce
    else{
        _didBounce = NO;
    }
    
    //check for stalagmite collisions and update stalagmite
    for (int i = 0; i < _stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _stalagmite[i];
        [stalagmiteObject update];
        
        if ([self batIntersects:stalagmiteObject]){
            _state = GAME_OVER;
        }
    }
    
    //update finish line
    if (_time >= _finishTime) {
        _finishLine -= FLYING_VELOCITY;
        
        if (_bat.frame.origin.x + _bat.frame.size.width > _finishLine) {
            _state = LEVEL_COMPLETE;
        }
    }
}


-(BOOL)batIntersects:(GameObjectModel *)stalagmite{
    if ([self circle:_bat.frame intersectsRect:stalagmite.frame]) {
        return  YES;
    }
    
    CGRect oldBatFrame = CGRectMake(_bat.frame.origin.x - _bat.velocity.x - FLYING_VELOCITY, _bat.frame.origin.y - _bat.velocity.y, _bat.frame.size.width, _bat.frame.size.height);
    
    CGPoint p1 = CGPointMake(oldBatFrame.origin.x + oldBatFrame.size.width/2, oldBatFrame.origin.y + oldBatFrame.size.height/2);
    CGPoint p2 = CGPointMake(_bat.frame.origin.x + _bat.frame.size.width/2, _bat.frame.origin.y + _bat.frame.size.height/2);
    
    CGFloat dy = (p2.y - p1.y);
    CGFloat dx = (p2.x - p1.x);
    CGFloat m =  dy / dx;
    CGFloat theta = atan2f(dy, dx);
    
    if (stalagmite.frame.origin.y == _caveFrame.origin.y) {
        theta += 3.14/2.0;
    }else{
        theta -= 3.14/2.0;
    }
    
    CGFloat xoffset = cosf(theta)*_bat.frame.size.width/2.0;
    CGFloat yoffset = sinf(theta)*_bat.frame.size.width/2.0;
    p1.x -= xoffset;
    p1.y -= yoffset;
    p2.x -= xoffset;
    p2.y -= yoffset;
    
    if (stalagmite.frame.origin.y == _caveFrame.origin.y) {
        CGPoint bottomLeftPoint = CGPointMake(stalagmite.frame.origin.x, stalagmite.frame.origin.y + stalagmite.frame.size.height);
        CGPoint bottomRightPoint = CGPointMake(stalagmite.frame.origin.x + stalagmite.frame.size.width, stalagmite.frame.origin.y + stalagmite.frame.size.height);
        
        if (bottomLeftPoint.x > p1.x && bottomLeftPoint.x < p2.x && bottomLeftPoint.y - p1.y >= m * (bottomLeftPoint.x - p1.x)) {return YES;}
        if (bottomRightPoint.x > p1.x && bottomRightPoint.x < p2.x && bottomRightPoint.y - p1.y >= m * (bottomRightPoint.x - p1.x)) {return YES;}
    }else{
        CGPoint topLeftPoint = CGPointMake(stalagmite.frame.origin.x, stalagmite.frame.origin.y);
        CGPoint topRightPoint = CGPointMake(stalagmite.frame.origin.x + stalagmite.frame.size.width, stalagmite.frame.origin.y);
        
        if (topLeftPoint.x > p1.x && topLeftPoint.x < p2.x && topLeftPoint.y - p1.y <= m * (topLeftPoint.x - p1.x)) {return YES;}
        if (topRightPoint.x > p1.x && topRightPoint.x < p2.x && topRightPoint.y - p1.y <= m * (topRightPoint.x - p1.x)) {return YES;}
    }
    
    return NO;
}

-(BOOL)circle:(CGRect)circle intersectsRect:(CGRect) rect{
    CGFloat circleDistanceX = fabs(circle.origin.x + circle.size.width/2.0 - rect.origin.x - rect.size.width/2.0);
    CGFloat circleDistanceY = fabs(circle.origin.y + circle.size.height/2.0 - rect.origin.y - rect.size.height/2.0);
    
    if (circleDistanceX > (rect.size.width/2.0 + circle.size.width/2.0)) { return NO; }
    if (circleDistanceY > (rect.size.height/2.0 + circle.size.height/2.0)) { return NO; }
    
    if (circleDistanceX <= (rect.size.width/2.0)) { return YES; }
    if (circleDistanceY <= (rect.size.height/2.0)) { return YES; }
    
    CGFloat cornerDistanceSq = powf(circleDistanceX - rect.size.width/2.0, 2.0) +
    powf(circleDistanceY - rect.size.height/2.0, 2.0);
    
    return (cornerDistanceSq <= powf(circle.size.width, 2.0));
}

-(void)addNewCharacters{
    //return if there are no more stalagmite
    if (_nextStalagmiteIndex >= _numStalagmite) {
        return;
    }
    
    //add new stalagmite
    while(_time == _stalagmiteLocations[_nextStalagmiteIndex].x){
        
        int y = _stalagmiteLocations[_nextStalagmiteIndex].y;
        
        CGRect stalagmiteFrame;
        if (y > 0) {
            CGFloat stalagmiteY = _caveFrame.origin.y + _caveFrame.size.height - (y * _subDivisionSize);
            stalagmiteFrame = CGRectMake(_caveFrame.origin.x + _caveFrame.size.width, stalagmiteY, _subDivisionSize/2.0, (y * _subDivisionSize));
        }else{
            stalagmiteFrame = CGRectMake(_caveFrame.origin.x + _caveFrame.size.width, _caveFrame.origin.y, _subDivisionSize/2.0, (-y * _subDivisionSize));
        }
        
        GameObjectModel *stalagmiteObject = [[GameObjectModel alloc] initWithFrame:stalagmiteFrame];
        [stalagmiteObject setVelocity:CGPointMake(-FLYING_VELOCITY, 0.0)];
        [_stalagmite addObject:stalagmiteObject];
        
        _nextStalagmiteIndex++;
    }
}

-(void)removeCharacters{
    //remove stalagmite off left side of screen
    for (int i = 0; i < _stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _stalagmite[i];
        
        if (stalagmiteObject.frame.origin.x + stalagmiteObject.frame.size.width < _caveFrame.origin.x) {
            [_stalagmite removeObjectAtIndex:i--];
        }
    }
}

@end
