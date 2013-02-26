//
//  LZGamingViewController.h
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFactoryViewController.h"
#import "LZPlayView.h"
@interface LZGamingViewController : LZFactoryViewController
@property (nonatomic,strong)LZPlayView *playView1;
@property (nonatomic,strong)LZPlayView *playView2;
@property (nonatomic,strong)NSString *currentGroupKey;
@property (nonatomic,strong)NSString *currentPackageKey;
@end
