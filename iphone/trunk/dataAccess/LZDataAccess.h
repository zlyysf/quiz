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
//#define cConfigTemplateFile    @"packagesConfigTemplate.plist"

@interface LZDataAccess : NSObject{
    FMDatabase *dbfm;
}
+(LZDataAccess *)singleton;
- (id)initDBConnection;


-(NSString *)replaceForSqlText:(NSString *)origin;
+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue;
+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs;
- (NSArray *)selectAllForTable:(NSString *)tableName;
- (NSArray *)selectTableByEqualFilter:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;

- (NSString *)dbFilePath;



-(NSArray *) getPackages;

-(NSArray *) getPackageGroups:(NSString *)pkgkey;
-(NSArray *) getGroupQuizzes:(NSString *)grpkey;
-(NSArray *) getGroupQuizOptions:(NSString *)grpkey;

-(NSDictionary *)obtainQuizAward:(NSString *)quizkey;
-(BOOL) updateUserTotalCoinByDelta:(int) totalCoinDelta;
-(NSDictionary *) getUserTotalScore;

-(NSDictionary *)updateGroupScoreAndRightQuizAmount:(NSString *)grpkey andScore:(int)score andRightQuizAmount:(int)rightQuizAmount;
-(BOOL)updateGroupLockState:(NSString *)grpkey andLocked:(int)locked;
-(BOOL)updatePackageLockState:(NSString *)pkgkey andLocked:(int)locked;

@end
