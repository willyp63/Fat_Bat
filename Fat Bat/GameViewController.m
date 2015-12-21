//
//  ViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/12/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController{
    BOOL _quitGame;
}

-(id)initWithLevelName:(NSString *)levelName{
    self = [super init];
    if (self) {
        _levelName = levelName;
        _quitGame = NO;
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
    _model = [[GameModel alloc] initWithCaveFrame:caveFrame levelName:_levelName];
    
    
    //cave colors
    _outerCaveColor = [UIColor colorWithRed:_model.colorRGBValues[0].floatValue green:_model.colorRGBValues[1].floatValue blue:_model.colorRGBValues[2].floatValue alpha:1.0];
    UIColor *innerCaveColor = [UIColor colorWithRed:_model.colorRGBValues[0].floatValue/3.0 green:_model.colorRGBValues[1].floatValue/3.0 blue:_model.colorRGBValues[2].floatValue/3.0 alpha:1.0];
    UIColor *shadowCaveColor = [UIColor colorWithRed:_model.colorRGBValues[0].floatValue/1.5 green:_model.colorRGBValues[1].floatValue/1.5 blue:_model.colorRGBValues[2].floatValue/1.5 alpha:1.0];
    
    
    //set bg color
    self.view.backgroundColor = _outerCaveColor;
    
    
    //init cave view
    CGRect caveViewFrame = CGRectMake(caveFrame.origin.x - BORDER_WIDTH*2.0, caveFrame.origin.y, caveFrame.size.width + BORDER_WIDTH*4.0, caveFrame.size.height);
    UIView *caveView = [[UIView alloc] initWithFrame:caveViewFrame];
    
    //add gradient layer
    CAGradientLayer *caveLayer = [CAGradientLayer layer];
    caveLayer.frame = caveView.bounds;
    caveLayer.borderWidth = BORDER_WIDTH*2.0;
    caveLayer.borderColor = [UIColor blackColor].CGColor;
    caveLayer.colors = [NSArray arrayWithObjects:(id)shadowCaveColor.CGColor, (id)innerCaveColor.CGColor, (id)innerCaveColor.CGColor, (id)shadowCaveColor.CGColor, nil];
    caveLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.45], [NSNumber numberWithFloat:0.55], nil];
    [caveView.layer addSublayer:caveLayer];
    
    //add cave view to root view
    [self.view addSubview:caveView];
    
    
    //init finish line view and add to root view
    CGRect finishLineFrame = CGRectMake(_model.finishLine, caveFrame.origin.y + BORDER_WIDTH*2.0, _model.subDivisionSize, caveFrame.size.height - BORDER_WIDTH*4.0);
    _finishLineView = [[FinishLineView alloc] initWithFrame:finishLineFrame numberOfColumns:FINISH_LINE_NUM_COLUMNS];
    [self.view addSubview:_finishLineView];
    
    
    //init bat view and add to root view
    _batView = [[BatView alloc] initWithFrame:_model.bat.frame borderWidth:BORDER_WIDTH];
    [self.view addSubview:_batView];
    
    
    //create and add ceailing and floor views
    _caveCeilingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, statusBarHeight, caveFrame.size.width, CAVE_CEILING_HEIGHT + BORDER_WIDTH)];
    _caveFloorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, caveFrame.origin.y + caveFrame.size.height - BORDER_WIDTH, caveFrame.size.width, CAVE_FLOOR_HEIGHT + BORDER_WIDTH)];
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
    
    
    //init and add quit button to root view
    CGRect quitButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH - GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    _quitButton = [[MyButton alloc] initWithFrame:quitButtonFrame cornerRadius:BUTTON_CORNER_RADIUS borderWidth:BORDER_WIDTH color:[UIColor whiteColor] text:@"quit" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE] responder:self];
    [self.view addSubview:_quitButton];
    
    //init and add pause button to root view
    CGRect pauseButtonFrame = CGRectMake(quitButtonFrame.origin.x - GAME_BUTTON_WIDTH - GAME_BUTTON_OFFSET, GAME_BUTTON_OFFSET + statusBarHeight, GAME_BUTTON_WIDTH, GAME_BUTTON_HEIGHT);
    _pauseButton = [[MyButton alloc] initWithFrame:pauseButtonFrame cornerRadius:BUTTON_CORNER_RADIUS borderWidth:BORDER_WIDTH color:[UIColor whiteColor] text:@"pause" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE] responder:self];
    [self.view addSubview:_pauseButton];
    
    
    //start update timer
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL target:self selector:@selector(update) userInfo:Nil repeats:NO];
}

