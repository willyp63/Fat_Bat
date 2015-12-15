//
//  GameModel.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/13/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameObjectModel.h"

#define FLYING_VELOCITY 32.0

#define GRAVITY_FORCE 8.0
#define DIVE_FORCE 16.0

#define TERMINAL_Y_VELOCITY 96.0

typedef enum gameState{
    IN_PROGRESS, GAME_OVER, LEVEL_COMPLETE
}GameState;

@interface GameModel : NSObject


-(id)initWithBatFrame:(CGRect)batFrame caveFrame:(CGRect)caveFrame filePath:(NSString *)filePath;

-(void)update;

-(void)addNewCharacters;
-(void)removeCharacters;


@property GameState state;

@property int time;

@property BOOL didBounce;
@property CGFloat timeToBounce;
@property CGFloat bounceFrameY;

@property BOOL isDiving;

@property GameObjectModel *bat;
@property NSMutableArray<GameObjectModel *> *stalagmite;

@property CGRect caveFrame;

@property CGFloat finishLine;

@property int nextStalagmiteIndex;
@property int numStalagmite;
@property CGPoint *stalagmiteLocations;


@property int finishTime;

@end
