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
@synthesize currentPackageName;
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
    NSArray *data = [[LZDataAccess singleton]getPackageGroups:self.currentPackageName];;
    self.levelArray = data;
    NSLog(@"level %@",self.levelArray);
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
    NSDictionary *group = [self.levelArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.levelNameLabel.text = [group objectForKey:@"name"];
    cell.cellIndexPath = indexPath;
    int lockstate = [[group objectForKey:@"locked"]integerValue];
    if (lockstate == 1)
    {
        [cell setLocked:YES];
    }
    else
    {
        [cell setLocked:NO];
    }
    int gotScoreSum = [[group objectForKey:@"gotScoreSum"] integerValue];

    int answerRightMax = [[group objectForKey:@"answerRightMax"] integerValue];
        int quizCount = [[group objectForKey:@"quizCount"] integerValue];
    cell.levelScoreLabel.text = [NSString stringWithFormat:@"%d",gotScoreSum];
    cell.levelProgressLabel.text = [NSString stringWithFormat:@"%d / %d",answerRightMax,quizCount];
    return cell;
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    //judge locked status
    //-(FMResultSet *) getGroupQuiz:(NSString *)grpkey; give gaming controller grpkey
    NSDictionary *group = [self.levelArray objectAtIndex:LZCellIndexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NSString *groupKey = [group objectForKey:@"grpkey"];
    NSString *packageKey = [group objectForKey:@"pkgkey"];
    LZGamingViewController * gamingViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZGamingViewController"];
    gamingViewController.currentGroupKey = groupKey;
    gamingViewController.currentPackageKey = packageKey;
    [self.navigationController pushViewController:gamingViewController animated:NO];
}
@end
