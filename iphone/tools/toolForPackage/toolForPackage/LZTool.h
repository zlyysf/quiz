//
//  LZTool.h
//  toolForPackage
//
//  Created by Yasofon on 13-3-18.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZTool : NSObject

+(BOOL)textSizeTooHigh: theText;
+(BOOL)fileNameWithoutExtSizeTooHigh: fileName;

@end
