//
//  GameModel.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LevelFileHandler.h"
#import "GameObjectModel.h"
#import "GameDefinitions.h"
#import "UIDefinitions.h"

//game states
typedef enum gameState{
    IN_PROGRESS, GAME_OVER, LEVEL_COMPLETE, PAUSED
}GameState;


@interface GameModel : NSObject

-(id)initWithCaveFrame:(CGRect)caveFrame levelName:(NSString *)levelName;

-(void)update;

-(void)addNewStalagmite;
-(void)removeStalagmite;


@property CGFloat time;
@property GameState state;
@property BOOL isDiving;

@property BOOL didBounce;
@property CGFloat timeToBounce;
@property CGFloat bounceFrameY;

@property CGFloat flyingVelocity;
@property CGFloat gravityForce;
@property CGFloat diveForce;
@property CGFloat terminalYVelocity;

@property GameObjectModel *bat;
@property NSMutableArray<GameObjectModel *> *stalagmite;

@property CGRect caveFrame;
@property CGFloat subDivisionSize;
@property CGFloat finishLine;

@property int nextStalagmiteIndex;
@property int numStalagmite;
@property CGPoint *stalagmiteLocations;

@property int finishTime;

@property NSArray <NSNumber *>*colorRGBValues;

@property int songNum;

@end
