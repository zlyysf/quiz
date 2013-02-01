//
//  PackageCell.h
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCell.h"

@interface PackageCell : LZCell
@property (strong, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageTotalSubjectCountLabel;
@property (nonatomic,strong)IBOutlet LZButton *selectButton;
@end
