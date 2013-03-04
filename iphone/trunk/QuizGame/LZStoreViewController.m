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
//#import <StoreKit/StoreKit.h>
#import "SHKFacebook.h"
#import "SHKTwitter.h"
@interface LZStoreViewController ()<LZCellDelegate>
{
    NSNumberFormatter * _priceFormatter;
}
@property (nonatomic,readwrite)BOOL hasQueryData;
@property (nonatomic,strong)NSArray *freebieItemArray;
@property (nonatomic,strong)NSArray *storeItemArray;

@end

@implementation LZStoreViewController
@synthesize listView;
@synthesize hasQueryData;
@synthesize freebieItemArray;
@synthesize storeItemArray;
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
    freebieItemArray = [[NSArray alloc]initWithObjects:@"Twitter",@"Facebook",@"Review our app", nil];
    hasQueryData = NO;
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];

	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[LZIAPManager sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.storeItemArray = products;
            hasQueryData = YES;
            [self.listView reloadData];
        }
    }];

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
    if (hasQueryData)
    {
        if (section == 0)
            return [self.storeItemArray count];
        else if (section == 2)
            return [self.freebieItemArray count];
        return 1;

    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        StorePurchaseCell *cell = (StorePurchaseCell *)[tableView dequeueReusableCellWithIdentifier:@"StorePurchaseCell"];
        SKProduct * product = (SKProduct *)[storeItemArray objectAtIndex:indexPath.row];
        cell.productNameLabel.text = product.localizedTitle;
        [_priceFormatter setLocale:product.priceLocale];
        cell.productPriceLabel.text = [_priceFormatter stringFromNumber:product.price];
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        if ([self hasProductPurchased:product.productIdentifier])
        {
            [cell.selectButton setEnabled:NO];
        }
        else
        {
            [cell.selectButton setEnabled:YES];
        }
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
        cell.descriptionLabel.text = @"Tell your friends.";
        cell.profitLabel.text = [freebieItemArray objectAtIndex:indexPath.row];
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
- (BOOL)hasProductPurchased:(NSString *)productIdentifier {
    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
    return productPurchased;
}

#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    NSLog(@"select store cell section %d  row %d",LZCellIndexPath.section,LZCellIndexPath.row);
    /*1 user purchased remove ads
     */
    if (LZCellIndexPath.section == 0)
    {
        SKProduct *product = [storeItemArray objectAtIndex:LZCellIndexPath.row];
        [[LZIAPManager sharedInstance]buyProduct:product];
    }
    else if(LZCellIndexPath.section == 2)
    {
        /* social share @"Twitter",@"Facebook",@"Review our app" */
        if ([[freebieItemArray objectAtIndex:LZCellIndexPath.row] isEqualToString:@"Facebook"])
        {
            NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"http://www.apple.com" ];
            SHKItem *item = [SHKItem URL:ourAppUrl title:@"com to join Quiz Awsome and have fun" contentType:SHKURLContentTypeUndefined];
            [SHKFacebook shareItem:item];
            
        }
        else if ([[freebieItemArray objectAtIndex:LZCellIndexPath.row] isEqualToString:@"Twitter"])
        {
            NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"http://www.apple.com" ];
            SHKItem *item = [SHKItem URL:ourAppUrl title:@"com to join Quiz Awsome and have fun" contentType:SHKURLContentTypeUndefined];
            [SHKTwitter shareItem:item];
        }
        else if ([[freebieItemArray objectAtIndex:LZCellIndexPath.row] isEqualToString:@"Review our app"])
        {
            NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"http://www.apple.com" ];
            [[UIApplication sharedApplication] openURL:ourAppUrl];

        }

    }
    else if(LZCellIndexPath.section == 3)
    {
        [[LZIAPManager sharedInstance] restoreCompletedTransactions];
    }

  }
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    
    [self resizeContentViewFrame:self.listView];
    [self refreshGold];
    [self.listView reloadData];
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
