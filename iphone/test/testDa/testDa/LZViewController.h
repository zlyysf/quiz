//
//  LZViewController.h
//  testDa
//
//  Created by Yasofon on 13-2-5.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataAccess.h"

@interface LZViewController : UIViewController{
    LZDataAccess * da;

}
- (IBAction)btnInit_touchUpInside:(id)sender;
- (IBAction)btnSelect_touchUpInside:(id)sender;
- (IBAction)btnUpdate_touchUpInside:(id)sender;
- (IBAction)btnSelGrp_touchUpInside:(id)sender;
- (IBAction)btnGenSql_touchUpInside:(id)sender;

@end
