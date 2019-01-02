//
//  QORMTableHelper.m
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMTableHelper.h"
#import "QORMManager.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"

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

+ (BOOL)excuteUpdateWithSQL:(NSString *)sql withArgumentsInArray:(NSArray *)array
{
    __block BOOL result = NO;
    FMDatabaseQueue *dbQueue = [[QORMManager getInstance] getDatabaseQueue];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db executeUpdate:sql withArgumentsInArray:array];
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

+ (NSString *)primaryKeyValueWithModel:(QORMModel *)model
{
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    NSString *primaryKey = [model.class primaryKey];
    NSString *returnValue = nil;
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        if ([primaryKey isEqualToString:propertyInfo.name]) {
            returnValue = [propertyInfo codeValueToString];
            break;
        }
    }
    return returnValue;
}

@end
