//
//  LZFactoryViewController.h
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZTopNavView.h"
@interface LZFactoryViewController : UIViewController<LZTopNavViewDelegate>
@property (nonatomic,strong)LZTopNavView *topNavView;
@property (nonatomic,strong)UIImageView *controllerBackImageView;

@end
