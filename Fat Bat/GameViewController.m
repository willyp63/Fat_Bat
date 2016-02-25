//
//  ViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/12/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

-(id)initWithLevelName:(NSString *)levelName audioHandler:(AudioHandler *)audioHandler{
    self = [super init];
    if (self) {
        //save level name
        _levelName = levelName;
        
        //save audio handler
        _audioHandler = audioHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load sound effects
    [_audioHandler addSoundURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio/jump_sound" ofType:@"caf"]]]; //sound num 1
    [_audioHandler addSoundURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio/fatbat_collision_noise" ofType:@"caf"]]]; //sound num 2
    [_audioHandler addSoundURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio/level_complete_sound" ofType:@"caf"]]]; //sound num 3
    
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
    
    
    //get screen deminsions and ui scales
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat scaleY = screenSize.height / IPHONE_6S_SCREEN_HEIGHT;
    CGFloat scaleX = screenSize.width / IPHONE_6S_SCREEN_WIDTH;
    
    //calc ceiling height
    CGFloat caveHeight = IPHONE_6S_CAVE_HEIGHT*screenSize.width/IPHONE_6S_CAVE_WIDTH;
    CGFloat ceilingHeight = (screenSize.height - statusBarHeight - caveHeight)/2.0;
    if (ceilingHeight < MIN_CEILING_HEIGHT*scaleY) {ceilingHeight = MIN_CEILING_HEIGHT*scaleY;}
    
    //CAVE FRAME
    CGRect caveFrame = CGRectMake(0.0, statusBarHeight + ceilingHeight, screenSize.width, screenSize.height - statusBarHeight - ceilingHeight*2.0);
    
    //cave scale
    CGFloat caveScale = caveFrame.size.height / IPHONE_6S_CAVE_HEIGHT;
    
    //init model
    _model = [[GameModel alloc] initWithCaveFrame:caveFrame levelName:_levelName];
    
    
    //load music
    [_audioHandler stopMusic];
    [_audioHandler setMusicURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"audio/cave_song_%d", _model.songNum] ofType:@"caf"]]];
    
    
    //CAVE COLORS
    _outerCaveColor = [UIColor colorWithRed:_model.colorRGBValues[0].floatValue green:_model.colorRGBValues[1].floatValue blue:_model.colorRGBValues[2].floatValue alpha:1.0];
    UIColor *innerCaveColor = [UIColor colorWithRed:_model.colorRGBValues[0].floatValue/3.0 green:_model.colorRGBValues[1].floatValue/3.0 blue:_model.colorRGBValues[2].floatValue/3.0 alpha:1.0];
    UIColor *shadowCaveColor = [UIColor colorWithRed:_model.colorRGBValues[0].floatValue/1.5 green:_model.colorRGBValues[1].floatValue/1.5 blue:_model.colorRGBValues[2].floatValue/1.5 alpha:1.0];
    
    //set bg color
    self.view.backgroundColor = _outerCaveColor;
    
    
    //CAVE VIEW
    CGRect caveViewFrame = CGRectMake(caveFrame.origin.x - BORDER_WIDTH*scaleY*2.0, caveFrame.origin.y, caveFrame.size.width + BORDER_WIDTH*scaleY*4.0, caveFrame.size.height);
    
    UIView *caveView = [[UIView alloc] initWithFrame:caveViewFrame];
    
    //add gradient layer
    CAGradientLayer *caveLayer = [CAGradientLayer layer];
    caveLayer.frame = caveView.bounds;
    caveLayer.borderWidth = BORDER_WIDTH*caveScale*2.0;
    caveLayer.borderColor = [UIColor blackColor].CGColor;
    caveLayer.colors = [NSArray arrayWithObjects:(id)shadowCaveColor.CGColor, (id)innerCaveColor.CGColor, (id)innerCaveColor.CGColor, (id)shadowCaveColor.CGColor, nil];
    caveLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.45], [NSNumber numberWithFloat:0.55], nil];
    [caveView.layer addSublayer:caveLayer];
    
    [self.view addSubview:caveView];
    
    
    //CAVE CEILING/ FLOOR VIEWs
    _caveCeilingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, caveFrame.size.width, ceilingHeight + BORDER_WIDTH*caveScale + statusBarHeight)];
    _caveFloorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, caveFrame.origin.y + caveFrame.size.height - BORDER_WIDTH*caveScale, caveFrame.size.width, ceilingHeight + BORDER_WIDTH*caveScale)];
    _caveCeilingView.backgroundColor = _outerCaveColor;
    _caveFloorView.backgroundColor = _outerCaveColor;
    [self.view addSubview:_caveCeilingView];
    [self.view addSubview:_caveFloorView];
    
    
    //FINISH LINE VIEW
    CGRect finishLineFrame = CGRectMake(_model.finishLine, caveFrame.origin.y + BORDER_WIDTH*caveScale*2.0, _model.subDivisionSize, caveFrame.size.height - BORDER_WIDTH*caveScale*4.0);
    _finishLineView = [[FinishLineView alloc] initWithFrame:finishLineFrame numberOfColumns:FINISH_LINE_NUM_COLUMNS];
    [self.view addSubview:_finishLineView];
    
    
    //BAT VIEW
    _batView = [[BatView alloc] initWithFrame:_model.bat.frame borderWidth:BORDER_WIDTH*caveScale];
    [self.view addSubview:_batView];
    
    
    //STALAGMITE VIEWS
    _stalagmiteViews = [[NSMutableArray alloc] initWithCapacity:_model.numStalagmite];
    
    
    //HOLD BUTTON
    _holdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _holdButton.frame = self.view.bounds;
    [_holdButton addTarget:self action:@selector(fingerDown) forControlEvents:UIControlEventTouchDown];
    [_holdButton addTarget:self action:@selector(fingerUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_holdButton];
    
    
    //PAUSE BUTTON
    CGRect pauseButtonFrame = CGRectMake(screenSize.width - GAME_BUTTON_WIDTH*2.0*scaleY - GAME_BUTTON_OFFSET*scaleY, GAME_BUTTON_OFFSET*scaleY + statusBarHeight, GAME_BUTTON_WIDTH*2.0*scaleY, GAME_BUTTON_HEIGHT*scaleY);
    
    _pauseButton = [[MyButton alloc] initWithFrame:pauseButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"PAUSE" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY/2.0] responder:self];
    [self.view addSubview:_pauseButton];
    
    
    //PROGRESS BAR
    CGRect progressBarFrame = CGRectMake((screenSize.width - PROGRESS_BAR_WIDTH*scaleX)/2.0, GAME_BUTTON_OFFSET*scaleY + statusBarHeight, PROGRESS_BAR_WIDTH*scaleX, PROGRESS_BAR_HEIGHT*scaleY);
    
    _progressBar = [[ProgressBarView alloc] initWithFrame:progressBarFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY
                                                   color1:[UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0]
                                                   color2:[UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0]];
    [self.view addSubview:_progressBar];
    
    
    if ([_levelName isEqualToString:@"Easy_Beginning"]) {
        //init synnopisis alert view and present it
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Welcome to the Colored Caverns!" message:@"Reach the finish by avoiding stalagmites. Tap and hold to dive. Release to resume flying." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            //dismiss alert view
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            [self startGame];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self startGame];
    }
}

