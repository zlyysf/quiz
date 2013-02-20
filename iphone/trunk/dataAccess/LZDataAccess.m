//
//  LZDataAccess.m
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDataAccess.h"

@implementation LZDataAccess

+(LZDataAccess *)singleton {
    static dispatch_once_t pred;
    static LZDataAccess *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[LZDataAccess alloc] initDBConnection];
    });
    return shared;
}

- (id)initDBConnection{
    self = [super init];
    if (self) {
        NSString *dbFilePath = [self dbFilePath];
        dbfm = [FMDatabase databaseWithPath:dbFilePath];
        if (![dbfm open]) {
            //[dbfm release];
            NSLog(@"initDBConnection, FMDatabase databaseWithPath failed, %@", dbFilePath);
        }
    }
    return self;
}

//TODO check programmar
- (void)finalize {
    NSLog(@"LZDataAccess finalize begin");
    [dbfm close];
    [super finalize];
}
//TODO check programmar
- (void)dealloc {
    NSLog(@"LZDataAccess dealloc begin");
    [dbfm close];    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}


- (NSString *)dbFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:cDbFile];
}













- (void)initDb
{
    sqlite3 *db;
    if (sqlite3_open([[self dbFilePath] UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"sqlite3_open failed");
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *initdbFileUrl = [bundle URLForResource:@"initdb2" withExtension:@"sql"];
    
    NSError *err = Nil;
    NSString *initSQL = [NSString stringWithContentsOfURL:initdbFileUrl encoding:NSUTF8StringEncoding error:&err];
    if (err != Nil)
        NSLog(@"get initdb.sql content error: %@ ", err);
    //NSLog(@"initdb.sql content: %@ ", initSQL);
    
    char *errorMsg;
    if (sqlite3_exec (db, [initSQL UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"sqlite3_exec error: %s", errorMsg);
    }
    sqlite3_close(db);
    NSLog(@"initDb exit");
    
}


-(NSString *)replaceForSqlText:(NSString *)origin
{
    return [origin stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
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
    
    NSString *configFileName = @"config.cfg";
    NSString *configFilePath = [topDirPath stringByAppendingPathComponent:configFileName];
    BOOL fileExists,isDir;
    fileExists = [defFileManager fileExistsAtPath:configFilePath isDirectory:&isDir];
    if (!fileExists){
        NSLog(@"generateInitSqlForPackages, config file %@ not exist in %@",configFileName,topDirPath);
    }else{
        //TODO get config from the file
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
            NSMutableDictionary *pkgInfo = [NSMutableDictionary dictionaryWithDictionary:nil];
            [pkgInfo setObject:fileNameForPkg forKey:@"packageName"];
            [pkgInfo setObject:fileNameForPkg forKey:@"pkgkey"];

            NSMutableString* packageSql = [self generateInitSqlForPackage:pathForPkg withPackageInfo:pkgInfo];
            [allSql appendString:packageSql];
        }
    }
    NSLog(@"generateInitSqlForPackages return:\n%@",allSql);
    return allSql;
}

-(NSMutableString*)generateInitSqlForPackage:(NSString *)packagePath withPackageInfo:(NSDictionary *)pkgInfo
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * fileNamesForGrp = [defFileManager contentsOfDirectoryAtPath:packagePath error:&err];
    if (err != Nil){
        NSLog(@"generateInitSqlForPackages contentsOfDirectoryAtPath err:%@",err);
        return nil;
    }
    NSString *pkgkey = [pkgInfo objectForKey:@"pkgkey"];
    NSString *packageName = [pkgInfo objectForKey:@"packageName"];
    NSString *packageSeq = @"1";//TODO
    NSString *locked = @"0";//TODO
    NSMutableString * allSql = [[NSMutableString alloc] init];
    NSString *insertPD = [NSString stringWithFormat:
                          @"INSERT INTO packageDef (name, seq, locked) VALUES ('%@',%@,%@);\n"
                          ,[self replaceForSqlText:packageName],packageSeq,locked];
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
                NSString *awardCoin = @"1";//TODO
                NSString *awardScore = @"100";//TODO
                NSString *locked = @"0";//TODO
                [grpInfo setObject:awardCoin forKey:@"awardCoin"];
                [grpInfo setObject:awardScore forKey:@"awardScore"];
                [grpInfo setObject:locked forKey:@"locked"];
                NSMutableString* groupSql = [self generateInitSqlForGroup:pathForGrp withGroupInfo:grpInfo];
                [allSql appendString:groupSql];
            }
        }
    }
    //NSLog(@"generateInitSqlForPackage return:\n%@",allSql);
    return allSql;
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
    NSString *locked = [grpInfo objectForKey:@"locked"];

    NSString *insertGD = [NSString stringWithFormat:
                          @"  INSERT INTO groupDef (grpkey, name, pkgkey, seqInPkg, awardCoin, awardScore) VALUES ('%@', '%@', '%@', %@, %@, %@);\n"
                          ,[self replaceForSqlText:grpkey],[self replaceForSqlText:groupName],[self replaceForSqlText:pkgkey],groupSeq,awardCoin,awardScore];
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







