//
//  LZPackageViewController.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZPackageViewController.h"
#import "LZLevelViewController.h"
#import "PackageCell.h"
#import "LZDataAccess.h"
@interface LZPackageViewController ()<LZCellDelegate>
@property (nonatomic,strong)NSArray *packageArray;
@end

@implementation LZPackageViewController
@synthesize listView;
@synthesize packageArray = _packageArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setPackageArray:(NSArray *)packageArray
{
    if(packageArray != nil)
    {
        _packageArray = packageArray;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//** -(FMResultSet *) getPackages; getpackageArray list view update also set top bar gold amount
    NSArray *date = [[LZDataAccess singleton]getPackages]; ;
    self.packageArray = date;
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
    return [self.packageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageCell *cell = (PackageCell *)[tableView dequeueReusableCellWithIdentifier:@"PackageCell"];
    //name, seq, locked, userTotalScore, quizCount, groupCount, passedGroupCount
    NSDictionary *package = [self.packageArray objectAtIndex:indexPath.row];
    
    cell.packageNameLabel.text = [package objectForKey:@"name"];
    int quizCount = [[package objectForKey:@"quizCount"] integerValue];
    cell.packageTotalSubjectCountLabel.text = [NSString stringWithFormat:@"%d",quizCount];
    int passedGroupCount = [[package objectForKey:@"passedGroupCount"] integerValue];
    int groupCount = [[package objectForKey:@"groupCount"] integerValue];
    cell.packageProgressLabel.text = [NSString stringWithFormat:@"%d / %d",passedGroupCount,groupCount];
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    cell.packageTotalScoreLabel.text = @"package total score";
    return cell;
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    //judge locked status
    //-(FMResultSet *) getPackageGroups:(NSString *)pkgname give level controller pkgname
    NSDictionary *package = [self.packageArray objectAtIndex:LZCellIndexPath.row];
    NSString *packageName = [package objectForKey:@"name"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZLevelViewController * levelViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZLevelViewController"];
    levelViewController.currentPackageName = packageName;
    [self.navigationController pushViewController:levelViewController animated:NO];
}
@end
