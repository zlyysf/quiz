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
#import "LZFacebookShare.h"
#import "LZTwitterShare.h"
#define kReviewAppBonusKey @"LZReviewAppBonus"
#define kFreebieBonusDelta 20
#include "MBProgressHUD.h"
#import "LZUtility.h"
@interface LZStoreViewController ()<LZCellDelegate>
{
    NSNumberFormatter * _priceFormatter;
}
@property (nonatomic,readwrite)BOOL hasQueryData;
@property (nonatomic,strong)NSArray *freebieItemArray;
@property (nonatomic,strong)NSArray *storeItemArray;
@property (nonatomic,strong)NSMutableDictionary *currentShareInfo;
@property (nonatomic,strong)NSSet *consumbleItemSet;
@end

@implementation LZStoreViewController
@synthesize listView;
@synthesize hasQueryData;
@synthesize freebieItemArray;
@synthesize storeItemArray;
@synthesize currentShareInfo;
@synthesize consumbleItemSet;
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
    [self.view bringSubviewToFront:self.listView];
    //[self resizeContentViewFrame:self.listView];
    self.topNavView.topNavType = TopNavTypeStore;
    freebieItemArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"Facebook", @""),NSLocalizedString(@"Twitter", @""),NSLocalizedString(@"Review our app", @""), nil];
    hasQueryData = NO;
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
    consumbleItemSet = [NSSet setWithObjects:
                        @"com.lingzhi.QuizAwsome.buytoken40",
                        @"com.lingzhi.QuizAwsome.buytoken100",
                        @"com.lingzhi.QuizAwsome.buytoken200",
                        @"com.lingzhi.QuizAwsome.buytoken400",
                        nil];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resizeContentViewFrame:self.listView];
    [[LZIAPManager sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            if([products count]!=0)
            {
                self.storeItemArray = products;
                hasQueryData = YES;
                [self.listView reloadData];
            }
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterShareDidSend:) name:LZShareTwitterDidSendNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookShareDidSend:) name:LZShareFacebookDidSendNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [MBProgressHUD hideAllHUDsForView:self.listView animated:YES];
    [[LZIAPManager sharedInstance]cancelQueryProducts];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:LZShareTwitterDidSendNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:LZShareFacebookDidSendNotification object:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 54;
    }
    return 70;
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
        
        [_priceFormatter setLocale:product.priceLocale];
        BOOL showDiamondIcon = [consumbleItemSet containsObject:product.productIdentifier];
        if (showDiamondIcon) {
            cell.productNameLabel.text = [product.localizedTitle substringToIndex:3];
        }
        else
        {
            cell.productNameLabel.text = product.localizedTitle;
        }
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        cell.diamondIcon.hidden = !showDiamondIcon;
        if ([self hasProductPurchased:product.productIdentifier])
        {
            [cell.selectButton setEnabled:NO];
            cell.productPriceLabel.hidden = YES;
            cell.checkmarkImage.hidden = NO;
        }
        else
        {
            [cell.selectButton setEnabled:YES];
            cell.checkmarkImage.hidden = YES;
            cell.productPriceLabel.hidden = NO;
            cell.productPriceLabel.text = [_priceFormatter stringFromNumber:product.price];
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
        if ([[freebieItemArray objectAtIndex:indexPath.row] isEqualToString:NSLocalizedString(@"Facebook", @"")])
        {
            cell.profitLabel.text = NSLocalizedString(@"Tell your facebook friends", @"");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"facebook@2x" ofType:@"png"];
            [cell.iconImageView setImage:[UIImage imageWithContentsOfFile:path]];
//            if ([[NSUserDefaults standardUserDefaults]boolForKey:kFacebookBonusKey])
//            {
//                [cell.selectButton setEnabled:NO];
//            }
//            else
//            {
//                [cell.selectButton setEnabled:YES];
//            }
        }
        else if ([[freebieItemArray objectAtIndex:indexPath.row] isEqualToString:NSLocalizedString(@"Twitter", @"")])
        {
            cell.profitLabel.text = NSLocalizedString(@"Tell your twitter followers", @"");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"twitter@2x" ofType:@"png"];
            [cell.iconImageView setImage:[UIImage imageWithContentsOfFile:path]];
//            if ([[NSUserDefaults standardUserDefaults]boolForKey:kTwitterBonusKey])
//            {
//                [cell.selectButton setEnabled:NO];
//            }
//            else
//            {
//                [cell.selectButton setEnabled:YES];
//            }

        }
        else if ([[freebieItemArray objectAtIndex:indexPath.row] isEqualToString:NSLocalizedString(@"Review our app", @"")])
        {
            cell.profitLabel.text = NSLocalizedString(@"Review our app", @"");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"review@2x" ofType:@"png"];
            [cell.iconImageView setImage:[UIImage imageWithContentsOfFile:path]];
