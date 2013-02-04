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
    NSArray *date = [[NSArray alloc]initWithObjects:@"haha",@"haha", nil];
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
    cell.packageNameLabel.text = @"Apparel and shoes";
    cell.packageTotalSubjectCountLabel.text = @"200";
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    return cell;
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    //judge locked status
    //-(FMResultSet *) getPackageGroups:(NSString *)pkgname give level controller pkgname
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZLevelViewController * levelViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZLevelViewController"];
    [self.navigationController pushViewController:levelViewController animated:NO];
}
@end
