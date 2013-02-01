//
//  PackageCell.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "PackageCell.h"

@implementation PackageCell
@synthesize selectButton;
@synthesize delegate;
@synthesize packageNameLabel;
@synthesize packageTotalSubjectCountLabel;
@synthesize packageCellIndexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)buttonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedPackage:) ])
    {
        [self.delegate selectedPackage:self.packageCellIndexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
