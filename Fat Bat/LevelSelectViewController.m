//
//  LevelSelectViewController.m
//  Fat Bat
//
//  Created by Wil Pirino on 12/15/15.
//  Copyright © 2015 Wil Pirino. All rights reserved.
//

#import "LevelSelectViewController.h"

@implementation LevelSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set bg color
    self.view.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    
    //configure table view
    self.tableView.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //configure navigation bar back button
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //init a cover-up layer to go over the navigation bar
    CGRect navigationFrame = self.navigationController.navigationBar.layer.frame;
    CALayer *coverUpLayer = [CALayer layer];
    coverUpLayer.frame = CGRectMake(-BORDER_WIDTH, -BORDER_WIDTH, navigationFrame.size.width + BORDER_WIDTH*2.0, navigationFrame.size.height + BORDER_WIDTH);
    coverUpLayer.borderWidth = BORDER_WIDTH;
    coverUpLayer.borderColor = [UIColor blackColor].CGColor;
    coverUpLayer.backgroundColor = [UIColor colorWithRed:UI_1_RED green:UI_1_GREEN blue:UI_1_BLUE alpha:1.0].CGColor;
    
    //add layer
    [self.navigationController.navigationBar.layer addSublayer:coverUpLayer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //get lines frim level file
    NSString *string = [LevelFileHandler levelsFile];
    _lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //reload table's data
    [self.tableView reloadData];
    
    //show navigation bar and set title
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Select a Level";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //one section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lines.count; //one row for each level
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _lines.count) {return nil;}
    
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    

    //load level file and spereate into lines
    NSString *string = [LevelFileHandler levelWithName:levelName];
    NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //get color from line 2
    NSArray *rgbValues = [lines[1] componentsSeparatedByString:@" "];
    UIColor *levelColor = [UIColor colorWithRed:[rgbValues[0] floatValue]/255.0 green:[rgbValues[1] floatValue]/255.0 blue:[rgbValues[2] floatValue]/255.0 alpha:1.0];
    
    
    //create table cell and set text to level name
    static NSString *CellIdentifier = @"levelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:UI_2_RED green:UI_2_GREEN blue:UI_2_BLUE alpha:1.0];
    cell.textLabel.textColor = levelColor;
    cell.textLabel.text = [levelName stringByReplacingOccurrencesOfString:@"_" withString:@" "];;
    cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    
    //set detail text based on completion status
    cell.detailTextLabel.font = [UIFont fontWithName:FONT_NAME size:DETAIL_FONT_SIZE];
    if ([words[1] isEqualToString:@"NO"]) {
        cell.detailTextLabel.text = @"~Incomplete";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }else{
        cell.detailTextLabel.text = @"~Completed";
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    
    //init game controller
    GameViewController *gameViewController = [[GameViewController alloc] initWithLevelName:levelName];
    
    // Push the view controller
    [self.navigationController pushViewController:gameViewController animated:YES];
}



@end
