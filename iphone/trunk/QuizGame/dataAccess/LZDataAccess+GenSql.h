//
//  LZDataAccess+GenSql.h
//  testDa
//
//  Created by Yasofon on 13-2-21.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDataAccess.h"

@interface LZDataAccess (GenSql)

- (void)initDb;

-(void)cleanDb;

//- (void)initDbByGeneratedSql;
- (void)initDbWithGeneratedSql;

-(NSMutableString*)generateInitSqlForPackages:(NSString *)topDirPath;
+(void)generateConfigTemplateForPackages:(NSString *)topDirPath;



@end
