//
//  LZDataAccess+GenSql.m
//  testDa
//
//  Created by Yasofon on 13-2-21.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDataAccess+GenSql.h"

@implementation LZDataAccess (GenSql)




/**
 to be deleted
 */
- (void)initDb
{
    sqlite3 *db;
    if (sqlite3_open([[self dbFilePath] UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"initDb sqlite3_open failed");
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *initdbFileUrl = [bundle URLForResource:@"initdb2" withExtension:@"sql"];
    
    NSError *err = Nil;
    NSString *initSQL = [NSString stringWithContentsOfURL:initdbFileUrl encoding:NSUTF8StringEncoding error:&err];
    if (err != Nil)
        NSLog(@"initDb get initdb.sql content error: %@ ", err);
    //NSLog(@"initdb.sql content: %@ ", initSQL);
    
    char *errorMsg;
    if (sqlite3_exec (db, [initSQL UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"initDb sqlite3_exec error: %s", errorMsg);
    }
    sqlite3_close(db);
    NSLog(@"initDb exit");
}



-(void)cleanDb{
    sqlite3 *db;
    if (sqlite3_open([[self dbFilePath] UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"cleanDb sqlite3_open failed");
    }
    NSString *cleanSQL = [self generateDropAllTableSql];
    char *errorMsg;
    if (sqlite3_exec (db, [cleanSQL UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"cleanDb sqlite3_exec error: %s", errorMsg);
    }
    sqlite3_close(db);
    NSLog(@"cleanDb exit");
}
-(NSString*)generateDropAllTableSql
{
    NSString *dropTablesSql = @""
    "DROP TABLE IF EXISTS packageDef;\n"
    "DROP TABLE IF EXISTS groupDef;\n"
    "DROP TABLE IF EXISTS groupRun;\n"
    "DROP TABLE IF EXISTS quizDef;\n"
    "DROP TABLE IF EXISTS quizRun;\n"
    "DROP TABLE IF EXISTS user;\n"
    ;
    return dropTablesSql;
}







/**
 simple init DB, should use initDbWithGeneratedSql to support upgrade.
 */
- (void)initDbByGeneratedSql
{
    sqlite3 *db;
    if (sqlite3_open([[self dbFilePath] UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"initDbByGeneratedSql sqlite3_open failed");
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = [bundle bundlePath];
    NSString *iconsPath = [bundlePath stringByAppendingPathComponent:@"quizicons"];
    NSString *topDirPath = iconsPath;
    NSString *initSQL = [self generateInitSqlForPackages:topDirPath];
    
    char *errorMsg;
    if (sqlite3_exec (db, [initSQL UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"initDbByGeneratedSql sqlite3_exec error: %s", errorMsg);
    }
    sqlite3_close(db);
    NSLog(@"initDbByGeneratedSql exit");
}



-(NSMutableString*)generateInitSqlForPackages:(NSString *)topDirPath
{
    NSLog(@"generateInitSqlForPackages enter");
    NSMutableString * allSql = [[NSMutableString alloc] init];
    NSString *createTablesSql = @""
    "CREATE TABLE IF NOT EXISTS packageDef (name TEXT PRIMARY KEY, seq INTEGER, locked INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS groupDef (grpkey TEXT PRIMARY KEY, name TEXT, pkgkey TEXT, seqInPkg INTEGER, awardCoin INTEGER, awardScore INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS groupRun (grpkey TEXT PRIMARY KEY, locked INTEGER, passed INTEGER, gotScoreSum INTEGER, answerRightMax INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS quizDef (quizkey TEXT PRIMARY KEY, grpkey TEXT, pkgkey TEXT, questionWord TEXT, answerPic TEXT);\n"
    "CREATE TABLE IF NOT EXISTS quizRun (quizkey TEXT PRIMARY KEY, haveAwardCoin INTEGER, haveAwardScore INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS user (name TEXT PRIMARY KEY, totalScore INTEGER, totalCoin INTEGER);\n"
    ;
    [allSql appendString:createTablesSql];
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    
    NSString *configFileName = @"packageConfig.plist";
    NSString *configFilePath = [topDirPath stringByAppendingPathComponent:configFileName];
    NSMutableDictionary *cfgRootDict = nil;
    BOOL fileExists,isDir;
    fileExists = [defFileManager fileExistsAtPath:configFilePath isDirectory:&isDir];
    if (!fileExists){
        NSLog(@"in generateInitSqlForPackages, config file not exist: %@ IN %@",configFileName,topDirPath);
    }else{
        // get config from the file
        cfgRootDict = [NSMutableDictionary dictionaryWithContentsOfFile:configFilePath];
    }
    if (cfgRootDict == nil){
        NSLog(@"in generateInitSqlForPackages, root config not exist");
    }
    NSDictionary *cfgPackagesDict = [cfgRootDict objectForKey:@"packages"];
    if (cfgPackagesDict == nil){
        NSLog(@"in generateInitSqlForPackages, packages config not exist");
    }
    
    NSError *err = Nil;
    NSArray * fileNamesForPkg = [defFileManager contentsOfDirectoryAtPath:topDirPath error:&err];
    if (err != Nil){
        NSLog(@"generateInitSqlForPackages contentsOfDirectoryAtPath err:%@",err);
        return nil;
    }
    
    for (NSString * fileNameForPkg in fileNamesForPkg) {
        //NSLog(@"fileName item: %@",fileName);
        NSString *pathForPkg = [topDirPath stringByAppendingPathComponent:fileNameForPkg];
        fileExists = [defFileManager fileExistsAtPath:pathForPkg isDirectory:&isDir];
        //NSLog(@"%@ exist=%d isDir=%d",filePath,fileExists,isDir);
        if (fileExists && isDir){
            NSDictionary *cfgPackageDict = [cfgPackagesDict objectForKey:fileNameForPkg];
            if (cfgPackageDict == nil){
                NSLog(@"in generateInitSqlForPackages, package config not exist for %@",fileNameForPkg);
            }
            
            NSMutableDictionary *pkgInfo = [NSMutableDictionary dictionaryWithDictionary:nil];
            [pkgInfo setObject:fileNameForPkg forKey:@"packageName"];
            [pkgInfo setObject:fileNameForPkg forKey:@"pkgkey"];
            [pkgInfo setObject:cfgPackageDict forKey:@"configPackage"];
            [pkgInfo setObject:cfgRootDict forKey:@"configRoot"];
            
            NSMutableString* packageSql = [self generateInitSqlForPackage:pathForPkg withPackageInfo:pkgInfo];
            [allSql appendString:packageSql];
        }
    }
    
    NSString *initUserSql = @"INSERT INTO user (name, totalScore, totalCoin) VALUES ('u1',0,0);\n";
    [allSql appendString:initUserSql];
    
    NSLog(@"generateInitSqlForPackages return:\n%@",allSql);
    return allSql;
}

-(NSMutableString*)generateInitSqlForPackage:(NSString *)packagePath withPackageInfo:(NSDictionary *)pkgInfo
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * fileNamesForGrp = [defFileManager contentsOfDirectoryAtPath:packagePath error:&err];
    if (err != Nil){
        NSLog(@"in generateInitSqlForPackage, contentsOfDirectoryAtPath err:%@",err);
        return nil;
    }
    
    NSString *pkgkey = [pkgInfo objectForKey:@"pkgkey"];
    NSString *packageName = [pkgInfo objectForKey:@"packageName"];
    NSString *packageSeq = @"1";
    NSString *packageLocked = @"0";
    NSDictionary *cfgPackageDict = [pkgInfo objectForKey:@"configPackage"];
    NSDictionary *cfgRootDict = [pkgInfo objectForKey:@"configRoot"];
    
    NSString *awardCoinCfgInRoot = [cfgRootDict objectForKey:@"awardCoin"];
    NSString *awardScoreCfgInRoot = [cfgRootDict objectForKey:@"awardScore"];
    NSString *awardCoinCfgInPackage = [cfgPackageDict objectForKey:@"awardCoin"];
    NSString *awardScoreCfgInPackage = [cfgPackageDict objectForKey:@"awardScore"];
    
    if (cfgPackageDict != nil){
        NSString *seqInCfg = [cfgPackageDict objectForKey:@"seq"];
        if (seqInCfg != nil && seqInCfg.length > 0){
            packageSeq = seqInCfg;
        }else{
            NSLog(@"in generateInitSqlForPackage, expect seq config for package %@",packageName);
        }
        NSString *lockedInCfg = [cfgPackageDict objectForKey:@"locked"];
        if (lockedInCfg != nil && lockedInCfg.length > 0){
            packageLocked = lockedInCfg;
        }else{
            NSLog(@"in generateInitSqlForPackage, expect locked config for package %@",packageName);
        }
    }else{
        NSLog(@"in generateInitSqlForPackage, expect package config for %@",packageName);
    }
    
    NSDictionary *cfgGroupsDict = [cfgPackageDict objectForKey:@"groups"];
    if (cfgGroupsDict==nil){
        NSLog(@"in generateInitSqlForPackage, expect groups config for package %@",packageName);
    }
    
    NSMutableString * allSql = [[NSMutableString alloc] init];
    NSString *insertPD = [NSString stringWithFormat:
                          @"INSERT INTO packageDef (name, seq, locked) VALUES ('%@',%@,%@);\n"
                          ,[self replaceForSqlText:packageName],packageSeq,packageLocked];
    [allSql appendString:insertPD];
    
    BOOL fileExists,isDir;
    for (NSString * fileNameForGrp in fileNamesForGrp) {
        //NSLog(@"fileName item: %@",fileName);
        NSString *pathForGrp = [packagePath stringByAppendingPathComponent:fileNameForGrp];
        fileExists = [defFileManager fileExistsAtPath:pathForGrp isDirectory:&isDir];
        //NSLog(@"%@ exist=%d isDir=%d",filePath,fileExists,isDir);
        if (fileExists && isDir){
            NSMutableDictionary *grpInfo = [NSMutableDictionary dictionaryWithDictionary:pkgInfo];
            NSString * groupName = fileNameForGrp;
            NSArray * grpInfoAry = [groupName componentsSeparatedByString:@" "];
            if (grpInfoAry.count < 2){
                NSLog(@"bad group name for %@",groupName);
            }else{
                NSString *seqPart = grpInfoAry[1];
                NSString *grpkey = [[pkgkey stringByAppendingString:@":"] stringByAppendingString:groupName];
                [grpInfo setObject:fileNameForGrp forKey:@"groupName"];
                [grpInfo setObject:[NSNumber numberWithInteger:[seqPart integerValue]] forKey:@"groupSeq"];
                [grpInfo setObject:grpkey forKey:@"grpkey"];
                
                NSDictionary *cfgGroupDict = [cfgGroupsDict objectForKey:groupName];
                if (cfgGroupDict == nil){
                    NSLog(@"in generateInitSqlForPackage, expect package group config: %@ : %@",packageName,groupName);
                }
                
                NSString *awardCoin = @"1";
                NSString *awardScore = @"100";
                NSString *groupLocked = @"1";
                
                NSString *groupLockedInCfg = [cfgGroupDict objectForKey:@"locked"];
                if (groupLockedInCfg != nil && groupLockedInCfg.length > 0){
                    groupLocked = groupLockedInCfg;
                }else{
                    NSLog(@"in generateInitSqlForPackage, expect locked config for package group %@:%@",packageName,groupName);
                }
                
                NSString *awardCoinCfgInGroup = [cfgGroupDict objectForKey:@"awardCoin"];
                NSString *awardScoreCfgInGroup = [cfgGroupDict objectForKey:@"awardScore"];
                if (awardCoinCfgInGroup.length > 0){
                    awardCoin = awardCoinCfgInGroup;
                }else if(awardCoinCfgInPackage.length > 0){
                    awardCoin = awardCoinCfgInPackage;
                }else if(awardCoinCfgInRoot.length > 0){
                    awardCoin = awardCoinCfgInRoot;
                }
                
                if (awardScoreCfgInGroup.length > 0){
                    awardScore = awardScoreCfgInGroup;
                }else if(awardScoreCfgInPackage.length > 0){
                    awardScore = awardScoreCfgInPackage;
                }else if(awardScoreCfgInRoot.length > 0){
                    awardScore = awardScoreCfgInRoot;
                }
                
                [grpInfo setObject:awardCoin forKey:@"awardCoin"];
                [grpInfo setObject:awardScore forKey:@"awardScore"];
                [grpInfo setObject:groupLocked forKey:@"locked"];
                NSMutableString* groupSql = [self generateInitSqlForGroup:pathForGrp withGroupInfo:grpInfo];
                [allSql appendString:groupSql];
            }
        }
    }
    //NSLog(@"generateInitSqlForPackage return:\n%@",allSql);
    return allSql;
}









+(void)generateConfigTemplateForPackages:(NSString *)topDirPath
{
    NSLog(@"generateConfigTemplateForPackages enter");
    NSMutableDictionary *rootItem = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *pkgs = [[NSMutableDictionary alloc]init];
    [rootItem setObject:pkgs forKey:@"packages"];
    [rootItem setObject:@"1" forKey:@"awardCoin"];
    [rootItem setObject:@"100" forKey:@"awardScore"];
    
    [rootItem setObject:@"3" forKey:@"passRate"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *configTemplateFileName = @"packagesConfigTemplate.plist";
    NSString *configTemplateFilePath = [documentsDirectory stringByAppendingPathComponent:configTemplateFileName];
    NSLog(@"configTemplateFilePath=%@",configTemplateFilePath);
    
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * fileNamesForPkg = [defFileManager contentsOfDirectoryAtPath:topDirPath error:&err];
    if (err != Nil){
        NSLog(@"generateConfigTemplateForPackages contentsOfDirectoryAtPath err:%@",err);
        return;
    }
    BOOL fileExists,isDir;
    int seq = 1;
    for (NSString * fileNameForPkg in fileNamesForPkg) {
        NSString *pathForPkg = [topDirPath stringByAppendingPathComponent:fileNameForPkg];
        fileExists = [defFileManager fileExistsAtPath:pathForPkg isDirectory:&isDir];
        if (fileExists && isDir){
            NSMutableDictionary *pkgItem = [NSMutableDictionary dictionaryWithDictionary:nil];
            //            [pkgItem setObject:fileNameForPkg forKey:@"name"];
            NSString *seqStr = [NSString stringWithFormat:@"%d",seq];
            [pkgItem setObject:seqStr forKey:@"seq"];
            [pkgItem setObject:@"0" forKey:@"locked"];
            //            [pkgItem setObject:@"1" forKey:@"awardCoin"];
            //            [pkgItem setObject:@"100" forKey:@"awardScore"];
            
            NSDictionary* pkgGroups = [self generateConfigTemplateForPackage:pathForPkg withPackageInfo:pkgItem];
            [pkgItem setObject:pkgGroups forKey:@"groups"];
            
            [pkgs setObject:pkgItem forKey:fileNameForPkg];
            
            seq++;
        }
    }
    [rootItem writeToFile:configTemplateFilePath atomically:YES];
    //NSLog(@"generateConfigTemplateForPackages rootItem=:\n%@",rootItem);
    
}

+(NSDictionary*)generateConfigTemplateForPackage:(NSString *)packagePath withPackageInfo:(NSDictionary *)pkgItem
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * fileNamesForGrp = [defFileManager contentsOfDirectoryAtPath:packagePath error:&err];
    if (err != Nil){
        NSLog(@"generateConfigTemplateForPackage contentsOfDirectoryAtPath err:%@",err);
        return nil;
    }
    NSMutableDictionary *grps = [[NSMutableDictionary alloc]init];
    BOOL fileExists,isDir;
    for (NSString * fileNameForGrp in fileNamesForGrp) {
        NSString *pathForGrp = [packagePath stringByAppendingPathComponent:fileNameForGrp];
        fileExists = [defFileManager fileExistsAtPath:pathForGrp isDirectory:&isDir];
        if (fileExists && isDir){
            NSString * groupName = fileNameForGrp;
            NSArray * grpInfoAry = [groupName componentsSeparatedByString:@" "];
            if (grpInfoAry.count < 2){
                NSLog(@"bad group name for %@",groupName);
            }else{
                NSMutableDictionary *grpItem = [NSMutableDictionary dictionaryWithDictionary:nil];
                //                [grpItem setObject:groupName forKey:@"name"];
                ////                [grpItem setObject:@"0" forKey:@"awardCoin"];
                ////                [grpItem setObject:@"0" forKey:@"awardScore"];
                int locked = 1;
                NSString *seqPart = grpInfoAry[1];
                if ([seqPart integerValue]==1)
                    locked = 0;
                NSString *lockedStr = [NSString stringWithFormat:@"%d",locked];
                [grpItem setObject:lockedStr forKey:@"locked"];
                
                //because passRate be set only at root for now
//                NSString *passRateStr = [NSString stringWithFormat:@"%d",99];
//                [grpItem setObject:passRateStr forKey:@"passRate"];

                [grps setObject:grpItem forKey:groupName];
                
            }
        }
    }
    //NSLog(@"generateConfigTemplateForPackage return:\n%@",grps);
    return grps;
}






/**
 this init DB function has considered about upgrading.
 when updating, some packages and some other data already exist, 
 so not generate those data, only generate data for those not exist.
 */
- (void)initDbWithGeneratedSql
{
    sqlite3 *db;
    if (sqlite3_open([[self dbFilePath] UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"initDbWithGeneratedSql sqlite3_open failed");
        return;
    }
    
    [self createTables:db];
    [self initForUser:db];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = [bundle bundlePath];
    NSString *iconsPath = [bundlePath stringByAppendingPathComponent:@"quizicons"];
    NSString *topDirPath = iconsPath;
    [self initForPackages:db andTopDir:topDirPath];
    
    sqlite3_close(db);
    NSLog(@"initDbWithGeneratedSql exit");
}

/**
 once create, not do any changes if being executed for more than 1 time
 */
-(BOOL)createTables:(sqlite3 *)db
{
    NSString *createTablesSql = @""
    "CREATE TABLE IF NOT EXISTS packageDef (name TEXT PRIMARY KEY, seq INTEGER, locked INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS groupDef (grpkey TEXT PRIMARY KEY, name TEXT, pkgkey TEXT, seqInPkg INTEGER, awardCoin INTEGER, awardScore INTEGER, passRate INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS groupRun (grpkey TEXT PRIMARY KEY, locked INTEGER, passed INTEGER, gotScoreSum INTEGER, answerRightMax INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS quizDef (quizkey TEXT PRIMARY KEY, grpkey TEXT, pkgkey TEXT, questionWord TEXT, answerPic TEXT);\n"
    "CREATE TABLE IF NOT EXISTS quizRun (quizkey TEXT PRIMARY KEY, haveAwardCoin INTEGER, haveAwardScore INTEGER);\n"
    "CREATE TABLE IF NOT EXISTS user (name TEXT PRIMARY KEY, totalScore INTEGER, totalCoin INTEGER);\n"
    ;
    char *errorMsg;
    if (sqlite3_exec (db, [createTablesSql UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"createTables error: %s", errorMsg);
        return FALSE;
    }
    return TRUE;
}

/**
 only init once. if user data aleady exist, then not do init action.
 */
-(void)initForUser:(sqlite3 *)db
{
    NSArray *rows = [self selectAllForTable:@"user"];
    if(rows.count > 0){
        NSLog(@"INFO initForUser, data already exist");
        return ;
    }
    NSString *initUserSql = @"INSERT INTO user (name, totalScore, totalCoin) VALUES ('u1',0,0);\n";
    char *errorMsg;
    if (sqlite3_exec (db, [initUserSql UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"initForUser error: %s", errorMsg);
    }
}


/**
 any package data only be generated once. so support upgrade.
 */
-(void)initForPackages:(sqlite3 *)db andTopDir:(NSString *)topDirPath
{
    NSLog(@"initForPackages enter");
   
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    
    NSString *configFileName = @"packageConfig.plist";
    NSString *configFilePath = [topDirPath stringByAppendingPathComponent:configFileName];
    NSMutableDictionary *cfgRootDict = nil;
    BOOL fileExists,isDir;
    fileExists = [defFileManager fileExistsAtPath:configFilePath isDirectory:&isDir];
    if (!fileExists){
        NSLog(@"WARN in initForPackages, config file not exist: %@ IN %@",configFileName,topDirPath);
    }else{
        // get config from the file
        cfgRootDict = [NSMutableDictionary dictionaryWithContentsOfFile:configFilePath];
    }
    if (cfgRootDict == nil){
        NSLog(@"WARN in initForPackages, root config not exist");
    }
    NSDictionary *cfgPackagesDict = [cfgRootDict objectForKey:@"packages"];
    if (cfgPackagesDict == nil){
        NSLog(@"WARN in initForPackages, packages config not exist");
    }
    
    NSError *err = Nil;
    NSArray * fileNamesForPkg = [defFileManager contentsOfDirectoryAtPath:topDirPath error:&err];
    if (err != Nil){
        NSLog(@"initForPackages contentsOfDirectoryAtPath err:%@",err);
        return ;
    }
    
    int pkgCnt = 0;
    for (NSString * fileNameForPkg in fileNamesForPkg) {
//        if (pkgCnt>=2)//just for test about upgrade
//            return;
        NSString *pathForPkg = [topDirPath stringByAppendingPathComponent:fileNameForPkg];
        fileExists = [defFileManager fileExistsAtPath:pathForPkg isDirectory:&isDir];
        if (fileExists && isDir){
            NSDictionary *cfgPackageDict = [cfgPackagesDict objectForKey:fileNameForPkg];
            //NSLog(@"in initForPackages, cfgPackageDict=\n%@",cfgPackageDict);
            if (cfgPackageDict == nil){
                NSLog(@"WARN in initForPackages, package config not exist for %@",fileNameForPkg);
            }
            
            NSMutableDictionary *pkgInfo = [NSMutableDictionary dictionaryWithDictionary:nil];
            [pkgInfo setObject:fileNameForPkg forKey:@"packageName"];
            [pkgInfo setObject:fileNameForPkg forKey:@"pkgkey"];
            if (cfgPackageDict != nil){
                [pkgInfo setObject:cfgPackageDict forKey:@"configPackage"];
            }
            [pkgInfo setObject:cfgRootDict forKey:@"configRoot"];
            
            [self initForPackage:db andPackagePath:pathForPkg withPackageInfo:pkgInfo];
            pkgCnt++;
        }
    }
}


/**
 only generate data once.
 if the package data already exists in db, will not generate the data for the package.
 */
-(void)initForPackage:(sqlite3 *)db andPackagePath:(NSString *)packagePath withPackageInfo:(NSDictionary *)pkgInfo
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * fileNamesForGrp = [defFileManager contentsOfDirectoryAtPath:packagePath error:&err];
    if (err != Nil){
        NSLog(@"in initForPackage, contentsOfDirectoryAtPath err:%@",err);
        return ;
    }
    
    NSString *pkgkey = [pkgInfo objectForKey:@"pkgkey"];
    NSString *packageName = [pkgInfo objectForKey:@"packageName"];
    
    NSArray *packageRows = [self selectTableByEqualFilter:@"packageDef" andField:@"name" andValue:packageName];
    if (packageRows.count > 0){
        NSLog(@"INFO initForPackage, package already exists : %@",packageName);
        return ;
    }else{
        NSLog(@"INFO initForPackage, package not exists and will be inited : %@",packageName);
    }
    
    NSString *packageSeq = @"1";
    NSString *packageLocked = @"0";
    NSDictionary *cfgPackageDict = [pkgInfo objectForKey:@"configPackage"];
    NSDictionary *cfgRootDict = [pkgInfo objectForKey:@"configRoot"];
    
    NSString *awardCoinCfgInRoot = [cfgRootDict objectForKey:@"awardCoin"];
    NSString *awardScoreCfgInRoot = [cfgRootDict objectForKey:@"awardScore"];
    NSString *passRateCfgInRoot = [cfgRootDict objectForKey:@"passRate"];
    
    NSString *awardCoinCfgInPackage = [cfgPackageDict objectForKey:@"awardCoin"];
    NSString *awardScoreCfgInPackage = [cfgPackageDict objectForKey:@"awardScore"];
    NSString *passRateCfgInPackage = [cfgPackageDict objectForKey:@"passRate"];
    
    if (cfgPackageDict != nil){
        NSString *seqInCfg = [cfgPackageDict objectForKey:@"seq"];
        if (seqInCfg != nil && seqInCfg.length > 0){
            packageSeq = seqInCfg;
        }else{
            NSLog(@"in initForPackage, expect seq config for package %@",packageName);
        }
        NSString *lockedInCfg = [cfgPackageDict objectForKey:@"locked"];
        if (lockedInCfg != nil && lockedInCfg.length > 0){
            packageLocked = lockedInCfg;
        }else{
            NSLog(@"in initForPackage, expect locked config for package %@",packageName);
        }
    }else{
        NSLog(@"in initForPackage, expect package config for %@",packageName);
    }
    
    NSDictionary *cfgGroupsDict = [cfgPackageDict objectForKey:@"groups"];
    if (cfgGroupsDict==nil){
        NSLog(@"in initForPackage, expect groups config for package %@",packageName);
    }
    
    NSMutableString * allSql = [[NSMutableString alloc] init];
    NSString *insertPD = [NSString stringWithFormat:
                          @"INSERT INTO packageDef (name, seq, locked) VALUES ('%@',%@,%@);\n"
                          ,[self replaceForSqlText:packageName],packageSeq,packageLocked];
    [allSql appendString:insertPD];
    
    BOOL fileExists,isDir;
    for (NSString * fileNameForGrp in fileNamesForGrp) {
        NSString *pathForGrp = [packagePath stringByAppendingPathComponent:fileNameForGrp];
        fileExists = [defFileManager fileExistsAtPath:pathForGrp isDirectory:&isDir];
        if (fileExists && isDir){
            NSMutableDictionary *grpInfo = [NSMutableDictionary dictionaryWithDictionary:pkgInfo];
            NSString * groupName = fileNameForGrp;
            NSArray * grpInfoAry = [groupName componentsSeparatedByString:@" "];
            if (grpInfoAry.count < 2){
                NSLog(@"bad group name for %@",groupName);
            }else{
                NSString *seqPart = grpInfoAry[1];
                NSString *grpkey = [[pkgkey stringByAppendingString:@":"] stringByAppendingString:groupName];
                [grpInfo setObject:fileNameForGrp forKey:@"groupName"];
                [grpInfo setObject:[NSNumber numberWithInteger:[seqPart integerValue]] forKey:@"groupSeq"];
                [grpInfo setObject:grpkey forKey:@"grpkey"];
                
                NSDictionary *cfgGroupDict = [cfgGroupsDict objectForKey:groupName];
                if (cfgGroupDict == nil){
                    NSLog(@"in initForPackage, expect package group config: %@ : %@",packageName,groupName);
                }
                
                NSString *awardCoin = @"1";
                NSString *awardScore = @"100";
                NSString *passRate = @"99";
                NSString *groupLocked = @"1";
                
                NSString *groupLockedInCfg = [cfgGroupDict objectForKey:@"locked"];
                if (groupLockedInCfg != nil && groupLockedInCfg.length > 0){
                    groupLocked = groupLockedInCfg;
                }else{
                    NSLog(@"in initForPackage, expect locked config for package group %@:%@",packageName,groupName);
                }
                
                NSString *awardCoinCfgInGroup = [cfgGroupDict objectForKey:@"awardCoin"];
                NSString *awardScoreCfgInGroup = [cfgGroupDict objectForKey:@"awardScore"];
                NSString *passRateCfgInGroup = [cfgGroupDict objectForKey:@"passRate"];
                if (awardCoinCfgInGroup.length > 0){
                    awardCoin = awardCoinCfgInGroup;
                }else if(awardCoinCfgInPackage.length > 0){
                    awardCoin = awardCoinCfgInPackage;
                }else if(awardCoinCfgInRoot.length > 0){
                    awardCoin = awardCoinCfgInRoot;
                }
                
                if (awardScoreCfgInGroup.length > 0){
                    awardScore = awardScoreCfgInGroup;
                }else if(awardScoreCfgInPackage.length > 0){
                    awardScore = awardScoreCfgInPackage;
                }else if(awardScoreCfgInRoot.length > 0){
                    awardScore = awardScoreCfgInRoot;
                }
                
                if (passRateCfgInGroup.length > 0){
                    passRate = passRateCfgInGroup;
                }else if(passRateCfgInPackage.length > 0){
                    passRate = passRateCfgInPackage;
                }else if(passRateCfgInRoot.length > 0){
                    passRate = passRateCfgInRoot;
                }
                
                [grpInfo setObject:awardCoin forKey:@"awardCoin"];
                [grpInfo setObject:awardScore forKey:@"awardScore"];
                [grpInfo setObject:groupLocked forKey:@"locked"];
                [grpInfo setObject:passRate forKey:@"passRate"];
                NSMutableString* groupSql = [self generateInitSqlForGroup:pathForGrp withGroupInfo:grpInfo];
                [allSql appendString:groupSql];
            }
        }
    }
    //NSLog(@"initForPackage allSql=\n%@",allSql);
    char *errorMsg;
    if (sqlite3_exec (db, [allSql UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"initForPackage %@ error: %s",packageName, errorMsg);
    }
}






-(NSMutableString*)generateInitSqlForGroup:(NSString *)groupPath withGroupInfo:(NSDictionary *)grpInfo
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * fileNamesForQuiz = [defFileManager contentsOfDirectoryAtPath:groupPath error:&err];
    if (err != Nil){
        NSLog(@"generateInitSqlForGroup contentsOfDirectoryAtPath err:%@",err);
        return nil;
    }
    
    NSMutableString * allSql = [[NSMutableString alloc] init];
    
    NSString *pkgkey = [grpInfo objectForKey:@"pkgkey"];
    NSString *packageName = [grpInfo objectForKey:@"packageName"];
    NSString *grpkey = [grpInfo objectForKey:@"grpkey"];
    NSString *groupName = [grpInfo objectForKey:@"groupName"];
    NSNumber *groupSeq = [grpInfo objectForKey:@"groupSeq"];
    NSString *awardCoin = [grpInfo objectForKey:@"awardCoin"];
    NSString *awardScore = [grpInfo objectForKey:@"awardScore"];
    NSString *passRate = [grpInfo objectForKey:@"passRate"];
    NSString *locked = [grpInfo objectForKey:@"locked"];
    
    NSString *insertGD = [NSString stringWithFormat:
                          @"  INSERT INTO groupDef (grpkey, name, pkgkey, seqInPkg, awardCoin, awardScore,passRate) VALUES ('%@', '%@', '%@', %@, %@, %@, %@);\n"
                          ,[self replaceForSqlText:grpkey],[self replaceForSqlText:groupName],[self replaceForSqlText:pkgkey],groupSeq,awardCoin,awardScore,passRate];
    NSString *insertGR = [NSString stringWithFormat:
                          @"  INSERT INTO groupRun (grpkey, locked, passed, gotScoreSum, answerRightMax) VALUES ('%@', %@, 0, 0, 0);\n"
                          ,[self replaceForSqlText:grpkey],locked];
    [allSql appendString:insertGD];
    [allSql appendString:insertGR];
    
    
    BOOL fileExists,isDir;
    for (NSString * fileNameForQuiz in fileNamesForQuiz) {
        //NSLog(@"fileName item: %@",fileName);
        NSString *pathForQuiz = [groupPath stringByAppendingPathComponent:fileNameForQuiz];
        fileExists = [defFileManager fileExistsAtPath:pathForQuiz isDirectory:&isDir];
        //NSLog(@"%@ exist=%d isDir=%d",filePath,fileExists,isDir);
        if (fileExists && !isDir){
            NSString *extName = [fileNameForQuiz pathExtension];
            NSString *quizName = [fileNameForQuiz substringToIndex:(fileNameForQuiz.length - 1 - extName.length)];
            NSString *quizkey = [[grpkey stringByAppendingString:@":"] stringByAppendingString:quizName];
            NSString *questionWord = quizName;
            NSString *answerPic = [[packageName stringByAppendingPathComponent:groupName]stringByAppendingPathComponent:fileNameForQuiz];
            NSString *insertQD = [NSString stringWithFormat:
                                  @"    INSERT INTO quizDef (quizkey, grpkey, pkgkey, questionWord, answerPic) VALUES ('%@', '%@', '%@',  '%@', '%@');\n"
                                  ,[self replaceForSqlText:quizkey],[self replaceForSqlText:grpkey],[self replaceForSqlText:pkgkey],[self replaceForSqlText:questionWord], [self replaceForSqlText:answerPic]];
            [allSql appendString:insertQD];
        }
    }
    //NSLog(@"generateInitSqlForGroup return:\n%@",allSql);
    return allSql;
}











@end
