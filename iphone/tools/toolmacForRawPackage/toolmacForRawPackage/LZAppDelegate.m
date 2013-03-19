//
//  LZAppDelegate.m
//  toolmacForRawPackage
//
//  Created by Yasofon on 13-3-19.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZAppDelegate.h"
#import "LZFileTool.h"

@implementation LZAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)btnSplitPkgToGroupsClicked:(id)sender {
    NSString *pkgDirPath = [[self txtPackageDirPath ] stringValue];
    NSLog(@"btnSplitPkgToGroupsClicked , txtPackageDirPath=%@", pkgDirPath);
    [LZFileTool makePackageIconsIntoGroups:pkgDirPath];

}

- (IBAction)btnSplitPkgsToGroupsClicked:(id)sender {
    NSString *pkgParDirPath = [[self txtPackageParDirPath ] stringValue];
    [LZFileTool makePackagesIconsIntoGroups:pkgParDirPath];
}


@end
