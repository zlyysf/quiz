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

@interface LZPackageViewController ()<LZCellDelegate,UIAlertViewDelegate>
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
    [self.view bringSubviewToFront:self.listView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"LZPackageViewController viewWillAppear enter");
    [super viewWillAppear:animated];
    [self resizeContentViewFrame:self.listView];
//** -(FMResultSet *) getPackages; getpackageArray list view update also set top bar gold amount
    NSArray *date = [[LZDataAccess singleton]getPackages]; ;
    self.packageArray = date;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
    
    if (! [[NSUserDefaults standardUserDefaults]boolForKey:@"LZAdsOff"]){
//        [[LZTapjoyHelper singleton] showFullScreenAd];
//        //[[LZTapjoyHelper singleton]showFullScreenAdWithViewController : self];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"LZPackageViewController viewWillDisappear enter");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (! [[NSUserDefaults standardUserDefaults]boolForKey:@"LZAdsOff"]){
//        [[LZTapjoyHelper singleton] showFullScreenAd];
//        //[[LZTapjoyHelper singleton]showFullScreenAdWithViewController : self];
    }
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
    NSString *name = [package objectForKey:@"name"];
    cell.packageNameLabel.text = name;
    int scoreSum = [[package objectForKey:@"scoreSum"] integerValue];
    cell.packageTotalScoreLabel.text = [NSString stringWithFormat:@"%d",scoreSum];
    int passedGroupCount = [[package objectForKey:@"passedGroupCount"] integerValue];
    int groupCount = [[package objectForKey:@"groupCount"] integerValue];
    cell.packageProgressLabel.text = [NSString stringWithFormat:@"%d/%d",passedGroupCount,groupCount];
    NSString *packBgResouce = [NSString stringWithFormat:@"cell_%@@2x",name];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:packBgResouce ofType:@"png"]];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Package Locked", @"") message:NSLocalizedString(@"Buy this package or please pass the preceding packages to unlock it.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Buy", @""),nil];//TODO ADD CANCAL BUTTON
        alert.tag = 50;
        [alert show];//TODO let user can purchase
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
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 50)
    {
        if (buttonIndex == 1)
        {
            [self goldButtonTapped];
        }
        
    }

}
@end
