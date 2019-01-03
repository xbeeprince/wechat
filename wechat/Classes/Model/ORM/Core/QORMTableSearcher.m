//
//  QORMTableSeacher.m
//  wechat
//
//  Created by iprincewang on 2019/1/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QORMTableSearcher.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"
#import "QORMManager.h"
#import "QORMTableHelper.h"
#import "QORMProperty.h"
#import "QORMHelper.h"

@implementation QORMTableSearcher

+ (QORMModel *)searchWithPrimaryKeyValue:(NSString *)value withClassName:(NSString *)clsName
{
    NSString *tableName = [NSClassFromString(clsName) tableName];
    NSString *primaryKey = [NSClassFromString(clsName) primaryKey];
    if ([QORMTableHelper isExistTableWithName:tableName] == NO) {
        NSLog(@"数据库中不存在此表：%@",tableName);
        return nil;
    }
    
    NSMutableString *query = [NSMutableString stringWithFormat:@"select * from %@ where %@=\'%@\'", tableName,primaryKey,value];
    FMResultSet *set = [QORMTableHelper excuteQueryWithSQL:query];
    NSMutableArray *tmpArray = [NSMutableArray new];
    while ([set next]) {
        QORMModel *model = [self createModelWithFMResultSet:set withClassName:clsName];
        [tmpArray addObject:model];
    }
    return [tmpArray firstObject];
}

+ (QORMModel *)createModelWithFMResultSet:(FMResultSet *)set withClassName:(NSString *)clsName
{
    QORMModel *model = [NSClassFromString(clsName) new];
    for (int index = 0; index < [set columnCount]; index++) {
        NSString *colomnName = [set columnNameForIndex:index];
        
        if (colomnName) {
            NSString *colomnValue = [set stringForColumn:colomnName];
            if (colomnValue) {
                QORMProperty *propertyInfo = [self getPropertyWithModel:model withColomnName:colomnName];
                if (propertyInfo) {
                    Class cla = NSClassFromString(propertyInfo.type);
                    id tmpObject = [cla new];
                    if ([tmpObject isKindOfClass: [QORMModel class]]) {
                        //查子表
                        QORMModel *valueModel = [self searchWithPrimaryKeyValue:colomnValue withClassName:propertyInfo.type];
                        [model setValue:valueModel forKey:colomnName];
                    }
                    else if ([tmpObject isKindOfClass: [NSArray class]]) {
                        NSMutableArray *tmpVauleArray = [NSMutableArray new];
                        NSArray *primaryKeyValueList = [QORMHelper arrayWithJsonString:colomnValue];
                        for (NSString *dictString in primaryKeyValueList) {
                            NSDictionary *dict = [QORMHelper dictionaryWithJsonString:dictString];
                            if (dict) {
                                NSString *className = [dict valueForKey: @"class"];
                                id tmpValue = [dict valueForKey: @"value"];
                                Class cla = NSClassFromString(className);
                                if ([[cla new] isKindOfClass: [QORMModel class]]) {
                                    QORMModel *valueModel = [self searchWithPrimaryKeyValue:tmpValue withClassName:className];
                                    [tmpVauleArray addObject:valueModel];
                                }
                                else{
                                    [tmpVauleArray addObject:tmpValue];
                                }
                            }
                        }
                        [model setValue:tmpVauleArray forKey:colomnName];
                    }
                    else if ([tmpObject isKindOfClass: [NSDictionary class]]) {
                        NSMutableDictionary *tmpVauleDict = [NSMutableDictionary new];
                        NSArray *primaryKeyValueList = [QORMHelper arrayWithJsonString:colomnValue];
                        for (NSString *dictString in primaryKeyValueList) {
                            NSDictionary *dict = [QORMHelper dictionaryWithJsonString:dictString];
                            if (dict) {
                                NSString *className = [dict valueForKey: @"class"];
                                NSString *key = [dict valueForKey: @"key"];
                                id tmpValue = [dict valueForKey: @"value"];
                                
                                Class cla = NSClassFromString(className);
                                if ([[cla new] isKindOfClass: [QORMModel class]]) {
                                    QORMModel *valueModel = [self searchWithPrimaryKeyValue:tmpValue withClassName:className];
                                    [tmpVauleDict setValue:valueModel forKey:key];
                                }
                                else{
                                    [tmpVauleDict setValue:tmpValue forKey:key];
                                }
                            }
                        }
                        [model setValue:tmpObject forKey:colomnName];
                    }
                    else {
                        id value = [propertyInfo decodeValueFromString:colomnValue];
                        [model setValue:value forKey:colomnName];
                    }
                }
            }
        }
    }
    return model;
}

+ (QORMProperty *)getPropertyWithModel:(QORMModel *)model withColomnName:(NSString *)name
{
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        if ([name isEqualToString:propertyInfo.name]) {
            return propertyInfo;
        }
    }
    return nil;
}

@end
