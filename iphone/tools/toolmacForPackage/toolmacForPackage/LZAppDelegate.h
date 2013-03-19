//
//  LZAppDelegate.h
//  toolmacForPackage
//
//  Created by Yasofon on 13-3-19.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LZAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *txtPkgsDirPath;

- (IBAction)btnGenCfgTmpltPressed:(id)sender;




@end