//
//
//-(NSMutableString*)generateConfigTemplateForPackages:(NSString *)topDirPath
//{
//    NSLog(@"generateConfigTemplateForPackages enter");
//    NSMutableDictionary *rootItem = [[NSMutableDictionary alloc]init];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *configTemplateFileName = @"packagesConfigTemplate.plist";
//    NSString *configTemplateFilePath = [documentsDirectory stringByAppendingPathComponent:configTemplateFileName];
//
//    NSFileManager * defFileManager = [NSFileManager defaultManager];
//    NSError *err = Nil;
//    NSArray * fileNamesForPkg = [defFileManager contentsOfDirectoryAtPath:topDirPath error:&err];
//    if (err != Nil){
//        NSLog(@"generateConfigTemplateForPackages contentsOfDirectoryAtPath err:%@",err);
//        return nil;
//    }
//    BOOL fileExists,isDir;
//    int seq = 1;
//    for (NSString * fileNameForPkg in fileNamesForPkg) {
//        NSString *pathForPkg = [topDirPath stringByAppendingPathComponent:fileNameForPkg];
//        fileExists = [defFileManager fileExistsAtPath:pathForPkg isDirectory:&isDir];
//        if (fileExists && isDir){
//            NSMutableDictionary *pkgItem = [NSMutableDictionary dictionaryWithDictionary:nil];
//            [pkgItem setObject:fileNameForPkg forKey:@"name"];
//            NSString *seqStr = [NSString stringWithFormat:@"%d",seq];
//            [pkgItem setObject:seqStr forKey:@"seq"];
//            [pkgItem setObject:@"0" forKey:@"locked"];
//            
//            NSArray* pkuGroups = [self generateConfigTemplateForPackage:pathForPkg withPackageInfo:pkgItem];
//            [allSql appendString:packageSql];
//            seq++;
//        }
//    }
//    NSLog(@"generateInitSqlForPackages return:\n%@",allSql);
//    return allSql;
//}
//
//-(NSMutableString*)generateConfigTemplateForPackage:(NSString *)packagePath withPackageInfo:(NSDictionary *)pkgInfo
//{
//    NSFileManager * defFileManager = [NSFileManager defaultManager];
//    NSError *err = Nil;
//    NSArray * fileNamesForGrp = [defFileManager contentsOfDirectoryAtPath:packagePath error:&err];
//    if (err != Nil){
//        NSLog(@"generateInitSqlForPackages contentsOfDirectoryAtPath err:%@",err);
//        return nil;
//    }
//    NSString *pkgkey = [pkgInfo objectForKey:@"pkgkey"];
//    NSString *packageName = [pkgInfo objectForKey:@"packageName"];
//    NSString *packageSeq = @"1";//TODO
//    NSString *locked = @"0";//TODO
//    NSMutableString * allSql = [[NSMutableString alloc] init];
//    NSString *insertPD = [NSString stringWithFormat:
//                          @"INSERT INTO packageDef (name, seq, locked) VALUES ('%@',%@,%@);\n"
//                          ,[self replaceForSqlText:packageName],packageSeq,locked];
//    [allSql appendString:insertPD];
//    
//    
//    BOOL fileExists,isDir;
//    for (NSString * fileNameForGrp in fileNamesForGrp) {
//        //NSLog(@"fileName item: %@",fileName);
//        NSString *pathForGrp = [packagePath stringByAppendingPathComponent:fileNameForGrp];
//        fileExists = [defFileManager fileExistsAtPath:pathForGrp isDirectory:&isDir];
//        //NSLog(@"%@ exist=%d isDir=%d",filePath,fileExists,isDir);
//        if (fileExists && isDir){
//            NSMutableDictionary *grpInfo = [NSMutableDictionary dictionaryWithDictionary:pkgInfo];
//            NSString * groupName = fileNameForGrp;
//            NSArray * grpInfoAry = [groupName componentsSeparatedByString:@" "];
//            if (grpInfoAry.count < 2){
//                NSLog(@"bad group name for %@",groupName);
//            }else{
//                NSString *seqPart = grpInfoAry[1];
//                NSString *grpkey = [[pkgkey stringByAppendingString:@":"] stringByAppendingString:groupName];
//                [grpInfo setObject:fileNameForGrp forKey:@"groupName"];
//                [grpInfo setObject:[NSNumber numberWithInteger:[seqPart integerValue]] forKey:@"groupSeq"];
//                [grpInfo setObject:grpkey forKey:@"grpkey"];
//                NSString *awardCoin = @"1";//TODO
//                NSString *awardScore = @"100";//TODO
//                NSString *locked = @"0";//TODO
//                [grpInfo setObject:awardCoin forKey:@"awardCoin"];
//                [grpInfo setObject:awardScore forKey:@"awardScore"];
//                [grpInfo setObject:locked forKey:@"locked"];
//                NSMutableString* groupSql = [self generateInitSqlForGroup:pathForGrp withGroupInfo:grpInfo];
//                [allSql appendString:groupSql];
//            }
//        }
//    }
//    //NSLog(@"generateInitSqlForPackage return:\n%@",allSql);
//    return allSql;
//}
//
//











