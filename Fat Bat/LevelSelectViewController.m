//
//  LevelSelectViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelSelectViewController.h"

@implementation LevelSelectViewController

-(id)initWithAudioHandler:(AudioHandler *)audioHandler{
    self = [super init];
    if (self) {
        _audioHandler = audioHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    
    
    //get screen size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    //configure table view
    self.tableView.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = (int)(screenSize.height - self.navigationController.navigationBar.bounds.size.height)/8;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //show navigation bar and set title
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Pick a Cavern";
    
    //set title font
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:FONT_NAME size:TABLE_TITLE_FONT_SIZE], NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    
    //play music if not doing so
    if ( !_audioHandler.backgroundMusicPlaying) {
        //play music
        [_audioHandler setMusicURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio/fatbat_title_song" ofType:@"caf"]]];
        [_audioHandler tryPlayMusic];
    }
    
    
    //get lines from level file
    NSString *string = [LevelFileHandler levelsFile];
    _lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //reload table's data
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //one section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lines.count; //one row for each level
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //seperate line into words
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    
    //check for correct number of arguments on line
    if (words.count != 2) {
        NSLog(@"levels file has the wrong number of arguments on line %ld", (long)indexPath.row);
        exit(1);
    }
    
    
    //get level name from first argument
    NSString *levelName = words[0];

    //load level file and spereate into lines
    NSString *levelFile = [LevelFileHandler levelWithName:levelName];
    NSArray *lines = [LevelFileHandler getLinesFromLevelFile:levelFile];
    
    //check there is at least 2 lines
    if (lines.count < 3) {
        NSLog(@"too few lines in level file named %@", levelName);
    }
    
    
    //get color values from line 2
    NSArray *rgbValues = [lines[1] componentsSeparatedByString:@" "];
    
    //check there are 3 arguments
    if (rgbValues.count != 3) {
        NSLog(@"wrong number of arguements on line 2 in level file names %@", levelName);
    }
    
    //get level color from rgb values
    UIColor *levelColor = [UIColor colorWithRed:[rgbValues[0] floatValue]/255.0 green:[rgbValues[1] floatValue]/255.0 blue:[rgbValues[2] floatValue]/255.0 alpha:1.0];
    
    
    //get screen size and yscale
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat yScale = screenSize.height / IPHONE_6S_SCREEN_HEIGHT;
    
    
    //create table cell
    static NSString *CellIdentifier = @"levelCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    
    //configure table cell
    cell.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //add level title to cell
    levelName = [levelName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    CGRect levelTitleFrame = CGRectMake(0.0, -self.tableView.rowHeight/4.0, screenSize.width*4.0/5.0, self.tableView.rowHeight + self.tableView.rowHeight/4.0);
    TitleView *levelTitle = [[TitleView alloc] initWithFrame:levelTitleFrame text:levelName font:[UIFont fontWithName:FONT_NAME size:FONT_SIZE*yScale] color:levelColor borderWidth:BORDER_WIDTH*yScale/2.0];
    [cell addSubview:levelTitle];
    
    
    //add check mark if level complete
    if ([words[1] isEqualToString:@"YES"]) {
        ShapeMarkerView *checkMark = [[ShapeMarkerView alloc] initWithFrame:CGRectMake((screenSize.width*4.0/5.0) - cell.bounds.size.height/2.0, -1.0, self.tableView.rowHeight, self.tableView.rowHeight) shape:CHECK_MARK borderWidth:BORDER_WIDTH*yScale/2.0];
        [cell addSubview:checkMark];
    }
    
    //add divider view excepet on last cell
    if(indexPath.row < _lines.count - 1){
        UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width/32.0, self.tableView.rowHeight - 1.0, screenSize.width*15.0/16.0, 1.0)];
        dividerView.backgroundColor = [UIColor blackColor];
        [cell addSubview:dividerView];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get selected cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //get screen size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    
    //add selection view
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, self.tableView.rowHeight)];
    _selectionView.backgroundColor = [UIColor colorWithRed:UI_SELECT_RED green:UI_SELECT_GREEN blue:UI_SELECT_BLUE alpha:1.0];
    [cell addSubview:_selectionView];
    [cell sendSubviewToBack:_selectionView];
    
    
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    
    //check for correct number of arguments on line
    if (words.count != 2) {
        NSLog(@"levels file has the wrong number of arguments on line %ld", (long)indexPath.row);
        exit(1);
    }
    
    //stop music
    [_audioHandler stopMusic];
    
    //get level name
    NSString *levelName = words[0];
    
    // Push game view controller with level name
    [self.navigationController pushViewController:[[GameViewController alloc] initWithLevelName:levelName audioHandler:_audioHandler] animated:YES];
}

@end
