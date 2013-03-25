//
//  StorePurchaseCell.h
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCell.h"

@interface StorePurchaseCell : LZCell
@property (strong, nonatomic) IBOutlet LZButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkmarkImage;
@property (strong, nonatomic) IBOutlet UIImageView *diamondIcon;

@end