//SELECT pd1.name name,seq,locked,price, groupCount,passedGroupCount,quizCount,scoreSum
//  FROM
//    packageDef pd1,
//    (SELECT pkgkey, count(grpkey) groupCount FROM groupDef GROUP BY pkgkey) pgc,
//    (SELECT pd.name pkgkey, ifnull(pgc1.groupCount,0) passedGroupCount
//      FROM packageDef pd LEFT OUTER JOIN (
//        SELECT gd.pkgkey, count(gd.grpkey) groupCount
//          FROM groupDef gd LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//          WHERE gr.passed=1
//          GROUP BY gd.pkgkey
//        ) pgc1 ON pd.name=pgc1.pkgkey
//    ) pgpc,
//    (SELECT gd.pkgkey,count(qd.quizkey) quizCount
//      FROM groupDef gd, quizDef qd
//      WHERE gd.grpkey=qd.grpkey GROUP BY gd.pkgkey
//    ) pqc,
//    (SELECT pd.name name, sum(ifnull(gr.gotScoreSum,0)) scoreSum
//      FROM packageDef pd JOIN groupDef gd ON pd.name=gd.pkgkey
//        LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//      GROUP BY pd.name
//    ) ps
//  WHERE pd1.name=pgc.pkgkey and pd1.name=pgpc.pkgkey and pd1.name=pqc.pkgkey and pd1.name=ps.name
//  ORDER BY seq
/**
 get all packages.
 the SQL is like above.
 return an array which item is NSDictionary.
 and the keys of the dictionary are the columns in the Sql sentence.
 package price info stored in other place, here not provide.
 */
