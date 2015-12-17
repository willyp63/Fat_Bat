//
//  ViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/12/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

-(id)initWithLevelName:(NSString *)levelName{
    self = [super init];
    if (self) {
        _levelName = levelName;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //start new game
    [self startNewGame];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}


-(void)startNewGame{
    //stop update timer
    if (_updateTimer) {[_updateTimer invalidate];}
    
    //remove all subviews
    for (UIView *view in self.view.subviews) {[view removeFromSuperview];}
    
    
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    
    //cave frame
    CGRect caveFrame = CGRectMake(0.0, statusBarHeight + CAVE_CEILING_HEIGHT, screenSize.width, screenSize.height - statusBarHeight - CAVE_CEILING_HEIGHT - CAVE_FLOOR_HEIGHT);
    
    //init model
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:_levelName ofType:@"txt"];
    _model = [[GameModel alloc] initWithCaveFrame:caveFrame filePath:levelFilePath];
    
    
    //cave colors
    _outerCaveColor = [UIColor colorWithRed:OUTER_CAVE_RED green:OUTER_CAVE_GREEN blue:OUTER_CAVE_BLUE alpha:1.0];
    UIColor *innerCaveColor = [UIColor colorWithRed:INNER_CAVE_RED green:INNER_CAVE_GREEN blue:INNER_CAVE_BLUE alpha:1.0];
    
    
    //init cave view and add to root view
    CGRect caveViewFrame = CGRectMake(caveFrame.origin.x - BORDER_WIDTH, caveFrame.origin.y, caveFrame.size.width + BORDER_WIDTH*2, caveFrame.size.height);
    UIView *caveView = [[UIView alloc] initWithFrame:caveViewFrame];
    caveView.layer.borderWidth = BORDER_WIDTH;
    caveView.layer.borderColor = [UIColor blackColor].CGColor;
    caveView.layer.backgroundColor = innerCaveColor.CGColor;
    [self.view addSubview:caveView];
    
    
    //init finish line view and layer
    CGRect finishLineFrame = CGRectMake(_model.finishLine, caveFrame.origin.y + BORDER_WIDTH, FINISH_LINE_WIDTH, caveFrame.size.height - BORDER_WIDTH*2.0);
    _finishLineView = [[FinishLineView alloc] initWithFrame:finishLineFrame numberOfColumns:FINISH_LINE_NUM_COLUMNS];
    [self.view addSubview:_finishLineView];
    
    
    //create bat view and add to root view
    _batView = [[BatView alloc] initWithFrame:_model.bat.frame borderWidth:BORDER_WIDTH];
    [self.view addSubview:_batView];
    
    
    //create and add ceailing and floor views
    _caveCeilingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, statusBarHeight, caveFrame.size.width, CAVE_CEILING_HEIGHT)];
    _caveFloorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, caveFrame.origin.y + caveFrame.size.height, caveFrame.size.width, CAVE_FLOOR_HEIGHT)];
    _caveCeilingView.backgroundColor = _outerCaveColor;
    _caveFloorView.backgroundColor = _outerCaveColor;
    [self.view addSubview:_caveCeilingView];
    [self.view addSubview:_caveFloorView];
    
    
    //init stalagmite views
    _stalagmiteViews = [[NSMutableArray alloc] initWithCapacity:_model.numStalagmite];
    
    
    //init and add hold button to root view
    _holdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _holdButton.frame = self.view.bounds;
    [_holdButton addTarget:self action:@selector(fingerDown) forControlEvents:UIControlEventTouchDown];
    [_holdButton addTarget:self action:@selector(fingerUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_holdButton];
    
    //init and add pause button to root view
    CGRect pauseButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH - GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    _pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pauseButton.frame = pauseButtonFrame;
    _pauseButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    _pauseButton.layer.borderWidth = BORDER_WIDTH;
    _pauseButton.layer.borderColor = [UIColor blackColor].CGColor;
    _pauseButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [_pauseButton addTarget:self action:@selector(pauseGame) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_pauseButton];
    
    //init and add label to pause button view
    UILabel *pauseButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, pauseButtonFrame.size.width, pauseButtonFrame.size.height)];
    pauseButtonLabel.text = @"pause";
    pauseButtonLabel.textAlignment = NSTextAlignmentCenter;
    pauseButtonLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    [_pauseButton addSubview:pauseButtonLabel];
    
    //init and add quit button to root view
    CGRect quitButtonFrame = CGRectMake(GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    _quitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _quitButton.frame = quitButtonFrame;
    _quitButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    _quitButton.layer.borderWidth = BORDER_WIDTH;
    _quitButton.layer.borderColor = [UIColor blackColor].CGColor;
    _quitButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [_quitButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_quitButton];
    
    //init and add label to quit button view
    UILabel *quitButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, quitButtonFrame.size.width, quitButtonFrame.size.height)];
    quitButtonLabel.text = @"quit";
    quitButtonLabel.textAlignment = NSTextAlignmentCenter;
    quitButtonLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    [_quitButton addSubview:quitButtonLabel];
    
    
    //start update timer
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL target:self selector:@selector(update) userInfo:Nil repeats:NO];
}


-(void)pauseGame{
    //if game is paused
    if (_model.state == PAUSED) {
        //set state to in progress
        [_model setState:IN_PROGRESS];
        
        //clear hold button's bg
        _holdButton.backgroundColor = [UIColor clearColor];
        
        //start update timer
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL target:self selector:@selector(update) userInfo:Nil repeats:NO];
    }else{
        //set state to paused
        [_model setState:PAUSED];
        
        //set opaque layer over cave views
        _holdButton.backgroundColor = [UIColor colorWithRed:OPAQUE_RED green:OPAQUE_GREEN blue:OPAQUE_BLUE alpha:OPAQUE_ALPHA];
        
        //stop update timer
        [_updateTimer invalidate];
    }
}

