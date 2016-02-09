//
//  LevelFileHandler.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/18/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDefinitions.h"


@interface LevelFileHandler : NSObject


+(NSString *)levelsFile;
+(void)writeLevelsFile:(NSString *)string;
+(NSString *)levelWithName:(NSString *)levelName;

+(NSArray *)getLinesFromLevelFile:(NSString *)string;

+(void)writeLevelsToDocuments;
+(void)writeLevelFile:(NSString *)string withName:(NSString *)levelName;

+(NSString *)isValidLevelFile:(NSString *)string;

+(void)setLevelComplete:(NSString *)levelName;


@end
