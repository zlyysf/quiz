//
//  LevelCell.h
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LevelCellDelegate<NSObject>
- (void)selectedLevel:(NSIndexPath *)cellIndexPath;
@end
@interface LevelCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic,strong)NSIndexPath * levelCellIndexPath;
@property (strong, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (nonatomic,weak)id<LevelCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *levelScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelProgressLabel;
@end
