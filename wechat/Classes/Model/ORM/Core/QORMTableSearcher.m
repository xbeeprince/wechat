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

@implementation QORMTableSearcher

+ (NSArray *)searchWithPrimaryKeyValue:(NSString *)value withClassName:(NSString *)clsName
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
    return tmpArray;
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
                    id value = [propertyInfo decodeValueFromString:colomnValue];
                    [model setValue:value forKey:colomnName];
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
