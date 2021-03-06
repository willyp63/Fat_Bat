//
//  GameModel.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

-(id)initWithCaveFrame:(CGRect)caveFrame levelName:(NSString *)levelName{
    self = [super init];
    if (self) {
        _caveFrame = caveFrame;
        
        //get size of each cave subdivision
        _subDivisionSize = _caveFrame.size.height/NUMBER_OF_CAVE_DIVISIONS;
        
        //get forces and velocity based on ratio to iphone 6s
        CGFloat yRatio = _caveFrame.size.height / IPHONE_6S_CAVE_HEIGHT;
        _flyingVelocity = FLYING_VELOCITY * yRatio;
        _gravityForce = GRAVITY_FORCE * yRatio;
        _diveForce = DIVE_FORCE * yRatio;
        _terminalYVelocity = TERMINAL_Y_VELOCITY * yRatio;
        
        //bat view frame
        CGRect batFrame = CGRectMake(caveFrame.origin.x + _subDivisionSize, caveFrame.origin.y + _subDivisionSize, _subDivisionSize, _subDivisionSize);
        
        //init bat object
        _bat = [[GameObjectModel alloc] initWithFrame:batFrame];
        
        
        //init game state
        _state = IN_PROGRESS;
        _isDiving = NO;
        _time = 0.0;
        
        
        //init finishLine
        _finishLine = caveFrame.origin.x + caveFrame.size.width;
        
        
        //get xDiff based on difference to iphone 6s
        CGFloat iphone6sSubDivisionSize = IPHONE_6S_CAVE_HEIGHT/NUMBER_OF_CAVE_DIVISIONS;
        CGFloat xDiff = (IPHONE_6S_CAVE_WIDTH/iphone6sSubDivisionSize) - (_caveFrame.size.width/_subDivisionSize);
        
        //load file and spereate into lines
        NSString *levelFile = [LevelFileHandler levelWithName:levelName];
        NSArray *lines = [LevelFileHandler getLinesFromLevelFile:levelFile];
        
        //init stalagmite location array
        _numStalagmite = (int)lines.count - 3;
        _stalagmiteLocations = (CGPoint *)malloc(sizeof(CGPoint)*_numStalagmite);
        _nextStalagmiteIndex = 0;
        
        //init stalagmite object array
        _stalagmite = [[NSMutableArray alloc] initWithCapacity:_numStalagmite];
        
        //get finish time from first line
        _finishTime = [lines[0] intValue] + xDiff;
        
        //get color from line 2
        NSArray *rgbValues = [lines[1] componentsSeparatedByString:@" "];
        _colorRGBValues = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[rgbValues[0] floatValue]/255.0], [NSNumber numberWithFloat:[rgbValues[1] floatValue]/255.0], [NSNumber numberWithFloat:[rgbValues[2] floatValue]/255.0], nil];
        
        //get music num from line 3
        _songNum = [lines[2] intValue];
        
        //add a location for each remaining line
        for (int i = 3; i < lines.count; i++) {
            if ([lines[i] characterAtIndex:0] == '#'){continue;}
            
            //seperate line into words
            NSString *line = lines[i];
            NSArray *words = [line componentsSeparatedByString:@" "];
            
            //add location
            _stalagmiteLocations[_nextStalagmiteIndex].x = [words[0] intValue] + xDiff;
            _stalagmiteLocations[_nextStalagmiteIndex].y = [words[1] intValue];
            _nextStalagmiteIndex++;
        }
        
        _nextStalagmiteIndex = 0;
    }
    return self;
}


