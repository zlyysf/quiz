//
//  LZTapjoyInterface.h
//  tryTapjoy1
//
//  Created by Yasofon on 13-3-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapjoyConnect.h"

@interface LZTapjoyHelper : NSObject{
    BOOL existFullScreenAd;
    //int showFullScreenAdCount;
}
+(LZTapjoyHelper *)singleton;

-(void) connectTapjoy;
- (void)getFullScreenAd;
- (void)showFullScreenAd;
//- (void)showFullScreenAdWithViewController: vwController;

@property BOOL standardGetAndShow;
//if TRUE, means totally do as the example in tapjoy sdk, get in in control handler, show immediately in notification handler
//if FALSE, try to use cache but seemed no use, e.g., get first, then set flag in notification handler, then show in control handler.





@end
