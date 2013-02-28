//
//  LZStoreViewController.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZStoreViewController.h"
#import "StorePurchaseCell.h"
#import "RestorePurchaseCell.h"
#import "StoreFreeCell.h"
#import "LZIAPManager.h"
#import <StoreKit/StoreKit.h>
@interface LZStoreViewController ()<LZCellDelegate>

@end

@implementation LZStoreViewController
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
    [self.view addSubview:listView];
    [self resizeContentViewFrame:self.listView];
    self.topNavView.topNavType = TopNavTypeStore;
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 44;
    }
    return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0)
        return 6;
    else if (section == 2)
        return 3;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        StorePurchaseCell *cell = (StorePurchaseCell *)[tableView dequeueReusableCellWithIdentifier:@"StorePurchaseCell"];
        cell.productNameLabel.text = @"No Ads";
        cell.productPriceLabel.text = @"$ 0.99";
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StoreSeparateCell"];
        return cell;

    }
    else if (indexPath.section == 2)
    {
        
        StoreFreeCell *cell = (StoreFreeCell *)[tableView dequeueReusableCellWithIdentifier:@"StoreFreeCell"];
        [cell.iconImageView setImage:[UIImage imageNamed:@"facebook.png"]];
        cell.descriptionLabel.text = @"Tell your facebook friends.";
        cell.profitLabel.text = @"Get 50 Tokens.";
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        return cell;

    }
    else
    {
        RestorePurchaseCell *cell = (RestorePurchaseCell *)[tableView dequeueReusableCellWithIdentifier:@"RestorePurchaseCell"];
        [cell.selectButton setTitle:@"Restore purchase" forState:UIControlStateNormal];
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    NSLog(@"select store cell section %d  row %d",LZCellIndexPath.section,LZCellIndexPath.row);
    /*1 user purchased remove ads
     */
    
    /*2 user purchased unlock package
     */
    
    /*3 user purchased some tokens
     */

  }
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    /*1 user purchased remove ads
     */

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LZAdsOff"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[GADMasterViewController singleton]removeAds];
    [self resizeContentViewFrame:self.listView];

    /*2 user purchased unlock package
     */
    
    /*3 user purchased some tokens
     */
    
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