//            if ([[NSUserDefaults standardUserDefaults]boolForKey:kReviewAppBonusKey])
//            {
//                [cell.selectButton setEnabled:NO];
//            }
//            else
//            {
//                [cell.selectButton setEnabled:YES];
//            }
        }

        cell.descriptionLabel.text = @"20";
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        return cell;

    }
    else
    {
        RestorePurchaseCell *cell = (RestorePurchaseCell *)[tableView dequeueReusableCellWithIdentifier:@"RestorePurchaseCell"];
        [cell.selectButton setTitle:NSLocalizedString(@"Restore purchase", @"") forState:UIControlStateNormal];
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
        if ([[freebieItemArray objectAtIndex:LZCellIndexPath.row] isEqualToString:NSLocalizedString(@"Facebook", @"")])
        {
             if ([LZUtility isFacebookAvailable])
             {
                 [[LZFacebookShare sharedInstance]share];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Can Not Send", @"") message:NSLocalizedString(@"You can add or create a Facebook account in Settings and try again.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
                 [alert show];
             }

        }
        else if ([[freebieItemArray objectAtIndex:LZCellIndexPath.row] isEqualToString:NSLocalizedString(@"Twitter", @"")])
        {
            if ([LZUtility isTwitterAvailable])
            {
                [[LZTwitterShare sharedInstance]share];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Can Not Send", @"") message:NSLocalizedString(@"You can add or create a Twitter account in Settings and try again.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
                [alert show];
            }

        }
        else if ([[freebieItemArray objectAtIndex:LZCellIndexPath.row] isEqualToString:NSLocalizedString(@"Review our app", @"")])
        {
            NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"https://itunes.apple.com/app/id611092526" ];
            [[UIApplication sharedApplication] openURL:ourAppUrl];
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kReviewAppBonusKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            [[LZDataAccess singleton]updateUserTotalCoinByDelta:kFreebieBonusDelta];
//            NSArray *reloadCellIndex = [NSArray arrayWithObject:LZCellIndexPath];
//            [self.listView reloadRowsAtIndexPaths:reloadCellIndex withRowAnimation:UITableViewRowAnimationNone];
//            [self refreshGold];
        }

    }
    else if(LZCellIndexPath.section == 3)
    {
        [[LZIAPManager sharedInstance] restoreCompletedTransactions];
        //[[LZIAPManager sharedInstance]testBuyProduct:@"com.lingzhi.QuizAwsome.removeads"];
    }
    /*    @"com.lingzhi.QuizAwsome.removeads",
     @"com.lingzhi.QuizAwsome.unlockallpackages",
     @"com.lingzhi.QuizAwsome.unlockfortune",
     @"com.lingzhi.QuizAwsome.unlockhealth",
     @"com.lingzhi.QuizAwsome.unlockelectronic",
     @"com.lingzhi.QuizAwsome.unlocksportsclub",
     @"com.lingzhi.QuizAwsome.unlockfooddrink",
     @"com.lingzhi.QuizAwsome.buytoken40",
     @"com.lingzhi.QuizAwsome.buytoken100",
     @"com.lingzhi.QuizAwsome.buytoken200",
     @"com.lingzhi.QuizAwsome.buytoken400",
     */

  }
//- (void)twitterShareDidSend:(NSNotification *)notification
//{
//    for (NSString *freebie in freebieItemArray)
//    {
//        if ([freebie isEqualToString:NSLocalizedString(@"Twitter", @"")])
//        {
//            int index = [freebieItemArray indexOfObject:freebie];
//            NSIndexPath *reloadCellIndex = [NSIndexPath indexPathForRow:index inSection:2];
//            NSArray *reloadCell = [NSArray arrayWithObject:reloadCellIndex];
//            [self.listView reloadRowsAtIndexPaths:reloadCell withRowAnimation:UITableViewRowAnimationNone];
//            [self refreshGold];
//        }
//    }
//}
//- (void)facebookShareDidSend:(NSNotification *)notification
//{
//    for (NSString *freebie in freebieItemArray)
//    {
//        if ([freebie isEqualToString:NSLocalizedString(@"Facebook", @"")])
//        {
//            int index = [freebieItemArray indexOfObject:freebie];
//            NSIndexPath *reloadCellIndex = [NSIndexPath indexPathForRow:index inSection:2];
//            NSArray *reloadCell = [NSArray arrayWithObject:reloadCellIndex];
//            [self.listView reloadRowsAtIndexPaths:reloadCell withRowAnimation:UITableViewRowAnimationNone];
//            [self refreshGold];
//        }
//    }
//
//}
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
