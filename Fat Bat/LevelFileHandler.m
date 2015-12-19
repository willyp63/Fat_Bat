//
//  LevelFileHandler.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/18/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelFileHandler.h"

@implementation LevelFileHandler

+(NSString *)levelWithName:(NSString *)levelName{
    //prefix folder name
    levelName = [LEVEL_FOLDER stringByAppendingString:levelName];
    
    //get file path
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:levelName ofType:@"txt"];
    
    //return contents of file
    return [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *)levelsFile{
    //get documents path
    NSString *docPath = [self documentsPath];
    
    //check if documents file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        //copy file from bundle to documents
        [self writeLevelsFileToPath:docPath];
    }
    
    //return contents of file
    return [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
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
            [string writeToFile:[self documentsPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
            break;
        }
    }
}

+(void)resetLevelsFile{
    //write levels file to documents
    [self writeLevelsFileToPath:[self documentsPath]];
}

+(NSString *)documentsPath{
    //return documents path
    NSString * component = [NSString stringWithFormat:@"Documents/%@.txt", LEVELS_FILE_NAME];
    return [NSHomeDirectory() stringByAppendingPathComponent:component];
}

+(void)writeLevelsFileToPath:(NSString *)path{
    //copy file from bundle to path
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[LEVEL_FOLDER stringByAppendingString:LEVELS_FILE_NAME] ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
    [string writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
