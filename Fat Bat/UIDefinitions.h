//
//  UIDefinitions.h
//  Fat Bat
//
//  Created by Wil Pirino on 12/16/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#ifndef UIDefinitions_h
#define UIDefinitions_h

//definitions used to size UIDefintions for other screen sizes
#define IPHONE_6S_SCREEN_HEIGHT 375.0
#define IPHONE_6S_SCREEN_WIDTH 667.0

#define IPHONE_6S_CAVE_HEIGHT 355.0
#define IPHONE_6S_CAVE_WIDTH 667.0


//border with of most paths being drawn
#define BORDER_WIDTH 2.0


//buttons
#define BUTTON_CORNER_RADIUS 8.0

#define GAME_BUTTON_OFFSET 5.0
#define GAME_BUTTON_WIDTH 40.0
#define GAME_BUTTON_HEIGHT 40.0

#define PLAY_BUTTON_WIDTH 160.0
#define PLAY_BUTTON_HEIGHT 80.0


//progress bar
#define PROGRESS_BAR_OFFSET 5.0
#define PROGRESS_BAR_WIDTH 280.0
#define PROGRESS_BAR_HEIGHT 20.0


//Fat Bat label
#define TITLE_LABEL_WIDTH 500.0
#define TITLE_LABEL_HEIGHT 350.0


//fonts
#define FONT_NAME @"HelveticaNeue-Bold"
#define FONT_SIZE 32.0
#define TITLE_FONT_SIZE 128.0


//ui colors
#define UI_1_RED 125.0/255.0
#define UI_1_GREEN 102.0/255.0
#define UI_1_BLUE 255.0/255.0

#define UI_2_RED 255.0/255.0
#define UI_2_GREEN 176.0/255.0
#define UI_2_BLUE 255.0/255.0

#define UI_SELECT_RED 255.0/255.0
#define UI_SELECT_GREEN 204.0/255.0
#define UI_SELECT_BLUE 255.0/255.0


//bat body color
#define BODY_RED 125.0/255.0
#define BODY_GREEN 102.0/255.0
#define BODY_BLUE 255.0/255.0

//bat ear and wing color
#define EAR_WING_RED 255.0/255.0
#define EAR_WING_GREEN 176.0/255.0
#define EAR_WING_BLUE 255.0/255.0


//opaque overlay color used when the game is paused
#define OPAQUE_RED 0.5
#define OPAQUE_GREEN 0.5
#define OPAQUE_BLUE 0.5
#define OPAQUE_ALPHA 0.5


//max angle (with respect to horizontal) the bat flys
#define MAX_FLY_ANGLE M_PI/4.0

//angle the bat looks with respect to horizon
#define LOOK_ANGLE M_PI/24.0


//cave deminsions
#define MIN_CEILING_HEIGHT 10.0


//number of checkerboard columns on finish line
#define FINISH_LINE_NUM_COLUMNS 4

#endif /* UIDefinitions_h */