-(void)quitGame{
    //pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)levelComplete{
    //load file and spereate into lines
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/levels.txt"];
    NSString *string = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //this levels string in file
    NSString *levelString = [_levelName stringByAppendingString:@" NO"];
    
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
                    string = [string stringByAppendingString:[_levelName stringByAppendingString:@" YES"]];
                }
                //else copy old line
                else{
                    string = [string stringByAppendingString:lines[j]];
                }
                
                //return if not the last line
                if (j < lines.count - 1) {string = [string stringByAppendingString:@"\r"];}
            }
            
            //write to file
            [string writeToFile:docPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
            break;
        }
    }
    
    [self quitGame];
}

-(void)fingerDown{[self setIsDiving:YES];}
-(void)fingerUp{[self setIsDiving:NO];}

-(void)setIsDiving:(BOOL)isDiving{
    //update model
    [_model setIsDiving:isDiving];
    
    //update view if not paused
    if(_model.state != PAUSED) {[_batView setIsDiving:isDiving];}
}


-(void)update{
    //get start time
    CFTimeInterval startTime = CACurrentMediaTime();
    
    
    //check for game over
    if (_model.state == GAME_OVER) {
        [self startNewGame];
        return;
    }
    
    //check for level complete
    if(_model.state == LEVEL_COMPLETE){
        [self levelComplete];
        return;
    }
    
    
    //remove stalagmite
    for (int i = 0; i < _stalagmiteViews.count; i++) {
        UIView *stalagmiteView = _stalagmiteViews[i];
        
        if (stalagmiteView.frame.origin.x + stalagmiteView.frame.size.width < _model.caveFrame.origin.x) {
            [stalagmiteView removeFromSuperview];
            [_stalagmiteViews removeObjectAtIndex:i--];
        }
    }
    [_model removeCharacters];
    
    
    //add new stalagmite
    [_model addNewCharacters];
    for (int i = (int)_stalagmiteViews.count; i < (int)_model.stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _model.stalagmite[i];
        
        BOOL facingDown = (stalagmiteObject.frame.origin.y == _model.caveFrame.origin.y);
        StalagmiteView *stalagmiteView = [[StalagmiteView alloc] initWithFrame:stalagmiteObject.frame color:_outerCaveColor borderWidth:BORDER_WIDTH facingDown:facingDown];
        
        [self.view addSubview:stalagmiteView];
        [_stalagmiteViews addObject:stalagmiteView];
    }
    
    //bring ui views in front of new views
    [self.view bringSubviewToFront:_caveFloorView];
    [self.view bringSubviewToFront:_caveCeilingView];
    [self.view bringSubviewToFront:_holdButton];
    [self.view bringSubviewToFront:_pauseButton];
    [self.view bringSubviewToFront:_quitButton];
    
    
    //update model
    [_model update];

    
    //set bat angle based on y velocity
    CGFloat angle = (_model.bat.velocity.y / TERMINAL_Y_VELOCITY) * MAX_FLY_ANGLE;
    [_batView setAngle:angle];
    
    //set bat views isdiving property if not already done so
    if ([_model isDiving] != [_batView isDiving]) {
        [_batView setIsDiving:_model.isDiving];
    }
    
    //check for bounce
    if (_model.didBounce) {
        //calc animation times
        CGFloat timeToBounceFrame = _model.timeToBounce * UPDATE_TIME_INTERVAL;
        CGFloat timeToNewFrame = UPDATE_TIME_INTERVAL - timeToBounceFrame;
        
        //make bounce rect
        CGRect bounceFrame = CGRectMake(_model.bat.frame.origin.x, _model.bounceFrameY, _model.bat.frame.size.width, _model.bat.frame.size.height);
        
        //animate bat moving to bounce frame then new frame
        [UIView animateWithDuration:timeToBounceFrame delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _batView.frame = bounceFrame;
        }completion:^(BOOL finished){
            [UIView animateWithDuration:timeToNewFrame delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                _batView.frame = _model.bat.frame;
            }completion:NULL];
        }];
    }
    //did not bounce
    else{
        //animate bat moving to new frame
        [UIView animateWithDuration:UPDATE_TIME_INTERVAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _batView.frame = _model.bat.frame;
        }completion:NULL];
    }
    
    //update stalagmite views
    for (int i = 0; i < _stalagmiteViews.count; i++) {
        UIView *stalagmiteView = _stalagmiteViews[i];
        GameObjectModel *stalagmiteObject = _model.stalagmite[i];
        
        [UIView animateWithDuration:UPDATE_TIME_INTERVAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            stalagmiteView.frame = stalagmiteObject.frame;
        }completion:NULL];
    }
    
    //update finish line view
    [UIView animateWithDuration:UPDATE_TIME_INTERVAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _finishLineView.frame = CGRectMake(_model.finishLine, _model.caveFrame.origin.y + BORDER_WIDTH, FINISH_LINE_WIDTH, _model.caveFrame.size.height - BORDER_WIDTH*2.0);
    }completion:NULL];

    
    //get elapsed time
    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
    
    //if not paused
    if (_model.state != PAUSED) {
        //start update timer
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:(UPDATE_TIME_INTERVAL - elapsedTime) target:self selector:@selector(update) userInfo:Nil repeats:NO];
    }
}

@end
