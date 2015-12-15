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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"txt"];
    
    //load file and spereate into lines
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    _lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Select a Level";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *line = _lines[indexPath.row];
    NSArray *words = [line componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:levelName];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:levelName forIndexPath:indexPath];
    cell.textLabel.text = levelName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *line = _lines[indexPath.row];
    NSArray *words = [line componentsSeparatedByString:@" "];
    NSString *levelName = words[0];
    
    GameViewController *gameViewController = [[GameViewController alloc] initWithLevelName:levelName];
    
    // Push the view controller.
    [self.navigationController pushViewController:gameViewController animated:YES];
}



@end
