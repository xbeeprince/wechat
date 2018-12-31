//
//  QORMTableHelper.m
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMTableHelper.h"
#import "QORMManager.h"

@implementation QORMTableHelper

+ (BOOL)excuteUpdateWithSQL:(NSString *)sql
{
    __block BOOL result = NO;
    FMDatabaseQueue *dbQueue = [[QORMManager getInstance] getDatabaseQueue];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db executeUpdate:sql];
    }];
    
    return result;
}

+ (FMResultSet *)excuteQueryWithSQL:(NSString *)sql
{
    __block FMResultSet* queryResult;
    FMDatabaseQueue *dbQueue = [[QORMManager getInstance] getDatabaseQueue];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        queryResult = [db executeQuery:sql];
    }];
    
    return queryResult;
}

+ (BOOL)isExistTableWithName:(NSString *)tableName
{
    __block BOOL result = NO;
    FMDatabaseQueue *dbQueue = [[QORMManager getInstance] getDatabaseQueue];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db tableExists:tableName];
    }];
    return result;
}

+ (BOOL)isExistColumn:(NSString *)columnName inTable:(NSString *)tableName
{
    __block BOOL result = NO;
    FMDatabaseQueue *dbQueue = [[QORMManager getInstance] getDatabaseQueue];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db columnExists:columnName inTableWithName:tableName];
    }];
    
    return result;
}

@end
