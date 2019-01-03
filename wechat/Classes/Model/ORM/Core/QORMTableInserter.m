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
#import "QORMTableCreater.h"
#import "QORMTableSearcher.h"
#import "QORMTableUpdater.h"
#import "QORMHelper.h"

@implementation QORMTableInserter

+ (BOOL)insertWithModel:(QORMModel *)model
{
    BOOL result = NO;
    result = [self insertWithModel:model withNeedInsertPropertyArray:nil withIgnorInsertPropertyArray:nil];
    return result;
}

+ (BOOL)insertWithModel:(QORMModel *)model withNeedInsertPropertyArray:(NSArray *)updateArray withIgnorInsertPropertyArray:(NSArray *)ignorArray
{
    BOOL result = NO;
    
    NSString *tableName = [model.class tableName];
    if ([QORMTableHelper isExistTableWithName:tableName] == NO) {
        NSLog(@"数据库中不存在此表：%@，将先创建表",tableName);
        result = [QORMTableCreater createTableWithModel:model];
        if (result == NO) {
            return result;
        }
    }
    
    NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:model];
    QORMModel *result_model = [QORMTableSearcher searchWithPrimaryKeyValue:primaryKeyValue withClassName: NSStringFromClass(model.class)];
    if (result_model) {
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
        
        BOOL need = [QORMTableHelper isNeedWithProperty:propertyInfo withNeedInsertPropertyArray:updateArray withIgnorInsertPropertyArray:ignorArray];
        if (need == NO) {
            continue;
        }
        
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            NSLog(@"insert 子表...");
            //继续存储子表操作
            QORMModel *infoModel = (QORMModel *)(propertyInfo.value);
            NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:infoModel];
            if (primaryKeyValue == nil) {
                NSAssert(NO,@"子表的primaryKey不能为nil ！！！");
            }
            NSString *value = primaryKeyValue;
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
            
            //子表插入
            [self insertWithModel:infoModel];
        }
        else if ([propertyInfo.value isKindOfClass: [NSArray class]]) {
        
            NSMutableArray *tmpArray = [NSMutableArray new];
            for (id object in propertyInfo.value) {
                if ([object isKindOfClass: [QORMModel class]]) {
                    //继续存储子表操作
                    QORMModel *infoModel = (QORMModel *)(object);
                    NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:infoModel];
                    if (primaryKeyValue == nil) {
                        NSAssert(NO,@"子表的primaryKey不能为nil ！！！");
                    }
                    
                    NSDictionary *dict = @{@"class":NSStringFromClass(infoModel.class),@"value":primaryKeyValue};
                    NSString *tmpValue = [QORMHelper dictionaryToJsonString:dict];
                    if (tmpValue) {
                        [tmpArray addObject:tmpValue];
                        [self insertWithModel:object];
                    }
                }
                else{
                    NSDictionary *dict = @{@"class":NSStringFromClass([object class]),@"value":object};
                    NSString *tmpValue = [QORMHelper dictionaryToJsonString:dict];
                    if (tmpValue) {
                        [tmpArray addObject:tmpValue];
                    }
                }
            }
            
            if (insertKey.length > 0) {
                [insertKey appendString:@","];
                [insertValuesString appendString:@","];
            }
            
            [insertKey appendString:propertyInfo.name];
            [insertValuesString appendString:@"?"];
            
            NSString *value = [QORMHelper arrayToJsonString:tmpArray];
            [insertValues addObject:value];
        }
        else if ([propertyInfo.value isKindOfClass: [NSDictionary class]]) {
            
            NSMutableArray *tmpArray = [NSMutableArray new];
            NSDictionary *dictionary = (NSDictionary *)propertyInfo.value;
            for (NSString *key in dictionary.allKeys) {
                id object = [dictionary valueForKey:key];
                if ([object isKindOfClass: [QORMModel class]]) {
                    //继续存储子表操作
                    QORMModel *infoModel = (QORMModel *)(object);
                    NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:infoModel];
                    if (primaryKeyValue == nil) {
                        NSAssert(NO,@"子表的primaryKey不能为nil ！！！");
                    }
                    
                    NSDictionary *dict = @{@"class":NSStringFromClass(infoModel.class),@"key":key,@"value":primaryKeyValue};
                    NSString *tmpValue = [QORMHelper dictionaryToJsonString:dict];
                    if (tmpValue) {
                        [tmpArray addObject:tmpValue];
                        [self insertWithModel:object];
                    }
                }
                else{
                    NSDictionary *dict = @{@"class":NSStringFromClass([object class]),@"key":key,@"value":object};
                    NSString *tmpValue = [QORMHelper dictionaryToJsonString:dict];
                    if (tmpValue) {
                        [tmpArray addObject:tmpValue];
                    }
                }
            }
            
            if (insertKey.length > 0) {
                [insertKey appendString:@","];
                [insertValuesString appendString:@","];
            }
            
            [insertKey appendString:propertyInfo.name];
            [insertValuesString appendString:@"?"];
            
            NSString *value = [QORMHelper arrayToJsonString:tmpArray];
            [insertValues addObject:value];
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