- (NSArray *)getPackages {
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
////        //[dbfm release];
////        return;
//        NSLog(@"open db failed, %@", dbFilePath);
//    }

    NSMutableArray *pkgAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""
    "SELECT pd1.name name,seq,locked, groupCount,passedGroupCount,quizCount,scoreSum"
    "  FROM"
    "    packageDef pd1, "
    "    (SELECT pkgkey, count(grpkey) groupCount FROM groupDef GROUP BY pkgkey) pgc,"
    "    (SELECT pd.name pkgkey, ifnull(pgc1.groupCount,0) passedGroupCount"
    "      FROM packageDef pd LEFT OUTER JOIN ("
    "        SELECT gd.pkgkey, count(gd.grpkey) groupCount "
    "          FROM groupDef gd LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey"
    "          WHERE gr.passed=1 "
    "          GROUP BY gd.pkgkey"
    "        ) pgc1 ON pd.name=pgc1.pkgkey"
    "    ) pgpc,"
    "    (SELECT gd.pkgkey,count(qd.quizkey) quizCount"
    "      FROM groupDef gd, quizDef qd "
    "      WHERE gd.grpkey=qd.grpkey GROUP BY gd.pkgkey"
    "    ) pqc,"
    "    (SELECT pd.name name, sum(ifnull(gr.gotScoreSum,0)) scoreSum"
    "      FROM packageDef pd JOIN groupDef gd ON pd.name=gd.pkgkey"
    "        LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey"
    "      GROUP BY pd.name"
    "    ) ps"
    "  WHERE pd1.name=pgc.pkgkey and pd1.name=pgpc.pkgkey and pd1.name=pqc.pkgkey and pd1.name=ps.name"
    "  ORDER BY seq"
    ;
    FMResultSet *rs = [dbfm executeQuery:query];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [pkgAry addObject:rowDict];
    }
    NSLog(@"getPackages ret:\n%@",pkgAry);
//    [dbfm close];
    return pkgAry;
}




//SELECT gd.grpkey grpkey, name, pkgkey, seqInPkg,
//    ifnull(locked,0) locked, ifnull(passed,0) passed, ifnull(gotScoreSum,0) gotScoreSum, ifnull(answerRightMax,0) answerRightMax, quizCount
//  FROM groupDef gd
//    LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//    LEFT OUTER JOIN (
//      SELECT qd.grpkey,count(qd.quizkey) quizCount
//        FROM quizDef qd JOIN groupDef gd1 ON qd.grpkey=gd1.grpkey
//        WHERE gd1.pkgkey='apparel t1' GROUP BY qd.grpkey
//    ) gqc ON gd.grpkey=gqc.grpkey
//  WHERE gd.pkgkey='apparel t1' ORDER BY seqInPkg

/**
  get groups of a package.
  the SQL is like above.
  return an array which item is NSDictionary.
  and the keys of the dictionary are the columns in the Sql sentence.
 */
-(NSArray *) getPackageGroups:(NSString *)pkgkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    
    NSMutableArray *grpAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""    
    "SELECT gd.grpkey grpkey, name, pkgkey, seqInPkg, "
    "    ifnull(locked,0) locked, ifnull(passed,0) passed, ifnull(gotScoreSum,0) gotScoreSum, ifnull(answerRightMax,0) answerRightMax, quizCount"
    "  FROM groupDef gd "
    "    LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey "
    "    LEFT OUTER JOIN ("
    "      SELECT qd.grpkey,count(qd.quizkey) quizCount "
    "        FROM quizDef qd JOIN groupDef gd1 ON qd.grpkey=gd1.grpkey "
    "        WHERE gd1.pkgkey=:pkgkey GROUP BY qd.grpkey"
    "    ) gqc ON gd.grpkey=gqc.grpkey"
    "  WHERE gd.pkgkey=:pkgkey ORDER BY seqInPkg"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:pkgkey, @"pkgkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [grpAry addObject:rowDict];
    }
    NSLog(@"getPackageGroups ret:\n%@",grpAry);
//    [dbfm close];
    return grpAry;
}

/**
 get quizzes of a group.
 return an array which item is NSDictionary.
 and the keys of the dictionary are the columns in the Sql sentence.
 */