-(void)startGame{
    //play music
    [_audioHandler tryPlayMusic];
    
    //start update timer
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL target:self selector:@selector(update) userInfo:Nil repeats:NO];
}


-(void)buttonPressed:(MyButton *)button{
    //PAUSE BUTTON PRESSED
    if ([button.textLabel.text isEqualToString:@"PAUSE"]) {
        //pause game
        [self pause];
    }
    //RESUME BUTTON PRESSED
    else if ([button.textLabel.text isEqualToString:@"PLAY"]) {
        //quit game
        [self unpause];
    }
    //QUIT BUTTON PRESSED
    else if ([button.textLabel.text isEqualToString:@"EXIT"]) {
        //quit game
        [self quitGame];
    }
    //MUSIC BUTTON PRESSED
    else if ([button.textLabel.text isEqualToString:@"MUSIC"]) {
        [_audioHandler toggleMusic];
    }
    //SOUND BUTTON PRESSED
    else if ([button.textLabel.text isEqualToString:@"SOUND"]) {
        [_audioHandler toggleSound];
    }
}

-(void)pause{
    //set state to paused
    [_model setState:PAUSED];
    
    //change button text
    _pauseButton.textLabel.text = @"PLAY";
    [_pauseButton.textLabel setNeedsDisplay];
    
    //set opaque layer over cave views
    _holdButton.backgroundColor = [UIColor colorWithRed:OPAQUE_RED green:OPAQUE_GREEN blue:OPAQUE_BLUE alpha:OPAQUE_ALPHA];
    
    //stop update timer
    [_updateTimer invalidate];
    
    
    //stop music
    [_audioHandler pauseMusic];
    
    
    //get screen deminsions and ui scales
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat scaleY = screenSize.height / IPHONE_6S_SCREEN_HEIGHT;
    
    //MENU FRAME
    CGRect menuFrame = CGRectMake((screenSize.width - GAME_BUTTON_WIDTH*scaleY*51.0/5.0 - GAME_BUTTON_OFFSET*scaleY*4.0)/2.0, (screenSize.height - GAME_BUTTON_HEIGHT*scaleY*8.0/5.0)/2.0 + statusBarHeight/2.0, GAME_BUTTON_WIDTH*scaleY*51.0/5.0 + GAME_BUTTON_OFFSET*scaleY*4.0, GAME_BUTTON_HEIGHT*scaleY*8.0/5.0);
    
    //ADD MUSIC BUTTON
    CGRect musicButtonFrame = CGRectMake(menuFrame.origin.x, menuFrame.origin.y, GAME_BUTTON_WIDTH*scaleY*17.0/5.0, GAME_BUTTON_HEIGHT*scaleY*8.0/5.0);
    
    _musicButton = [[MyButton alloc] initWithFrame:musicButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"MUSIC" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY] responder:self];
    [_musicButton setIsToggleButton:YES];
    [_musicButton setToggle:!_audioHandler.musicToggle];
    [self.view addSubview:_musicButton];
    
    //ADD SOUND BUTTON
    CGRect soundButtonFrame = CGRectMake(musicButtonFrame.origin.x + musicButtonFrame.size.width + GAME_BUTTON_OFFSET*scaleY*2.0, menuFrame.origin.y, musicButtonFrame.size.width, musicButtonFrame.size.height);
    
    _soundButton = [[MyButton alloc] initWithFrame:soundButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"SOUND" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY] responder:self];
    [_soundButton setIsToggleButton:YES];
    [_soundButton setToggle:!_audioHandler.soundToggle];
    [self.view addSubview:_soundButton];
    
    //ADD QUIT BUTTON
    CGRect quitButtonFrame = CGRectMake(soundButtonFrame.origin.x + soundButtonFrame.size.width + GAME_BUTTON_OFFSET*scaleY*2.0, menuFrame.origin.y, musicButtonFrame.size.width, musicButtonFrame.size.height);
    
    _quitButton = [[MyButton alloc] initWithFrame:quitButtonFrame cornerRadius:BUTTON_CORNER_RADIUS*scaleY borderWidth:BORDER_WIDTH*scaleY color:[UIColor whiteColor] text:@"EXIT" font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*scaleY] responder:self];
    [self.view addSubview:_quitButton];
}

