//
//  LZCell.h
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZButton.h"
@protocol LZCellDelegate<NSObject>
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath;
@end
@interface LZCell : UITableViewCell
@property (nonatomic,weak)id<LZCellDelegate>delegate;
@property (nonatomic,strong)NSIndexPath * cellIndexPath;
@end