-(NSArray *) getGroupQuizzes:(NSString *)grpkey{
    NSArray *quizAry = [self getGroupQuiz:grpkey];
    NSArray *quizOptionAry = [self getGroupQuizOptions:grpkey];
    int i, n, optIdx=0, optCount;
    n = quizAry.count;
    optCount = quizOptionAry.count;
    for(i=0; i<n; i++){
        int oi1 = optIdx++ % optCount;
        int oi2 = optIdx++ % optCount;
        int oi3 = optIdx++ % optCount;
        NSDictionary *opt1,*opt2,*opt3;
        opt1 = quizOptionAry[oi1];
        opt2 = quizOptionAry[oi2];
        opt3 = quizOptionAry[oi3];
        NSLog(@"getGroupQuizzes opt1=\n%@",opt1);
        NSLog(@"getGroupQuizzes opt2=\n%@",opt2);
        NSLog(@"getGroupQuizzes opt3=\n%@",opt3);
        
//        NSLog(@"getGroupQuizzes opt1 allKeys=\n%@",[opt1 allKeys]);
//        NSLog(@"getGroupQuizzes opt2 allKeys=\n%@",[opt2 allKeys]);
//        NSLog(@"getGroupQuizzes opt3 allKeys=\n%@",[opt3 allKeys]);

        NSArray * qzOptions = [NSArray arrayWithObjects:opt1,opt2,opt3,Nil];
        //NSArray * qzOptions = [NSArray arrayWithObjects:opt1,opt2,Nil];
        //NSLog(@"getGroupQuizzes qzOptions=\n%@",qzOptions);
        NSMutableDictionary *qzitem = (NSMutableDictionary *)quizAry[i];
        //NSLog(@"getGroupQuizzes setbefore qzitem=\n%@",qzitem);
        [qzitem setObject:qzOptions forKey:@"options"];
        //NSLog(@"getGroupQuizzes setafter qzitem=\n%@",qzitem);//cause strange error

    }//for i
    NSLog(@"getGroupQuizzes ret:\n%@",quizAry);
    return quizAry;
}

//SELECT qd.quizkey quizkey, grpkey, pkgkey, questionWord, answerPic,
//    ifnull(haveAwardCoin,0) haveAwardCoin, ifnull(haveAwardScore,0) haveAwardScore
//  FROM quizDef qd LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey WHERE qd.grpkey='apparel t1:group 1'
/**
 get quizzes of a group.
 the SQL is like above.
 return an array which item is NSDictionary.
 and the keys of the dictionary are the columns in the Sql sentence.
 */
-(NSArray *) getGroupQuiz:(NSString *)grpkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    
    NSMutableArray *quizAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""
    "SELECT qd.quizkey quizkey, grpkey, pkgkey, questionWord, answerPic, "
    "    ifnull(haveAwardCoin,0) haveAwardCoin, ifnull(haveAwardScore,0) haveAwardScore"
    "  FROM quizDef qd LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey WHERE qd.grpkey=:grpkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [quizAry addObject:rowDict];
    }
    NSLog(@"getGroupQuiz ret:\n%@",quizAry);
//    [dbfm close];
    return quizAry;
}

//SELECT quizkey, answerPic, grpkey, pkgkey
//  FROM quizDef qd
//  WHERE qd.pkgkey IN (SELECT pkgkey FROM quizDef WHERE grpkey='apparel t1:group 1')
//    and qd.grpkey<>'apparel t1:group 1'
//  LIMIT 1
/**
 get all options of all quizzes of a group.
 any of the answers of the quizzes is not in the options.
 each quiz has 3 options.
 the options should be random, but now is fixed order, TODO to make them random.
 the SQL is like above.
 return an array which item is NSDictionary.
 and the keys of the dictionary are the columns in the Sql sentence.
 */
-(NSArray *) getGroupQuizOptions:(NSString *)grpkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    NSMutableArray *quizOptionAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""    
    "SELECT quizkey, answerPic, grpkey, pkgkey"
    "  FROM quizDef qd"
    "  WHERE qd.pkgkey IN (SELECT pkgkey FROM quizDef WHERE grpkey=:grpkey)"
    "    and qd.grpkey<>:grpkey"
    "  LIMIT :limitCount"
    ;
    int limitCount = 30;//TODO get from ...
    NSNumber *nbLimitCount = [NSNumber numberWithInt:limitCount];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey",nbLimitCount,@"limitCount", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [quizOptionAry addObject:rowDict];
    }
    NSLog(@"getGroupQuizOptions ret:\n%@",quizOptionAry);
