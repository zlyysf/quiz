//
//  LZTool.m
//  toolForPackage
//
//  Created by Yasofon on 13-3-18.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZTool.h"

@implementation LZTool

+(BOOL)textSizeTooHigh: theText
{
    CGSize descriptionSize = [theText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:33]constrainedToSize:CGSizeMake(250, 9999) lineBreakMode:UILineBreakModeWordWrap];
    return(descriptionSize.height > 84.f);
}

+(BOOL)fileNameWithoutExtSizeTooHigh: fileName
{
    NSString *fileNameWithoutExt = [fileName stringByDeletingPathExtension];
    return [self textSizeTooHigh:fileNameWithoutExt];
}

@end
