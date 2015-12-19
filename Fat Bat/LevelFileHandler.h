//
//  LevelFileHandler.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/18/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDefinitions.h"

#define LEVEL_FOLDER @"levels/"

@interface LevelFileHandler : NSObject

+(NSString *)levelWithName:(NSString *)levelName;
+(void)setLevelComplete:(NSString *)levelName;
+(NSString *)levelsFile;
+(void)resetLevelsFile;

@end
