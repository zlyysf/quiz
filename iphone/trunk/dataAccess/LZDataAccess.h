//
//  LZDataAccess.h
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define cDbFile    @"db.dat"

@interface LZDataAccess : NSObject
+(LZDataAccess *)singleton;

- (NSString *)dbFilePath;

- (void)initDb;

-(NSArray *) getPackages;
-(int) getUserTotalScore;
-(NSArray *) getPackageGroups:(NSString *)pkgkey;
-(NSArray *) getGroupQuizzes:(NSString *)grpkey;
-(NSArray *) getGroupQuizOptions:(NSString *)grpkey;

@end
