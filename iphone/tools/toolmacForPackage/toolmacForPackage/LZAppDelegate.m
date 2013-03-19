//
//  LZAppDelegate.m
//  toolmacForPackage
//
//  Created by Yasofon on 13-3-19.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZAppDelegate.h"
#import "LZDataAccess+GenSql.h"

@implementation LZAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)btnGenCfgTmpltPressed:(id)sender {
    NSString * strPkgsDirPath = [[self txtPkgsDirPath ] stringValue];
    [LZDataAccess generateConfigTemplateForPackages:strPkgsDirPath];
}
@end
