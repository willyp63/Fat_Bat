//
//  LevelFileHandler.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/18/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelFileHandler.h"

@implementation LevelFileHandler

+(NSString *)levelsFile{
    //get documents path
    NSString *docPath = [self documentsPathForFileName:LEVELS_FILE_NAME];
    
    //check if documents file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        //copy files from bundle to documents
        [self writeLevelsToDocuments];
    }
    
    //return contents of file
    return [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *)levelWithName:(NSString *)levelName{
    //return contents of file
    return [NSString stringWithContentsOfFile:[self documentsPathForFileName:levelName] encoding:NSUTF8StringEncoding error:nil];
}


+(NSArray *)getLinesFromLevelFile:(NSString *)string{
    //get all lines from level file
    NSArray *allLines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //init c array
    NSString *lines[allLines.count];
    int numLines = 0;
    
    //fill c array with all lines not beginning with comment prefix
    for (int i = 0; i < allLines.count; i++) {
        if (![allLines[i] hasPrefix:COMMENT_LINE_PREFIX]) {
            lines[numLines] = allLines[i];
            numLines++;
        }
    }
    
    //return nsarray of relavent lines
    return [NSArray arrayWithObjects:lines count:numLines];
}


+(void)writeLevelsToDocuments{
    //copy levels file
    NSString *string = [NSString stringWithContentsOfFile:[self bundlePathForFileName:LEVELS_FILE_NAME] encoding:NSUTF8StringEncoding error:nil];
    [string writeToFile:[self documentsPathForFileName:LEVELS_FILE_NAME] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    //get lines
    NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (int i = 0; i < lines.count; i++) {
        NSArray *words = [lines[i] componentsSeparatedByString:@" "];
        NSString *levelName = words[0];
        
        //copy level file
        NSString *levelString = [NSString stringWithContentsOfFile:[self bundlePathForFileName:levelName] encoding:NSUTF8StringEncoding error:nil];
        [levelString writeToFile:[self documentsPathForFileName:levelName] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
}

+(void)writeLevelFile:(NSString *)string withName:(NSString *)levelName{
    //write level file to documents
    [string writeToFile:[self documentsPathForFileName:levelName] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    //get levels file and seperate into lines
    NSString *levelsString = [NSString stringWithContentsOfFile:[self documentsPathForFileName:LEVELS_FILE_NAME] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [levelsString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //search for a line with the same name
    for (int i = 0; i < lines.count; i++) {
        NSArray *words = [lines[i] componentsSeparatedByString:@" "];
        NSString *lineName = words[0];
        
        //if the names match return
        if ([lineName isEqualToString:levelName]) {
            return;
        }
    }
    
    //append new level
    levelsString = [levelsString stringByAppendingString:@"\r"];
    levelsString = [levelsString stringByAppendingString:levelName];
    levelsString = [levelsString stringByAppendingString:@" NO"];
    
    //write levels file
    [levelsString writeToFile:[self documentsPathForFileName:LEVELS_FILE_NAME] atomically:NO encoding:NSUTF8StringEncoding error:nil];
}


+(NSString *)isValidLevelFile:(NSString *)string{
    NSArray *lines = [self getLinesFromLevelFile:string];
    
    //check that there are at least two lines
    if (lines.count < 2) {
        return @"too few lines";
    }
    
    for (int i = 0; i < lines.count; i++) {
        NSArray *words = [lines[i] componentsSeparatedByString:@" "];
        
        //first line
        if (i == 0) {
            //check num args
            if (words.count != 1) {
                return @"wrong number of arguements on line 1";
            }else{
                float arg1 = [words[0] floatValue];
                
                //check arg1
                if(arg1 < 0.0){
                    return @"invalid arguement on line 1";
                }
            }
        }
        //second line
        else if(i == 1){
            //check num args
            if (words.count != 3) {
                return @"wrong number of arguements on line 2";
            }else{
                float arg1 = [words[0] floatValue];
                float arg2 = [words[1] floatValue];
                float arg3 = [words[2] floatValue];
                
                //check arg1
                if(arg1 < 0.0 || arg1 > 255.0 || arg2 < 0.0 || arg2 > 255.0 || arg3 < 0.0 || arg3 > 255.0){
                    return @"invalid arguement on line 2";
                }
            }
        }
        //remaining lines
        else{
            //check num args
            if (words.count != 2) {
                return [NSString stringWithFormat:@"wrong number of arguements on line %d", i];
            }else{
                float arg1 = [words[0] floatValue];
                float arg2 = [words[1] floatValue];
                
                //check arg1
                if(arg1 < 0.0 || arg2 < 2 - NUMBER_OF_CAVE_DIVISIONS || arg2 > NUMBER_OF_CAVE_DIVISIONS - 2){
                    return [NSString stringWithFormat:@"invalid arguement on line %d", i];
                }
            }
        }
    }
    
    return @"";
}


+(void)setLevelComplete:(NSString *)levelName{
    //load file and spereate into lines
    NSString *string = [self levelsFile];
    NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //this levels string in file
    NSString *levelString = [levelName stringByAppendingString:@" NO"];
    
    //search for level string
    for (int i = 0; i < lines.count; i++) {
        NSString *line = lines[i];
        
        //is level string
        if ([line isEqualToString:levelString]) {
            
            //build new string to write to file
            string = @"";
            for (int j = 0; j < lines.count; j++) {
                //if its this levels line, write new line
                if (i == j) {
                    string = [string stringByAppendingString:[levelName stringByAppendingString:@" YES"]];
                }
                //else copy old line
                else{
                    string = [string stringByAppendingString:lines[j]];
                }
                
                //return if not the last line
                if (j < lines.count - 1) {string = [string stringByAppendingString:@"\r"];}
            }
            
            //write to file
            [string writeToFile:[self documentsPathForFileName:LEVELS_FILE_NAME] atomically:NO encoding:NSUTF8StringEncoding error:nil];
            break;
        }
    }
}


+(NSString *)bundlePathForFileName:(NSString *)fileName{
    //return bundle path
    return [[NSBundle mainBundle] pathForResource:[LEVEL_FOLDER stringByAppendingString:fileName] ofType:@"txt"];

}

+(NSString *)documentsPathForFileName:(NSString *)fileName{
    //return documents path
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.txt", fileName]];
}

@end