-(void)update{
    //increment time based on fly speed relative to the screen size
    _time += _flyingVelocity / _subDivisionSize;
    
    
    //get bat velocity and apply gravity force
    CGPoint batVelocity = [_bat velocity];
    batVelocity.y += _gravityForce;
    
    //if diving apply dive force
    if (_isDiving) {
        batVelocity.y += _diveForce;
    }
    
    //limit y velocity
    if (batVelocity.y > _terminalYVelocity) {
        batVelocity.y = _terminalYVelocity;
    }else if (batVelocity.y < -_terminalYVelocity) {
        batVelocity.y = -_terminalYVelocity;
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
        CGFloat velocityDiff = _gravityForce*timeDiff;
        if (velocityDiff < 0.0) velocityDiff = 0.0;
        positionDiff = timeDiff*(batVelocity.y - 2*_gravityForce*timeDiff);
        if(positionDiff < 0.0) positionDiff = 0.0;
        
        //set frame and velocity
        batFrame.origin.y = _caveFrame.origin.y + _caveFrame.size.height - batFrame.size.height - positionDiff;
        batVelocity.y -= velocityDiff;
        batVelocity.y *= -1; //invert y velocity
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
        CGFloat velocityDiff = _gravityForce*timeDiff;
        if (velocityDiff < 0.0) velocityDiff = 0.0;
        positionDiff = timeDiff*(batVelocity.y - 2*_gravityForce*timeDiff);
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
    
    //update stalagmite
    for (int i = 0; i < _stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _stalagmite[i];
        [stalagmiteObject update];
    }
    
    //check for stalagmite collisions
    for (int i = 0; i < _stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _stalagmite[i];
        if ([self batIntersects:stalagmiteObject]){
            _state = GAME_OVER;
            break;
        }
    }
    
    
    //update finishline
    if (_time > _finishTime) {
        _finishLine = _caveFrame.origin.x + _caveFrame.size.width - (_time + 0.25 - _finishTime)*_subDivisionSize;
    }
    
    //check if bat crossed finish
    if (_bat.frame.origin.x + _bat.frame.size.width > _finishLine) {
        _state = LEVEL_COMPLETE;
    }
}


-(BOOL)batIntersects:(GameObjectModel *)stalagmite{
    //if the bat's new frame (taken as a circle) intersects the stalagmite, return YES
    if ([self circle:_bat.frame intersectsRect:stalagmite.frame]) {
        return  YES;
    }
    
    
    //get bat's old frame
    CGRect oldBatFrame = CGRectMake(_bat.frame.origin.x - _bat.velocity.x - _flyingVelocity, _bat.frame.origin.y - _bat.velocity.y, _bat.frame.size.width, _bat.frame.size.height);
    
    //get center of old and new bat frame
    CGPoint p1 = CGPointMake(oldBatFrame.origin.x + oldBatFrame.size.width/2, oldBatFrame.origin.y + oldBatFrame.size.height/2);
    CGPoint p2 = CGPointMake(_bat.frame.origin.x + _bat.frame.size.width/2, _bat.frame.origin.y + _bat.frame.size.height/2);
    
    //calc dy, dx, slope, and arctan
    CGFloat dy = (p2.y - p1.y);
    CGFloat dx = (p2.x - p1.x);
    CGFloat m =  dy / dx;
    CGFloat theta = atan2f(dy, dx);
    
    //add or subtract pi/2 from theta based on type of stalagmite (one way gives top tangent line and the other gives bottom)
    if (stalagmite.frame.origin.y == _caveFrame.origin.y) {theta += 1.57/*(pi/2)*/;} else {theta -= 1.57/*(pi/2)*/;}
    
    //move p1 and p2 the the perimeter of the circle, in direction theta
    CGFloat xoffset = cosf(theta)*_bat.frame.size.width/2.0;
    CGFloat yoffset = sinf(theta)*_bat.frame.size.width/2.0;
    p1.x -= xoffset;
    p1.y -= yoffset;
    p2.x -= xoffset;
    p2.y -= yoffset;
    
    //check if stalagmite is dowward facing
    if (stalagmite.frame.origin.y == _caveFrame.origin.y) {
        //get corners of stalagmite to test for collision
        CGPoint bottomLeftPoint = CGPointMake(stalagmite.frame.origin.x, stalagmite.frame.origin.y + stalagmite.frame.size.height);
        CGPoint bottomRightPoint = CGPointMake(stalagmite.frame.origin.x + stalagmite.frame.size.width, stalagmite.frame.origin.y + stalagmite.frame.size.height);
        
        //if either corner's x value is between p1.x and p2.x, and the corner is below the line (p1, p2), then return YES
        if (bottomLeftPoint.x > p1.x && bottomLeftPoint.x < p2.x && bottomLeftPoint.y - p1.y >= m * (bottomLeftPoint.x - p1.x)) {
            return YES;
        }
        if (bottomRightPoint.x > p1.x && bottomRightPoint.x < p2.x && bottomRightPoint.y - p1.y >= m * (bottomRightPoint.x - p1.x)) {
            return YES;
        }
    }
    //stalagmite is upward facing
    else{
        //get corners of stalagmite to test for collision
        CGPoint topLeftPoint = CGPointMake(stalagmite.frame.origin.x, stalagmite.frame.origin.y);
        CGPoint topRightPoint = CGPointMake(stalagmite.frame.origin.x + stalagmite.frame.size.width, stalagmite.frame.origin.y);
        
        //if either corner's x value is between p1.x and p2.x, and the corner is above the line (p1, p2), then return YES
        if (topLeftPoint.x > p1.x && topLeftPoint.x < p2.x && topLeftPoint.y - p1.y <= m * (topLeftPoint.x - p1.x)) {
            return YES;
        }
        if (topRightPoint.x > p1.x && topRightPoint.x < p2.x && topRightPoint.y - p1.y <= m * (topRightPoint.x - p1.x)) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)circle:(CGRect)circle intersectsRect:(CGRect) rect{
    //get distance between centers
    CGFloat circleDistanceX = fabs(circle.origin.x + circle.size.width/2.0 - rect.origin.x - rect.size.width/2.0);
    CGFloat circleDistanceY = fabs(circle.origin.y + circle.size.height/2.0 - rect.origin.y - rect.size.height/2.0);
    
    //if the distance is far enough, return NO
    if (circleDistanceX > (rect.size.width/2.0 + circle.size.width/2.0)) { return NO; }
    if (circleDistanceY > (rect.size.height/2.0 + circle.size.height/2.0)) { return NO; }
    
    //if distance is close enough, return YES
    if (circleDistanceX <= (rect.size.width/2.0)) { return YES; }
    if (circleDistanceY <= (rect.size.height/2.0)) { return YES; }
    
    //else calc distance from circle center to near corner of rect
    CGFloat cornerDistanceSq = powf(circleDistanceX - rect.size.width/2.0, 2.0) +
    powf(circleDistanceY - rect.size.height/2.0, 2.0);
    
    //return (if the circle is close enough to the corner of the rect)
    return (cornerDistanceSq <= powf(circle.size.width, 2.0));
}


-(void)addNewStalagmite{
    //add new stalagmite while _time is equal to the x value of the next location
    while(_nextStalagmiteIndex < _numStalagmite && _time > _stalagmiteLocations[_nextStalagmiteIndex].x - (_flyingVelocity / _subDivisionSize)){
        //get y value
        int y = _stalagmiteLocations[_nextStalagmiteIndex].y;
        
        //calc x offset
        CGFloat xOffset = (_stalagmiteLocations[_nextStalagmiteIndex].x - _time)*_subDivisionSize;
        
        //get stalagmite frame based on type of stalagmite
        CGRect stalagmiteFrame;
        if (y > 0) {
            CGFloat stalagmiteY = _caveFrame.origin.y + _caveFrame.size.height - (y * _subDivisionSize);
            stalagmiteFrame = CGRectMake(_caveFrame.origin.x + _caveFrame.size.width + xOffset, stalagmiteY, _subDivisionSize/2.0, (y * _subDivisionSize));
        }else{
            stalagmiteFrame = CGRectMake(_caveFrame.origin.x + _caveFrame.size.width + xOffset, _caveFrame.origin.y, _subDivisionSize/2.0, (-y * _subDivisionSize));
        }
        
        //create object and init with -FLYING_VELOCITY
        GameObjectModel *stalagmiteObject = [[GameObjectModel alloc] initWithFrame:stalagmiteFrame];
        [stalagmiteObject setVelocity:CGPointMake(-_flyingVelocity, 0.0)];
        [_stalagmite addObject:stalagmiteObject];
        
        //move to next location
        _nextStalagmiteIndex++;
    }
}

-(void)removeStalagmite{
    //remove stalagmite off left side of screen
    for (int i = 0; i < _stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _stalagmite[i];
        
        if (stalagmiteObject.frame.origin.x + stalagmiteObject.frame.size.width < _caveFrame.origin.x) {
            [_stalagmite removeObjectAtIndex:i--];
        }
    }
}

@end
