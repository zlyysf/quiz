//
//  PackageCell.h
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PackageCellDelegate<NSObject>
- (void)selectedPackage:(NSIndexPath *)cellIndexPath;
@end
@interface PackageCell : UITableViewCell
@property (nonatomic,weak)id<PackageCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageTotalSubjectCountLabel;
@property (nonatomic,strong)IBOutlet UIButton *selectButton;
@property (nonatomic,strong)NSIndexPath * packageCellIndexPath;
@end
