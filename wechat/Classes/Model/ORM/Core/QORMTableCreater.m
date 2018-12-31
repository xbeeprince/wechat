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
#import "QORMTableHelper.h"

@implementation QORMTableCreater

+ (BOOL)createTableWithModel:(QORMModel *)model
{
    NSString *tableName = [model.class tableName];
    if ([QORMTableHelper isExistTableWithName:tableName]) {
        NSLog(@"数据库中已经存在此表：%@",tableName);
        return [self addColumnIfNotExistWithModel:model];
    }
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
    BOOL result = NO;
    if ([tableSQL length] > 0) {
        NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@)",[model.class tableName],tableSQL];
        
        result = [QORMTableHelper excuteUpdateWithSQL:createTableSQL];
    }
    
    return result;
}

+ (BOOL)addColumnIfNotExistWithModel:(QORMModel *)model
{
    //检查列
    BOOL result = YES;
    NSString *tableName = [model.class tableName];
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        NSString *dbName;
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            QORMModel *infoModel = (QORMModel *)(propertyInfo.value);
            dbName = [NSString stringWithFormat:@"%@_%@", propertyInfo.name,[infoModel.class primaryKey]];
        }
        else{
            dbName = propertyInfo.name;
        }
        BOOL ret = [QORMTableHelper isExistColumn:dbName inTable:tableName];
        if (ret) {
            NSLog(@"表%@中已经存在此字段：%@",tableName,dbName);
        }
        else{
            NSLog(@"表%@中不经存在此字段，添加新字段：%@",tableName,dbName);
            NSString *dbType = @"TEXT";
            NSString *sql = [NSString stringWithFormat:@"alter table \'%@\' add column \'%@\' %@",tableName,dbName,dbType];
            BOOL addRetsult = [QORMTableHelper excuteUpdateWithSQL:sql];
            if (addRetsult) {
                NSLog(@"添加新列：%@ 成功",dbName);
            }
            else{
                NSLog(@"添加新列：%@ 失败",dbName);
                result = NO;
                break;
            }
        }
    }
    return result;
}

@end
