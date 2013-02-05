//
//  LZLevelViewController.h
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFactoryViewController.h"

@interface LZLevelViewController : LZFactoryViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSString *currentPackageName;
@end