//    [dbfm close];
    return quizOptionAry;
}


//SELECT qd.quizkey, awardCoin, awardScore, ifnull(haveAwardCoin,0) haveAwardCoin
//  FROM quizDef qd JOIN groupDef gd ON qd.grpkey=gd.grpkey
//    LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey
//  WHERE qd.quizkey='apparel t1:Abercrombie & Fitch'
/**
 when user answer right a quiz, we should award the user about coin and score.
 but here we only modify about coin because score need be updated with statics.
 if the user already obtained the coin of the quiz, we will not give the coin again.
 if the user has not obtained the coin of the quiz, we will give the coin.
 here the give action is to modify the flag haveAwardCoin of the quiz, and totalCoin of the user.
 */
-(NSDictionary *)obtainQuizAward:(NSString *)quizkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    NSString *query = @""
    "SELECT qd.quizkey, awardCoin, awardScore, haveAwardCoin, ifnull(haveAwardCoin,0) haveAwardCoinNoNull"
    "  FROM quizDef qd JOIN groupDef gd ON qd.grpkey=gd.grpkey"
    "    LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey   "
    "  WHERE qd.quizkey=:quizkey"
    ;    
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:quizkey, @"quizkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dictquizInfo;
    if ([rs next]) {
        dictquizInfo = rs.resultDictionary;
    }
    //NSLog(@"obtainQuizAward dictquizInfo:\n%@",dictquizInfo);

    NSNumber *haveAwardCoinNoNullObj = (NSNumber *)[dictquizInfo objectForKey:@"haveAwardCoinNoNull"];
    NSNumber *haveAwardCoinObj = (NSNumber *)[dictquizInfo objectForKey:@"haveAwardCoin"];
    NSNumber *awardCoin = (NSNumber *)[dictquizInfo objectForKey:@"awardCoin"];
    NSNumber *awardScore = (NSNumber *)[dictquizInfo objectForKey:@"awardScore"];
    //NSLog(@"in obtainQuizAward haveAwardCoinObj=%@, haveAwardCoinNoNullObj=%@", haveAwardCoinObj, haveAwardCoinNoNullObj);

    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int haveAwardCoin = [haveAwardCoinNoNullObj intValue];
    if(haveAwardCoin == 1){
        [retDict setValue:haveAwardCoinNoNullObj forKey:@"haveAwardCoin"];
        [retDict setValue:[NSNumber numberWithInt:0] forKey:@"awardCoin"];
        [retDict setValue:[NSNumber numberWithInt:0] forKey:@"awardScore"];
    }else{
        NSString *updateQuizSql;
        
        if ([haveAwardCoinObj isEqual:[NSNull null]]){
            updateQuizSql = @"INSERT INTO quizRun(quizkey,haveAwardCoin) VALUES (:quizkey,:haveAwardCoin)";
        }else{
            updateQuizSql = @"UPDATE quizRun SET haveAwardCoin=:haveAwardCoin WHERE quizkey=:quizkey";
        }
        //NSLog(@"in obtainQuizAward updateQuizSql=%@", updateQuizSql);

        NSDictionary *dictUpdateQuiz = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:1], @"haveAwardCoin",
                                            quizkey, @"quizkey",nil];
        //BOOL updateRet = [dbfm executeUpdate:updateQuizSql withParameterDictionary:dictUpdateQuiz];
        NSError *outErr = Nil;
        BOOL updateRet = [dbfm executeUpdate:updateQuizSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdateQuiz orVAList:nil];
        if (outErr != nil)
            NSLog(@"in obtainQuizAward outErr=%@", outErr);
        if (!updateRet)
            NSLog(@"in obtainQuizAward executeUpdate, up quiz Failed");
        
        [self updateUserTotalCoinByDelta:[awardCoin intValue]];
        
        //NSLog(@"in obtainQuizAward updateRet=%d", updateRet);
        [retDict setValue:haveAwardCoinNoNullObj forKey:@"haveAwardCoin"];
        [retDict setValue:awardCoin forKey:@"awardCoin"];
        [retDict setValue:awardScore forKey:@"awardScore"];
    }
//    [dbfm close];
    return retDict;
}

