//
//  LZTopNavView.h
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTopNavViewFrame CGRectMake(0, 0, 320, 44)
@protocol LZTopNavViewDelegate<NSObject>
- (void)backButtonTapped;
- (void)goldButtonTapped;
@end
typedef enum
{
    TopNavTypeNormal,
    TopNavTypeGaming,
    TopNavTypeStore,
}TopNavType;
@interface LZTopNavView : UIView
@property (nonatomic,weak)id<LZTopNavViewDelegate>delegate;
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIButton *goldButton;
@property (nonatomic,strong)UILabel *goldCountLabel;
@property (nonatomic,strong)UIImageView *correctIconImageView;
@property (nonatomic,strong)UILabel *correctCountLabel;
@property (nonatomic,strong)UIImageView *wrongIconImageView;
@property (nonatomic,strong)UILabel *wrongCountLabel;
@property (nonatomic)TopNavType topNavType;
- (id)initWithFrame:(CGRect)frame
           delegate:(id<LZTopNavViewDelegate>)delegate;
@end
