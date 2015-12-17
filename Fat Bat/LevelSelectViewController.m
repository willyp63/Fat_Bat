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
    
    //configure table view
    self.tableView.backgroundColor = [UIColor colorWithRed:OUTER_CAVE_RED green:OUTER_CAVE_GREEN blue:OUTER_CAVE_BLUE alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //configure navigation bar back button
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //init a cover-up layer to go over the navigation bar
    CGRect navigationFrame = self.navigationController.navigationBar.layer.frame;
    CALayer *coverUpLayer = [CALayer layer];
    coverUpLayer.frame = CGRectMake(-BORDER_WIDTH, -BORDER_WIDTH, navigationFrame.size.width + BORDER_WIDTH*2.0, navigationFrame.size.height + BORDER_WIDTH);
    coverUpLayer.borderWidth = BORDER_WIDTH;
    coverUpLayer.borderColor = [UIColor blackColor].CGColor;
    coverUpLayer.backgroundColor = [UIColor colorWithRed:INNER_CAVE_RED green:INNER_CAVE_GREEN blue:INNER_CAVE_BLUE alpha:1.0].CGColor;
    
    //add layer
    [self.navigationController.navigationBar.layer addSublayer:coverUpLayer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //get documents path
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/levels.txt"];
    
    //check if documents file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        //copy file from bundle to documents
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:LEVELS_FILE_NAME ofType:@"txt"];
        NSString *string = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
        [string writeToFile:docPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    
    //load file and get lines
    NSString *string = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
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
    //get level name
    NSArray *words = [_lines[indexPath.row] componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    
    //create table cell and set text to level name
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:levelName];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:levelName];
    cell.backgroundColor = [UIColor colorWithRed:OUTER_CAVE_RED green:OUTER_CAVE_GREEN blue:OUTER_CAVE_BLUE alpha:1.0];
    cell.textLabel.text = levelName;
    cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    
    //set detail text based on completion status
    cell.detailTextLabel.font = [UIFont fontWithName:FONT_NAME size:DETAIL_FONT_SIZE];
    if ([words[1] isEqualToString:@"NO"]) {
        cell.detailTextLabel.text = @" - Incomplete";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }else{
        cell.detailTextLabel.text = @" - Completed";
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
