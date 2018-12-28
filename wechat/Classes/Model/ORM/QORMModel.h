//
//  QORMModel.h
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QORMModel : NSObject

+ (NSString *)primaryKey;

+ (NSArray *)requiredProperties;

+ (NSArray *)ignoredProperties;

+ (NSArray *)indexedProperties;

+ (NSDictionary *)defaultPropertyValues;

@end

NS_ASSUME_NONNULL_END
