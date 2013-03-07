//
//  LZIAPManager.m
//  QuizGame
//
//  Created by liu miao on 2/28/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZIAPManager.h"
//#import <StoreKit/StoreKit.h>
#import "GADMasterViewController.h"
#import "LZDataAccess.h"

#define kPackgeFortuneIndex 3
#define kPackgeHealthIndex 4
#define kPackgeElectronicIndex 5
#define kPackgeSportsclubIndex 6
#define kPackgeFooddrinkIndex 7

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
@interface LZIAPManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation LZIAPManager{
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSSet * _nonconsumbleItemSet;
    MBProgressHUD *HUD;
}
+ (LZIAPManager *)sharedInstance {
    static dispatch_once_t IAPOnce;
    static LZIAPManager * sharedInstance;
    dispatch_once(&IAPOnce, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.lingzhi.QuizAwsome.removeads",
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
                                      nil];

        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _nonconsumbleItemSet = [NSSet setWithObjects:
                             @"com.lingzhi.QuizAwsome.removeads",
                             @"com.lingzhi.QuizAwsome.unlockallpackages",
                             @"com.lingzhi.QuizAwsome.unlockfortune",
                             @"com.lingzhi.QuizAwsome.unlockhealth",
                             @"com.lingzhi.QuizAwsome.unlockelectronic",
                             @"com.lingzhi.QuizAwsome.unlocksportsclub",
                             @"com.lingzhi.QuizAwsome.unlockfooddrink",
                            nil];
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
    
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] delegate].window];
	[[[UIApplication sharedApplication] delegate].window addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Retrieving store information";
	
	[HUD show:YES];
    
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    if ([SKPaymentQueue canMakePayments])
    {
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] delegate].window];
        [[[UIApplication sharedApplication] delegate].window addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Connecting to iTunes...";
        HUD.dimBackground = YES;
        [HUD show:YES];
    }
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    [HUD hide:YES];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    [HUD hide:YES];
}
- (void)cancelQueryProducts
{
    [_productsRequest cancel];
    _productsRequest.delegate = nil;
    _productsRequest = nil;
    _completionHandler = nil;
}
#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");

    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_success.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Purchase Completed";
    [HUD hide: YES afterDelay:2.0f];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_success.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Restore Completed";
    [HUD hide: YES afterDelay:2.0f];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    NSString *text = @"Purchase Canceled";
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        text = @"Purchase Failed";
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_failed.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = text;
    [HUD hide: YES afterDelay:2.0f];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    if([_nonconsumbleItemSet containsObject:productIdentifier])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    //-(BOOL)updatePackageLockState:(NSString *)pkgkey andLocked:(int)locked;
    if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.removeads"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LZAdsOff"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[GADMasterViewController singleton]removeAds];
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.unlockallpackages"])
    {
        NSArray * packages = [[LZDataAccess singleton]getPackages];
        for (NSDictionary * package in packages)
        {
            int lockStatus = [[package objectForKey:@"locked"]integerValue];
            if (lockStatus == 1) {
                NSString *packKey = [package objectForKey:@"name"];
                [[LZDataAccess singleton]updatePackageLockState:packKey andLocked:0];
            }
        }
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.unlockfortune"])
    {
        NSArray * packages = [[LZDataAccess singleton]getPackages];
        NSDictionary * package = [packages objectAtIndex:kPackgeFortuneIndex];
        int lockStatus = [[package objectForKey:@"locked"]integerValue];
        if (lockStatus == 1) {
            NSString *packKey = [package objectForKey:@"name"];
            [[LZDataAccess singleton]updatePackageLockState:packKey andLocked:0];
        }
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.unlockhealth"])
    {
        NSArray * packages = [[LZDataAccess singleton]getPackages];
        NSDictionary * package = [packages objectAtIndex:kPackgeHealthIndex];
        int lockStatus = [[package objectForKey:@"locked"]integerValue];
        if (lockStatus == 1) {
            NSString *packKey = [package objectForKey:@"name"];
            [[LZDataAccess singleton]updatePackageLockState:packKey andLocked:0];
        }
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.unlockelectronic"])
    {
        NSArray * packages = [[LZDataAccess singleton]getPackages];
        NSDictionary * package = [packages objectAtIndex:kPackgeElectronicIndex];
        int lockStatus = [[package objectForKey:@"locked"]integerValue];
        if (lockStatus == 1) {
            NSString *packKey = [package objectForKey:@"name"];
            [[LZDataAccess singleton]updatePackageLockState:packKey andLocked:0];
        }
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.unlocksportsclub"])
    {
        NSArray * packages = [[LZDataAccess singleton]getPackages];
        NSDictionary * package = [packages objectAtIndex:kPackgeSportsclubIndex];
        int lockStatus = [[package objectForKey:@"locked"]integerValue];
        if (lockStatus == 1) {
            NSString *packKey = [package objectForKey:@"name"];
            [[LZDataAccess singleton]updatePackageLockState:packKey andLocked:0];
        }
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.unlockfooddrink"])
    {
        NSArray * packages = [[LZDataAccess singleton]getPackages];
        NSDictionary * package = [packages objectAtIndex:kPackgeFooddrinkIndex];
        int lockStatus = [[package objectForKey:@"locked"]integerValue];
        if (lockStatus == 1) {
            NSString *packKey = [package objectForKey:@"name"];
            [[LZDataAccess singleton]updatePackageLockState:packKey andLocked:0];
        }
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.buytoken40"])
    {
        [[LZDataAccess singleton]updateUserTotalCoinByDelta:40];
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.buytoken100"])
    {
        [[LZDataAccess singleton]updateUserTotalCoinByDelta:100];
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.buytoken200"])
    {
        [[LZDataAccess singleton]updateUserTotalCoinByDelta:200];
    }
    else if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.buytoken400"])
    {
        [[LZDataAccess singleton]updateUserTotalCoinByDelta:400];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}
- (void)testBuyProduct:(NSString *)productIdentifier
{
    if ([productIdentifier isEqualToString:@"com.lingzhi.QuizAwsome.removeads"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LZAdsOff"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[GADMasterViewController singleton]removeAds];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}
- (void)restoreCompletedTransactions {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] delegate].window];
    [[[UIApplication sharedApplication] delegate].window addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    HUD.labelText = @"Connecting to iTunes...";
    [HUD show:YES];

}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}


@end
