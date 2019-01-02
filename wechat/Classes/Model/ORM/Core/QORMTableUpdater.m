//
//  QORMTableUpdater.m
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMTableUpdater.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"
#import "QORMTableHelper.h"

@implementation QORMTableUpdater

+ (BOOL)updateWithModel:(QORMModel *)model
{
    NSLog(@"进行 update 操作");
    BOOL result = NO;
    NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:model];
    
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    NSMutableString *updateKey = [NSMutableString string];
    NSMutableArray *updateValues = [NSMutableArray arrayWithCapacity:propertyInfoArray.count];
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            NSLog(@"update 子表...");
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
            
            if (updateKey.length > 0) {
                [updateKey appendString:@","];
            }
            [updateKey appendFormat:@"%@=?", propertyInfo.name];
            [updateValues addObject:value];
        }
    }
    
    // 拼接updateSQL 语句  采用 replace 插入
    NSMutableString *updateSQL = [NSMutableString stringWithFormat:@"update %@ set %@ where %@=\'%@\'", [model.class tableName], updateKey, [model.class primaryKey], primaryKeyValue];
    
    result = [QORMTableHelper excuteUpdateWithSQL:updateSQL withArgumentsInArray:updateValues];
    
    return result;
}

@end
