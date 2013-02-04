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
@interface LZLevelViewController ()<LZCellDelegate>
@property(nonatomic,strong)NSArray *levelArray;
@end

@implementation LZLevelViewController
@synthesize listView;
@synthesize levelArray = _levelArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setLevelArray:(NSArray *)levelArray
{
    if(levelArray != nil)
    {
        _levelArray = levelArray;
        [self.listView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topNavView.topNavType = TopNavTypeNormal;
    [self.view addSubview:self.listView];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//** -(FMResultSet *) getPackageGroups:(NSString *)pkgname; getpackageArray list view update also set top bar gold amount
    NSArray *date = [[NSArray alloc]initWithObjects:@"haha",@"haha", nil];
    self.levelArray = date;
    NSString *goldAmount = @"1000";
    self.topNavView.goldCountLabel.text = goldAmount;
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

#pragma -mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.levelArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelCell *cell = (LevelCell *)[tableView dequeueReusableCellWithIdentifier:@"LevelCell"];
    //name, seqInPkg, locked, passed, gotScoreSum, quizCount
    cell.delegate = self;
    cell.levelNameLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.cellIndexPath = indexPath;
    int num = rand()%10+1;
    cell.levelScoreLabel.text = [NSString stringWithFormat:@"Score : %d",num*100];
    cell.levelProgressLabel.text = [NSString stringWithFormat:@"%d / 10",num];
    return cell;
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    //judge locked status
    //-(FMResultSet *) getGroupQuiz:(NSString *)grpkey; give gaming controller grpkey
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZGamingViewController * gamingViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZGamingViewController"];
    [self.navigationController pushViewController:gamingViewController animated:NO];
}
@end
