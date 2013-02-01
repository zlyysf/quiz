//
//  LZLevelViewController.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZLevelViewController.h"
#import "LZGamingViewController.h"
#import "LevelCell.h"
@interface LZLevelViewController ()<LevelCellDelegate>

@end

@implementation LZLevelViewController
@synthesize listView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topNavView.topNavType = TopNavTypeNormal;
    [self.view addSubview:self.listView];
	// Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelCell *cell = (LevelCell *)[tableView dequeueReusableCellWithIdentifier:@"LevelCell"];
    //[cell.selectButton setTitle:[NSString stringWithFormat:@"level %d",indexPath.row+1] forState:UIControlStateNormal];
    cell.delegate = self;
    cell.levelNameLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.levelCellIndexPath = indexPath;
    int num = rand()%10+1;
    cell.levelScoreLabel.text = [NSString stringWithFormat:@"Score : %d",num*100];
    cell.levelProgressLabel.text = [NSString stringWithFormat:@"%d / 10",num];
    return cell;
}
#pragma -mark Level Cell Delegate
- (void)selectedLevel:(NSIndexPath *)cellIndexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZGamingViewController * gamingViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZGamingViewController"];
    [self.navigationController pushViewController:gamingViewController animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
