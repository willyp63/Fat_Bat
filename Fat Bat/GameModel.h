//
//  GameModel.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDefinitions.h"
#import "GameObjectModel.h"


#define NUMBER_OF_CAVE_DIVISIONS 9

#define GRAVITY_FORCE 8.0
#define DIVE_FORCE 16.0

#define FLYING_VELOCITY 32.0
#define TERMINAL_Y_VELOCITY 96.0


typedef enum gameState{
    IN_PROGRESS, GAME_OVER, LEVEL_COMPLETE, PAUSED
}GameState;


@interface GameModel : NSObject


-(id)initWithCaveFrame:(CGRect)caveFrame filePath:(NSString *)filePath;

-(void)update;

-(void)addNewCharacters;
-(void)removeCharacters;


@property int time;
@property GameState state;
@property BOOL isDiving;

@property BOOL didBounce;
@property CGFloat timeToBounce;
@property CGFloat bounceFrameY;

@property GameObjectModel *bat;
@property NSMutableArray<GameObjectModel *> *stalagmite;

@property CGRect caveFrame;
@property CGFloat subDivisionSize;
@property CGFloat finishLine;

@property int nextStalagmiteIndex;
@property int numStalagmite;
@property CGPoint *stalagmiteLocations;

@property int finishTime;

@end
