//
//  LZIAPManager.h
//  QuizGame
//
//  Created by liu miao on 2/28/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
@interface LZIAPManager : NSObject<MBProgressHUDDelegate>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
+ (LZIAPManager *)sharedInstance;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (void)restoreCompletedTransactions;
- (void)testBuyProduct:(NSString *)productIdentifier;
- (void)cancelQueryProducts;
@end
