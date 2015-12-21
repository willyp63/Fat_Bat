//
//  UIDefinitions.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/16/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#ifndef UIDefinitions_h
#define UIDefinitions_h


//border with of most paths being drawn
#define BORDER_WIDTH 2.0


//buttons
#define BUTTON_CORNER_RADIUS 8.0

#define GAME_BUTTON_OFFSET 5.0
#define GAME_BUTTON_WIDTH 80.0
#define GAME_BUTTON_HEIGHT 40.0

#define PLAY_BUTTON_WIDTH 160.0
#define PLAY_BUTTON_HEIGHT 80.0


//Fat Bat label
#define TITLE_LABEL_WIDTH 360.0
#define TITLE_LABEL_HEIGHT 240.0


//font
#define FONT_NAME @"HelveticaNeue-Bold"
#define FONT_SIZE 25.0
#define TITLE_FONT_SIZE 96.0
#define DETAIL_FONT_SIZE 12.0


//ui colors
#define UI_1_RED 125.0/255.0
#define UI_1_GREEN 102.0/255.0
#define UI_1_BLUE 255.0/255.0

#define UI_2_RED 255.0/255.0
#define UI_2_GREEN 176.0/255.0
#define UI_2_BLUE 255.0/255.0


//opaque overlay color used when the game is paused
#define OPAQUE_RED 0.35
#define OPAQUE_GREEN 0.35
#define OPAQUE_BLUE 0.35
#define OPAQUE_ALPHA 0.35


//max angle (with respect to horizontal) the bat flys
#define MAX_FLY_ANGLE M_PI/8.0

//cave deminsions
#define CAVE_CEILING_HEIGHT 10.0
#define CAVE_FLOOR_HEIGHT 10.0

//number of checkerboard columns on finish line
#define FINISH_LINE_NUM_COLUMNS 4


#endif /* UIDefinitions_h */
