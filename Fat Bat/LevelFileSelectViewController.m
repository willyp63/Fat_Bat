//
//  LevelFileSelectViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/19/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelFileSelectViewController.h"

@implementation LevelFileSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    
    
    //configure table view
    self.tableView.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //show navigation bar and set title
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Select a File";
    
    //add new bar button to navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"new" style:UIBarButtonItemStyleDone target:self action:@selector(new)];
    
    
    //get lines from level file
    NSString *string = [LevelFileHandler levelsFile];
    _lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //reload table's data
    [self.tableView reloadData];
}

-(void)new{
    //load new level file from bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:[@"levels/" stringByAppendingString:NEW_LEVEL_FILE_NAME] ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //prefix level name to levelstring
    NSString *text = [NEW_LEVEL_FILE_NAME stringByAppendingString:@"\r"];
    text = [text stringByAppendingString:string];
    
    
    // Push game view controller with level name
    [self.navigationController pushViewController:[[LevelCreationViewController alloc] initWithText:text] animated:YES];
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
    if (lines.count < 2) {
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
    
    
    //create table cell
    static NSString *CellIdentifier = @"levelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //configure table cell
    cell.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    cell.textLabel.textColor = levelColor;
    cell.textLabel.text = [levelName stringByReplacingOccurrencesOfString:@"_" withString:@" "];;
    cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    
    //check for correct number of arguments on line
    if (words.count != 2) {
        NSLog(@"levels file has the wrong number of arguments on line %ld", (long)indexPath.row);
        exit(1);
    }
    
    //get level name
    NSString *levelName = words[0];
    
    //load file
    NSString *levelString = [LevelFileHandler levelWithName:levelName];
    
    //prefix level name to levelstring
    NSString *text = [levelName stringByAppendingString:@"\r"];
    text = [text stringByAppendingString:levelString];
    
    //init game controller with level name
    LevelCreationViewController *viewController = [[LevelCreationViewController alloc] initWithText:text];
    
    // Push view controller
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
