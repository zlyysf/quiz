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
}
+(LZTapjoyHelper *)singleton;

-(void) connectTapjoy;
- (void)getFullScreenAd;
- (void)showFullScreenAd;

@end
