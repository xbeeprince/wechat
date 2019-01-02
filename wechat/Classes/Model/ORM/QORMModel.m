//
//  QORMModel.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMModel.h"

@implementation QORMModel

+ (NSString *)primaryKey {
    return nil;
}

+ (NSString *)tableName {
    return NSStringFromClass(self);
}

+ (NSArray *)requiredProperties {
    return nil;
}

+ (NSArray *)ignoredProperties {
    return nil;
}

+ (NSArray *)indexedProperties {
    return nil;
}

+ (NSDictionary *)defaultPropertyValues {
    return nil;
}

#pragma mark - your can overwrite
- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"%s -> %@类中，key:[%@] 设置为nil了或者设置了 int 等基础类型，",__FUNCTION__, NSStringFromClass(self.class),key);
}
- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"%s -> %@类中，key:[%@] 的get方法没实现，",__FUNCTION__, NSStringFromClass(self.class),key);
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%s -> %@类中，key:[%@] 的set方法没实现，",__FUNCTION__, NSStringFromClass(self.class),key);
}

@end
