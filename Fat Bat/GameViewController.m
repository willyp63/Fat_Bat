//
//  ViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/12/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

static CGFloat BAT_X_OFFSET = 64.0;
static CGFloat BAT_Y_OFFSET = 64.0;

static CGFloat CAVE_BORDER_WIDTH = 4.0;

static int NUMBER_OF_CAVE_DIVISIONS = 9;

static CGFloat CAVE_CEILING_HEIGHT = 10;
static CGFloat CAVE_FLOOR_HEIGHT = 10;

static CGFloat UPDATE_TIME_INTERVAL = 0.2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startNewGame];
}

-(void)startNewGame{
    //get screen deminsions
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //cave frame
    CGRect caveFrame = CGRectMake(0.0, statusBarHeight + CAVE_CEILING_HEIGHT, screenSize.width, screenSize.height - statusBarHeight - CAVE_CEILING_HEIGHT - CAVE_FLOOR_HEIGHT);
    
    //cave layer frame
    CGRect caveLayerFrame = CGRectMake(caveFrame.origin.x - CAVE_BORDER_WIDTH, caveFrame.origin.y, caveFrame.size.width + CAVE_BORDER_WIDTH*2, caveFrame.size.height);
    
    //bat view frame
    CGFloat batSize = caveFrame.size.height/NUMBER_OF_CAVE_DIVISIONS;
    CGRect batFrame = CGRectMake(caveFrame.origin.x + BAT_X_OFFSET, caveFrame.origin.y + BAT_Y_OFFSET, batSize, batSize);
    
    
    //init model
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:@"Level_1" ofType:@"txt"];
    _model = [[GameModel alloc] initWithBatFrame:batFrame caveFrame:caveFrame filePath:levelFilePath];
    
    
    //set root view background color
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:178.0/255.0 blue:102.0/255.0 alpha:1.0];
    
    //create cave layer and add to root layer
    CALayer *caveLayer = [CALayer layer];
    caveLayer.frame = caveLayerFrame;
    caveLayer.borderWidth = CAVE_BORDER_WIDTH;
    caveLayer.borderColor = [UIColor blackColor].CGColor;
    caveLayer.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:76.0/255.0 blue:0.0 alpha:1.0].CGColor;
    [self.view.layer addSublayer:caveLayer];
    
    //create bat view and add to root view
    _batView = [[BatView alloc] initWithFrame:batFrame];
    [self.view addSubview:_batView];
    
    //init finish line view and layer
    _finishLineView = [[UIView alloc] initWithFrame:CGRectMake(_model.finishLine, caveFrame.origin.y, 4.0, caveFrame.size.height)];
    _finishLineView.layer.borderWidth = 4.0;
    _finishLineView.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:_finishLineView];
    
    //init stalagmite views
    _stalagmiteViews = [[NSMutableArray alloc] initWithCapacity:_model.numStalagmite];
    
    
    //init and add hold button
    _holdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _holdButton.frame = self.view.bounds;
    [_holdButton addTarget:self action:@selector(fingerDown) forControlEvents:UIControlEventTouchDown];
    [_holdButton addTarget:self action:@selector(fingerUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_holdButton];
    
    
    //start update timer
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL target:self selector:@selector(update) userInfo:Nil repeats:NO];
}

-(void)fingerDown{
    [_model setIsDiving:YES];
    [_batView setIsDiving:YES];
}

-(void)fingerUp{
    [_model setIsDiving:NO];
    [_batView setIsDiving:NO];
}

-(void)breakDownUI{
    [_updateTimer invalidate];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

-(void)update{
    //get start time
    CFTimeInterval startTime = CACurrentMediaTime();
    
    
    //check for game over
    if (_model.state == GAME_OVER || _model.state == LEVEL_COMPLETE) {
        [self breakDownUI];
        [self startNewGame];
        return;
    }
    
    
    //remove characters
    for (int i = 0; i < _stalagmiteViews.count; i++) {
        UIView *stalagmiteView = _stalagmiteViews[i];
        
        if (stalagmiteView.frame.origin.x + stalagmiteView.frame.size.width < _model.caveFrame.origin.x) {
            [stalagmiteView removeFromSuperview];
            [_stalagmiteViews removeObjectAtIndex:i--];
        }
    }
    [_model removeCharacters];
    
    //add new characters
    [_model addNewCharacters];
    for (int i = (int)_stalagmiteViews.count; i < (int)_model.stalagmite.count; i++) {
        GameObjectModel *stalagmiteObject = _model.stalagmite[i];
        
        UIView *stalagmiteView = [[UIView alloc] initWithFrame:stalagmiteObject.frame];
        stalagmiteView.layer.borderWidth = 2.0;
        stalagmiteView.layer.borderColor = [UIColor blackColor].CGColor;
        stalagmiteView.layer.backgroundColor = [UIColor colorWithRed:1.0 green:178.0/255.0 blue:102.0/255.0 alpha:1.0].CGColor;
        [self.view addSubview:stalagmiteView];
        
        [_stalagmiteViews addObject:stalagmiteView];
    }
    
    //bring hold button in front of new views
    [self.view bringSubviewToFront:_holdButton];
    
    
    //update model
    [_model update];

    
    //update bat
    CGFloat angle = (_model.bat.velocity.y / TERMINAL_Y_VELOCITY)*3.14/8.0;
    [_batView setAngle:angle];
    
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
        _finishLineView.frame = CGRectMake(_model.finishLine, _model.caveFrame.origin.y, 4.0, _model.caveFrame.size.height);
    }completion:NULL];

    
    //get elapsed time
    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
    
    //start update timer
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:(UPDATE_TIME_INTERVAL - elapsedTime) target:self selector:@selector(update) userInfo:Nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
