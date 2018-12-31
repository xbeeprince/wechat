//
//  QORMTableHelper.h
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

NS_ASSUME_NONNULL_BEGIN

@interface QORMTableHelper : NSObject

+ (BOOL)excuteUpdateWithSQL:(NSString *)sql;

+ (FMResultSet *)excuteQueryWithSQL:(NSString *)sql;

+ (BOOL)isExistTableWithName:(NSString *)tableName;

+ (BOOL)isExistColumn:(NSString *)columnName inTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