/**
 simply update totalCoin of the user by delta amount
 */
-(BOOL) updateUserTotalCoinByDelta:(int) totalCoinDelta{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    NSString *updateSql = @"UPDATE user SET totalCoin=totalCoin+:delta WHERE 1=1";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:totalCoinDelta], @"delta",nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateUserTotalCoinByDelta executeUpdate outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateUserTotalCoinByDelta executeUpdate Failed");
//    [dbfm close];
    return updateRet;
}

/**
 simply update totalScore of the user by delta amount
 */
-(BOOL) updateUserTotalScoreByDelta:(int) scoreDelta{
    //    NSString *dbFilePath = [self dbFilePath];
    //    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    //    if (![dbfm open]) {
    //        //        //[dbfm release];
    //        //        return;
    //        NSLog(@"FMDatabase open failed, %@", dbFilePath);
    //    }
    NSString *updateSql = @"UPDATE user SET totalScore=totalScore+:delta WHERE 1=1";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:scoreDelta], @"delta",nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateUserTotalScoreByDelta executeUpdate outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateUserTotalScoreByDelta executeUpdate Failed");
    //    [dbfm close];
    return updateRet;
}

/**
 get totalScore of the user. 
 return a dictionary.
 and the keys of the dictionary are the columns in the Sql sentence.
 here the dictionary contains other fields. if other fields necessary, the function name may be changed.
 */
-(NSDictionary *) getUserTotalScore{
    NSDictionary *rowDict = Nil;
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"open db failed, %@", dbFilePath);
//    }
    NSString *query = @"SELECT name, totalScore, totalCoin FROM user";
    FMResultSet *rs = [dbfm executeQuery:query];
    if ([rs next]) {
        rowDict = rs.resultDictionary;
    }
//    [dbfm close];
    NSLog(@"getUserTotalScore ret:\n%@",rowDict);
    return rowDict;
}


/**
 when user finish answering a whole group of quizzes, 
 we will update the score sum and the right quiz amount in the group if the values are bigger than old.
 */
-(NSDictionary *)updateGroupScoreAndRightQuizAmount:(NSString *)grpkey andScore:(int)score andRightQuizAmount:(int)rightQuizAmount{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    NSString *query = @""
    "SELECT grpkey, gotScoreSum, answerRightMax FROM groupRun WHERE grpkey=:grpkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dictGrpInfo;
    if ([rs next]) {
        dictGrpInfo = rs.resultDictionary;
    }else{
        NSString *insertSql = @"INSERT INTO groupRun(grpkey,gotScoreSum,answerRightMax) VALUES (:grpkey,:gotScoreSum,:answerRightMax)";
        NSDictionary *dictInsert = [NSDictionary dictionaryWithObjectsAndKeys:
                                     grpkey,@"grpkey",
                                     [NSNumber numberWithInt:score], @"gotScoreSum",
                                     [NSNumber numberWithInt:rightQuizAmount], @"answerRightMax",
                                     nil];
        NSError *outErr = Nil;
        BOOL insertRet = [dbfm executeUpdate:insertSql error:&outErr withArgumentsInArray:nil orDictionary:dictInsert orVAList:nil];
        if (outErr != nil)
            NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate insertSql outErr=%@", outErr);
        if (!insertRet)
            NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate insertSql Failed");
//        [retDict setObject:[NSNumber numberWithInt:score] forKey:@"gotScoreSum"];
//        [retDict setObject:[NSNumber numberWithInt:rightQuizAmount] forKey:@"answerRightMax"];
        [self updateUserTotalScoreByDelta:score];
        NSLog(@"updateGroupScoreAndRightQuizAmount dictInsert=%@",dictInsert);
        return dictInsert;
    }
    NSNumber *gotScoreSumNmOld = [dictGrpInfo objectForKey:@"gotScoreSum"];
    NSNumber *answerRightMaxNmOld = [dictGrpInfo objectForKey:@"answerRightMax"];
    int gotScoreSum = [gotScoreSumNmOld intValue];
    int answerRightMax = [answerRightMaxNmOld intValue];
    if (gotScoreSum < score)
        gotScoreSum = score;
    if (answerRightMax < rightQuizAmount)
        answerRightMax = rightQuizAmount;
    
    NSString *updateSql = @"UPDATE groupRun SET gotScoreSum=:gotScoreSum , answerRightMax=:answerRightMax WHERE grpkey=:grpkey";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:                                 
                                 [NSNumber numberWithInt:gotScoreSum], @"gotScoreSum",
                                 [NSNumber numberWithInt:answerRightMax], @"answerRightMax",
                                 grpkey,@"grpkey",
                                 nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate updateSql outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate updateSql Failed");
    NSLog(@"updateGroupScoreAndRightQuizAmount dictUpdate=%@",dictUpdate);
    
    int scoreDelta = gotScoreSum - [gotScoreSumNmOld intValue];
    if (scoreDelta > 0){
        [self updateUserTotalScoreByDelta:scoreDelta];
    }
//    [dbfm close];
    return dictUpdate;
}

