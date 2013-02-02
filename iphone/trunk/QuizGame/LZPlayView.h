//
//  LZPlayView.h
//  QuizGame
//
//  Created by liu miao on 2/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWinButtonTag 101
#define kCutWrongButtonTag 102
#define kAskFriendsButtonTag 103
#define kAnswerUpLeftButtonTag 201
#define kAnswerUpRightButtonTag 202
#define kAnswerDownLeftButtonTag 203
#define kAnswerDownRightButtonTag 204
#define kAnswerButtonSideLength 120
#define kHelpButtonSideLength 40
@protocol LZPlayViewDelegate<NSObject>
- (void)playViewButtonClicked:(UIButton*)button;
@end
@interface LZPlayView : UIView
@property (nonatomic,weak)id<LZPlayViewDelegate>delegate;
@property (nonatomic,strong)UILabel *progressLabel;
@property (nonatomic,strong)UILabel *questionLabel;
@property (nonatomic,strong)UIButton *winButton;
@property (nonatomic,strong)UIButton *cutWrongButton;
@property (nonatomic,strong)UIButton *askFriendsButton;
@property (nonatomic,strong)UIButton *answerUpLeftButton;
@property (nonatomic,strong)UIButton *answerUpRightButton;
@property (nonatomic,strong)UIButton *answerDownLeftButton;
@property (nonatomic,strong)UIButton *answerDownRightButton;
@end
