//
//  LZViewController.h
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LZButton.h"
@interface LZViewController : UIViewController<MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet LZButton *storeButton;
@property (strong, nonatomic) IBOutlet LZButton *settingButton;
@property (strong, nonatomic) IBOutlet LZButton *playButton;
@end