/**
 change lock state of a given group.
 when user finish answering a whole group of quizzes and can pass the group,
 we will unlock the next group. and here need ui layer know which group should be unlocked.
 */
-(BOOL)updateGroupLockState:(NSString *)grpkey andLocked:(int)locked{
    NSString *query = @""
    "SELECT grpkey, locked FROM groupRun WHERE grpkey=:grpkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dictGrpInfo;
    if ([rs next]) {
        dictGrpInfo = rs.resultDictionary;
    }else{
        NSString *insertSql = @"INSERT INTO groupRun(grpkey,locked) VALUES (:grpkey,:locked)";
        NSDictionary *dictInsert = [NSDictionary dictionaryWithObjectsAndKeys:
                                    grpkey,@"grpkey",
                                    [NSNumber numberWithInt:locked], @"locked",
                                    nil];
        NSError *outErr = Nil;
        BOOL insertRet = [dbfm executeUpdate:insertSql error:&outErr withArgumentsInArray:nil orDictionary:dictInsert orVAList:nil];
        if (outErr != nil)
            NSLog(@"in updateGroupLockState executeUpdate insertSql outErr=%@", outErr);
        if (!insertRet)
            NSLog(@"in updateGroupLockState executeUpdate insertSql Failed");
        NSLog(@"updateGroupLockState dictInsert=%@",dictInsert);
        return insertRet;
    }
    NSNumber *lockedNmOld = [dictGrpInfo objectForKey:@"locked"];
    int lockedOld = [lockedNmOld intValue];
    if (lockedOld == locked){
        return TRUE;
    }
    
    NSString *updateSql = @"UPDATE groupRun SET locked=:locked WHERE grpkey=:grpkey";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:locked], @"locked",
                                grpkey,@"grpkey",
                                nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateGroupLockState executeUpdate updateSql outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateGroupLockState executeUpdate updateSql Failed");
    NSLog(@"updateGroupLockState dictUpdate=%@",dictUpdate);
    return updateRet;
}

/**
 change lock state of a given package.
 when user finish answering a whole package of groups and can pass the package,
 we will unlock the next package. and here need ui layer know which package should be unlocked.
 */
-(BOOL)updatePackageLockState:(NSString *)pkgkey andLocked:(int)locked{
    NSString *query = @""
    "SELECT locked FROM packageDef WHERE name=:pkgkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:pkgkey, @"pkgkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dict;
    if ([rs next]) {
        dict = rs.resultDictionary;
    }else{
        NSLog(@"updatePackageLockState fail, NO record of %@",pkgkey);
        return FALSE;
    }
    NSNumber *lockedNmOld = [dict objectForKey:@"locked"];
    int lockedOld = [lockedNmOld intValue];
    if (lockedOld == locked){
        return TRUE;
    }
    
    NSString *updateSql = @"UPDATE packageDef SET locked=:locked WHERE name=:pkgkey";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:locked], @"locked",
                                pkgkey,@"pkgkey",
                                nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updatePackageLockState executeUpdate updateSql outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updatePackageLockState executeUpdate updateSql Failed");
    NSLog(@"updateGroupLockState dictUpdate=%@",dictUpdate);
    return updateRet;

}







@end
