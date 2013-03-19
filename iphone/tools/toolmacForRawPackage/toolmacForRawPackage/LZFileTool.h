//
//  LZFileTool.h
//  toolmacForRawPackage
//
//  Created by Yasofon on 13-3-19.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZFileTool : NSObject

+ (void)makePackagesIconsIntoGroups:(NSString *)pkgsParDirPath;
+ (void)makePackageIconsIntoGroups:(NSString *)pkgDirPath;

@end
