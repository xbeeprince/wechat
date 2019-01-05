//
//  QORMModel.h
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QORMModel : NSObject<NSCoding,NSCopying>

+ (NSString *)primaryKey;

+ (NSString *)tableName;

+ (NSArray *)requiredProperties;

+ (NSArray *)ignoredProperties;

+ (NSArray *)indexedProperties;

+ (NSDictionary *)defaultPropertyValues;

- (NSDictionary *)modelToDictionary;

@end

NS_ASSUME_NONNULL_END