-(void)unpause{
    //set state to in progress
    [_model setState:IN_PROGRESS];
    
    //change button text
    _pauseButton.textLabel.text = @"PAUSE";
    [_pauseButton.textLabel setNeedsDisplay];
    
    //clear hold button's bg
    _holdButton.backgroundColor = [UIColor clearColor];
    
    //start update timer
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL target:self selector:@selector(update) userInfo:Nil repeats:NO];
    
    //play music
    [_audioHandler tryPlayMusic];
    
    
    //remove menu
    [_musicButton removeFromSuperview];
    [_soundButton removeFromSuperview];
    [_quitButton removeFromSuperview];
}


-(void)quitGame{
    //stop timer
    [_updateTimer invalidate];
    
    //check if level was completed
    if(_model.state == LEVEL_COMPLETE){
        //mark level as complete
        [LevelFileHandler setLevelComplete:_levelName];
    }
    
    //stop music
    [_audioHandler stopMusic];
    
    //clear sounds
    [_audioHandler removeAllSounds];
    
    //pop view controller
    [self.navigationController popViewControllerAnimated:YES];
}


//hold button target methods
-(void)fingerDown{
    [self setIsDiving:YES];
}

-(void)fingerUp{
    [self setIsDiving:NO];
}

-(void)setIsDiving:(BOOL)isDiving{
    //update model
    [_model setIsDiving:isDiving];
    
    //update view if not paused
    if(_model.state != PAUSED) {[_batView setIsDiving:isDiving];}
}


