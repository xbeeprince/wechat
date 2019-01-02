//
//  QORMTableInserter.m
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMTableInserter.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"
#import "QORMTableHelper.h"
#import "QORMTableSearcher.h"
#import "QORMTableUpdater.h"

@implementation QORMTableInserter

+ (BOOL)insertWithModel:(QORMModel *)model
{
    BOOL result = NO;
    NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:model];
    NSArray *search_result = [QORMTableSearcher searchWithPrimaryKeyValue:primaryKeyValue withClassName: NSStringFromClass(model.class)];
    if ([search_result count] > 0) {
        NSLog(@"数据库中存在此记录，将进行 update 操作");
        //更新
        result = [QORMTableUpdater updateWithModel:model];
        return result;
    }
    NSLog(@"进行 insert 操作");
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    NSMutableString *insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString *insertValuesString = [NSMutableString stringWithCapacity:0];
    NSMutableArray *insertValues = [NSMutableArray arrayWithCapacity:propertyInfoArray.count];
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            NSLog(@"insert 子表...");
            //继续存储子表操作
//            QORMModel *infoModel = (QORMModel *)(propertyInfo.value);
//            NSString *dbName = [NSString stringWithFormat:@"%@_%@", propertyInfo.name,[infoModel.class primaryKey]];
//            NSString *dbType = @"TEXT";
//            [tableSQL appendFormat: @"%@ %@,",dbName,dbType];
        }
        else {
            NSString *value = [propertyInfo codeValueToString];
            if (value == nil) {
                continue;
            }
            
            if (insertKey.length > 0) {
                [insertKey appendString:@","];
                [insertValuesString appendString:@","];
            }
            
            [insertKey appendString:propertyInfo.name];
            [insertValuesString appendString:@"?"];
            
            [insertValues addObject:value];
        }
    }
    
    // 拼接insertSQL 语句  采用 replace 插入
    NSString *insertSQL = [NSString stringWithFormat:@"replace into %@(%@) values(%@)", [model.class tableName], insertKey, insertValuesString];
    
    result = [QORMTableHelper excuteUpdateWithSQL:insertSQL withArgumentsInArray:insertValues];
    
    return result;
}

@end
