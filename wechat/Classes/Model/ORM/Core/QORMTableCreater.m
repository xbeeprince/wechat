//
//  QORMTableCreater.m
//  wechat
//
//  Created by iprincewang on 2018/12/29.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMTableCreater.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"
#import "QORMManager.h"

@implementation QORMTableCreater

+(BOOL)createTableWithModel:(QORMModel *)model
{
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    NSMutableString *tableSQL = [NSMutableString string];
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            NSLog(@"创建子表...");
            //继续存储子表操作
            QORMModel *infoModel = (QORMModel *)(propertyInfo.value);
            NSString *dbName = [NSString stringWithFormat:@"%@_%@", propertyInfo.name,[infoModel.class primaryKey]];
            NSString *dbType = @"TEXT";
            [tableSQL appendFormat: @"%@ %@,",dbName,dbType];
            
            [self createTableWithModel:infoModel];
        }
        else{
            //存储字段
            NSLog(@"生成字段...");
            NSString *dbName = propertyInfo.name;
            NSString *dbType = @"TEXT";
            [tableSQL appendFormat: @"%@ %@,",dbName,dbType];
        }
    }
    [tableSQL deleteCharactersInRange:NSMakeRange(tableSQL.length - 1, 1)];
    __block BOOL result = NO;
    if ([tableSQL length] > 0) {
        NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@)",[model.class tableName],tableSQL];
        
        
        FMDatabaseQueue *dbQueue = [[QORMManager getInstance] getDatabaseQueue];
        [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            result = [db executeUpdate:createTableSQL];
        }];
    }
    
    return result;
}

@end
