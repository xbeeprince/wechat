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
#import "QORMHelper.h"
#import "QORMTableInserter.h"
#import "QORMTableSearcher.h"

@implementation QORMTableUpdater

+ (BOOL)updateWithModel:(QORMModel *)model
{
    BOOL result = NO;
    result = [self updateWithModel:model withNeedUpdatePropertyArray:nil withIgnorUpdatePropertyArray:nil];
    return result;
}

+ (BOOL)updateWithModel:(QORMModel *)model withNeedUpdatePropertyArray:(NSArray *)updateArray withIgnorUpdatePropertyArray:(NSArray *)ignorArray
{
    BOOL result = NO;
    NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:model];
    QORMModel *result_model = [QORMTableSearcher searchWithPrimaryKeyValue:primaryKeyValue withClassName: NSStringFromClass(model.class)];
    if (result_model == nil) {
        NSLog(@"数据库中不存在此记录，将进行 insert 操作");
        //插入
        result = [QORMTableInserter insertWithModel:model];
        return result;
    }
    
    NSLog(@"进行 update 操作");
    
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    NSMutableString *updateKey = [NSMutableString string];
    NSMutableArray *updateValues = [NSMutableArray arrayWithCapacity:propertyInfoArray.count];
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        
        BOOL need = [QORMTableHelper isNeedWithProperty:propertyInfo withNeedInsertPropertyArray:updateArray withIgnorInsertPropertyArray:ignorArray];
        if (need == NO) {
            continue;
        }
        
        BOOL required = [QORMTableHelper isNeedWithProperty:propertyInfo withModel:model];
        if (required == NO) {
            continue;
        }
        
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            NSLog(@"update 子表...");
            QORMModel *infoModel = (QORMModel *)(propertyInfo.value);
            NSString *primaryKeyValue = [QORMTableHelper primaryKeyValueWithModel:infoModel];
            if (primaryKeyValue == nil) {
                NSAssert(NO,@"子表的primaryKey不能为nil ！！！");
                return NO;
            }
            NSString *value = primaryKeyValue;
            if (value == nil) {
                continue;
            }
            
            if (updateKey.length > 0) {
                [updateKey appendString:@","];
            }
            [updateKey appendFormat:@"%@=?", propertyInfo.name];
            [updateValues addObject:value];
            
            //更新子表
            [self updateWithModel:infoModel];
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
                        [self updateWithModel:object];
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
            NSString *value = [QORMHelper arrayToJsonString:tmpArray];
            if (updateKey.length > 0) {
                [updateKey appendString:@","];
            }
            [updateKey appendFormat:@"%@=?", propertyInfo.name];
            [updateValues addObject:value];
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
                        [self updateWithModel:object];
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
            NSString *value = [QORMHelper arrayToJsonString:tmpArray];
            if (updateKey.length > 0) {
                [updateKey appendString:@","];
            }
            [updateKey appendFormat:@"%@=?", propertyInfo.name];
            [updateValues addObject:value];
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