-(void)buttonPressed:(MyButton *)button{
    //QUIT BUTTON PRESSED
    if ([button.text isEqualToString:@"quit"]) {
        //quit game
        [self quitGame];
    }
    //PAUSE BUTTON PRESSED
    else if ([button.text isEqualToString:@"pause"]) {
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
}

-(void)quitGame{
    _quitGame = YES;
    
    //pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}

//hold button target methods
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
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"CONGRATS!" message:@"level complete" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                                //dismiss alert view
                                [alert dismissViewControllerAnimated:YES completion:nil];
            
                                //update levels file
                                [LevelFileHandler setLevelComplete:_levelName];
            
                                //quit game
                                [self quitGame];
                             }];
        [alert addAction:ok];
        
        if (!_quitGame) {
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        return;
    }
    
    
    //remove stalagmite views
    for (int i = 0; i < _stalagmiteViews.count; i++) {
        UIView *stalagmiteView = _stalagmiteViews[i];
        
        //remove if view is off the screen to the left
        if (stalagmiteView.frame.origin.x + stalagmiteView.frame.size.width < _model.caveFrame.origin.x) {
            [stalagmiteView removeFromSuperview];
            [_stalagmiteViews removeObjectAtIndex:i--];
        }
    }
    //remove stalagmite model
    [_model removeStalagmite];
    
    
    //add new stalagmite models
    [_model addNewStalagmite];
    
    //add new stalagmite views for new models
    for (int i = (int)_stalagmiteViews.count; i < (int)_model.stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _model.stalagmite[i];
        
        //create view
        BOOL facingDown = (stalagmiteObject.frame.origin.y == _model.caveFrame.origin.y);
        StalagmiteView *stalagmiteView = [[StalagmiteView alloc] initWithFrame:stalagmiteObject.frame color:_outerCaveColor borderWidth:BORDER_WIDTH facingDown:facingDown];
        
        //add view
        [self.view addSubview:stalagmiteView];
        [_stalagmiteViews addObject:stalagmiteView];
    }
    
    
    //bring ui and ceiling/floor views in front of new stalagmite views
    [self.view bringSubviewToFront:_caveFloorView];
    [self.view bringSubviewToFront:_caveCeilingView];
    [self.view bringSubviewToFront:_holdButton];
    [self.view bringSubviewToFront:_pauseButton];
    [self.view bringSubviewToFront:_quitButton];
    
    
    //update model
    [_model update];

    
    //set bat angle based on y velocity
    CGFloat angle = (_model.bat.velocity.y / _model.terminalYVelocity) * MAX_FLY_ANGLE;
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
        
        //animate bat moving to bounce frame, then new frame
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
        
        //move to new frame
        [UIView animateWithDuration:UPDATE_TIME_INTERVAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            stalagmiteView.frame = stalagmiteObject.frame;
        }completion:NULL];
    }
    
    
    //update finish line view
    [UIView animateWithDuration:UPDATE_TIME_INTERVAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _finishLineView.frame = CGRectMake(_model.finishLine, _model.caveFrame.origin.y + BORDER_WIDTH*2.0, _model.subDivisionSize, _model.caveFrame.size.height - BORDER_WIDTH*4.0);
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
