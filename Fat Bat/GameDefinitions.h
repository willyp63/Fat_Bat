//
//  GameDefinitions.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/17/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#ifndef GameDefinitions_h
#define GameDefinitions_h


//folder holding level files
#define LEVEL_FOLDER @"levels/"

//file conatining names of all levels and completion status
#define LEVELS_FILE_NAME @"levels"

//file containing a template for creating new levels
#define NEW_LEVEL_FILE_NAME @"new_level"

//any line beginning with this prefix will be ignored in a level file
#define COMMENT_LINE_PREFIX @"//"


//time between game updates
#define UPDATE_TIME_INTERVAL 0.16


//number of rows in the cave
#define NUMBER_OF_CAVE_DIVISIONS 10


//forces
#define GRAVITY_FORCE 3.0
#define DIVE_FORCE 10.0


//scroll speed of game
#define FLYING_VELOCITY 30.0

//max veritical velocity
#define TERMINAL_Y_VELOCITY 100.0


#endif /* GameDefinitions_h */
