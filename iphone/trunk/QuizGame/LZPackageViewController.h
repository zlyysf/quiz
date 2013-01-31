//
//  LZPackageViewController.h
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFactoryViewController.h"

@interface LZPackageViewController : LZFactoryViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listView;
@end
