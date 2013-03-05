//
//  LZSoundButton.m
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSoundButton.h"
#import "LZSoundManager.h"
@implementation LZSoundButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[LZSoundManager SharedInstance]playButtonSound];
    [super touchesEnded:touches withEvent:event];
}

@end
