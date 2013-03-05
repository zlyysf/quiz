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
#import "LZTapjoyHelper.h"

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
    [self resizeContentViewFrame:self.listView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//** -(FMResultSet *) getPackages; getpackageArray list view update also set top bar gold amount
    NSArray *date = [[LZDataAccess singleton]getPackages]; ;
    self.packageArray = date;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
    
    [[LZTapjoyHelper singleton] showFullScreenAd];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[LZTapjoyHelper singleton] showFullScreenAd];
}
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    [self resizeContentViewFrame:self.listView];
    [self refreshGold];
    NSArray *date = [[LZDataAccess singleton]getPackages]; ;
    self.packageArray = date;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.packageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageCell *cell = (PackageCell *)[tableView dequeueReusableCellWithIdentifier:@"PackageCell"];
    //name, seq, locked, userTotalScore, quizCount, groupCount, passedGroupCount
    NSDictionary *package = [self.packageArray objectAtIndex:indexPath.row];
    int lockstate = [[package objectForKey:@"locked"]integerValue];
    if (lockstate == 1)
    {
        [cell setLocked:YES];
    }
    else
    {
        [cell setLocked:NO];
    }
    cell.packageNameLabel.text = [package objectForKey:@"name"];
    int scoreSum = [[package objectForKey:@"scoreSum"] integerValue];
    cell.packageTotalScoreLabel.text = [NSString stringWithFormat:@"%d",scoreSum];
    int passedGroupCount = [[package objectForKey:@"passedGroupCount"] integerValue];
    int groupCount = [[package objectForKey:@"groupCount"] integerValue];
    cell.packageProgressLabel.text = [NSString stringWithFormat:@"%d/%d",passedGroupCount,groupCount];
    UIImage *image = [UIImage imageNamed:@"auto.png"];
    UIImage *backImage = [image stretchableImageWithLeftCapWidth:25.0 topCapHeight:25.0];

    [cell.selectButton setBackgroundImage:backImage forState:UIControlStateNormal];
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    return cell;
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    //judge locked status
    //-(FMResultSet *) getPackageGroups:(NSString *)pkgname give level controller pkgname
    NSDictionary *package = [self.packageArray objectAtIndex:LZCellIndexPath.row];
    int lockstate = [[package objectForKey:@"locked"]integerValue];
    if (lockstate == 1)
    {
        //[cell setLocked:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You should pass the pre-package to unlock this package" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //NSDictionary *package = [self.packageArray objectAtIndex:LZCellIndexPath.row];
        NSString *packageName = [package objectForKey:@"name"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LZLevelViewController * levelViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZLevelViewController"];
        levelViewController.currentPackageName = packageName;
        [self.navigationController pushViewController:levelViewController animated:NO];

    }

}
@end
