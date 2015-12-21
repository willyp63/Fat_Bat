//
//  LevelFileSelectViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/19/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelFileSelectViewController.h"

@implementation LevelFileSelectViewController{
    NSArray<NSString *> *_lines;
}

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
    
    //get lines from level file
    NSString *string = [LevelFileHandler levelsFile];
    _lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //reload table's data
    [self.tableView reloadData];
    
    //show navigation bar and set title
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Select a File";
    
    //add new bar button to navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"new" style:UIBarButtonItemStyleDone target:self action:@selector(new)];
}

-(void)new{
    //load new level file from bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:[@"levels/" stringByAppendingString:NEW_LEVEL_FILE_NAME] ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //prefix level name to levelstring
    NSString *text = [NEW_LEVEL_FILE_NAME stringByAppendingString:@"\r"];
    text = [text stringByAppendingString:string];
    
    //init game controller with level name
    LevelCreationViewController *viewController = [[LevelCreationViewController alloc] initWithText:text];
    
    // Push view controller
    [self.navigationController pushViewController:viewController animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //one section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lines.count; //one row for each level
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    
    
    //load level file and spereate into lines
    NSString *levelFile = [LevelFileHandler levelWithName:levelName];
    NSArray *lines = [LevelFileHandler getLinesFromLevelFile:levelFile];
    
    //get color from line 2
    NSArray *rgbValues = [lines[1] componentsSeparatedByString:@" "];
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