-(void)update{
    //get start time
    CFTimeInterval startTime = CACurrentMediaTime();
    
    //cave scale
    CGFloat caveScale = _model.caveFrame.size.height / IPHONE_6S_CAVE_HEIGHT;
    
    
    //check for game over
    if (_model.state == GAME_OVER) {
        //start new game
        [self startNewGame];
        return;
    }
    
    //check for level complete
    if(_model.state == LEVEL_COMPLETE){
        //play compeletion sound
        [_audioHandler playSound:2];
        
        //stop music
        [_audioHandler stopMusic];
        
        //init alert view and present it
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Congrats!" message:@"cavern complete" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            //dismiss alert view
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            //quit game
            [self quitGame];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
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
    //remove stalagmite models
    [_model removeStalagmite];
    
    
    //add new stalagmite models
    [_model addNewStalagmite];
    
    //add new stalagmite views for new models
    for (int i = (int)_stalagmiteViews.count; i < (int)_model.stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _model.stalagmite[i];
        
        //create view
        BOOL facingDown = (stalagmiteObject.frame.origin.y == _model.caveFrame.origin.y);
        StalagmiteView *stalagmiteView = [[StalagmiteView alloc] initWithFrame:stalagmiteObject.frame color:_outerCaveColor borderWidth:BORDER_WIDTH*caveScale facingDown:facingDown];
        
        //add view
        [self.view addSubview:stalagmiteView];
        [_stalagmiteViews addObject:stalagmiteView];
    }
    
    
    //bring ui and ceiling/ floor views in front of new stalagmite views
    [self.view bringSubviewToFront:_caveFloorView];
    [self.view bringSubviewToFront:_caveCeilingView];
    [self.view bringSubviewToFront:_holdButton];
    [self.view bringSubviewToFront:_pauseButton];
    [self.view bringSubviewToFront:_quitButton];
    [self.view bringSubviewToFront:_progressBar];
    
    
    //update model
    [_model update];
    
    if (_model.state == GAME_OVER) {
        //play collision sound
        [_audioHandler playSound:1];
    }

    
    //set bat angle based on y velocity
    CGFloat angle = (_model.bat.velocity.y / _model.terminalYVelocity) * MAX_FLY_ANGLE;
    [_batView setAngle:angle];
    
    //set bat views isdiving property if not already done so
    if ([_model isDiving] != [_batView isDiving]) {
        [_batView setIsDiving:_model.isDiving];
    }
    
    
    //check for bounce
    if (_model.didBounce) {
        //play bounce sound
        [_audioHandler playSound:0];
        
        //calc animation times
        CFTimeInterval updateTime = UPDATE_TIME_INTERVAL - CACurrentMediaTime() + startTime;
        CGFloat timeToBounceFrame = _model.timeToBounce * updateTime;
        CGFloat timeToNewFrame = updateTime - timeToBounceFrame;
        
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
        [UIView animateWithDuration:(UPDATE_TIME_INTERVAL - CACurrentMediaTime() + startTime) delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _batView.frame = _model.bat.frame;
        }completion:NULL];
    }
    
    
    //update stalagmite views
    for (int i = 0; i < _stalagmiteViews.count; i++) {
        UIView *stalagmiteView = _stalagmiteViews[i];
        GameObjectModel *stalagmiteObject = _model.stalagmite[i];
        
        //move to new frame
        [UIView animateWithDuration:(UPDATE_TIME_INTERVAL - CACurrentMediaTime() + startTime) delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            stalagmiteView.frame = stalagmiteObject.frame;
        }completion:NULL];
    }

    
    //update finish line view
    [UIView animateWithDuration:(UPDATE_TIME_INTERVAL - CACurrentMediaTime() + startTime) delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _finishLineView.frame = CGRectMake(_model.finishLine, _model.caveFrame.origin.y + BORDER_WIDTH*caveScale*2.0, _model.subDivisionSize, _model.caveFrame.size.height - BORDER_WIDTH*caveScale*4.0);
    }completion:NULL];
    
    
    //update progress bar
    CGFloat timeOffset = (_model.caveFrame.origin.x + _model.caveFrame.size.width - _model.bat.frame.origin.x - _model.bat.frame.size.width) / _model.subDivisionSize;
    CGFloat progress = _model.time / (_model.finishTime + floorf(timeOffset));
    [_progressBar setProgress:progress];

    
    //if not paused
    if (_model.state != PAUSED) {
        //start update timer
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:((UPDATE_TIME_INTERVAL - CACurrentMediaTime() + startTime)) target:self selector:@selector(update) userInfo:Nil repeats:NO];
    }
}

@end
