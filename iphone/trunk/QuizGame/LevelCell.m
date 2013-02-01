//
//  LevelCell.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LevelCell.h"

@implementation LevelCell
@synthesize selectButton;
@synthesize levelCellIndexPath;
@synthesize levelNameLabel;
@synthesize delegate;
@synthesize levelScoreLabel;
@synthesize levelProgressLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)buttonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLevel:) ])
    {
        [self.delegate selectedLevel:self.levelCellIndexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
