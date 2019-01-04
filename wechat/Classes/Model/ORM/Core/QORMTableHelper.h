//
//  QORMTableHelper.h
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;
@class QORMModel;
@class QORMProperty;
NS_ASSUME_NONNULL_BEGIN

@interface QORMTableHelper : NSObject

+ (BOOL)excuteUpdateWithSQL:(NSString *)sql;

+ (BOOL)excuteUpdateWithSQL:(NSString *)sql withArgumentsInArray:(NSArray *)array;

+ (FMResultSet *)excuteQueryWithSQL:(NSString *)sql;

+ (BOOL)isExistTableWithName:(NSString *)tableName;

+ (BOOL)isExistColumn:(NSString *)columnName inTable:(NSString *)tableName;

+ (NSString *)primaryKeyValueWithModel:(QORMModel *)model;

+ (BOOL)isNeedWithProperty:(QORMProperty *)propertyInfo withNeedInsertPropertyArray:(NSArray *)updateArray withIgnorInsertPropertyArray:(NSArray *)ignorArray;

+ (BOOL)isNeedWithProperty:(QORMProperty *)propertyInfo withModel:(QORMModel *)model;

@end

NS_ASSUME_NONNULL_END
