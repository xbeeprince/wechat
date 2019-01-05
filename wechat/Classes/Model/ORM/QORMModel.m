//
//  QORMModel.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMModel.h"
#import <objc/runtime.h>
#import "NSArray+toJson.h"
#import "NSDictionary+toJson.h"

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

#pragma mark -- NSCoding
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s",__FUNCTION__);
    if (self = [super init]) {
        Class cls = [self class];
        while (cls != [QORMModel class]) {//父类的属性也要遍历到
            unsigned int propsCount;
            objc_property_t *props = class_copyPropertyList(cls, &propsCount);
            
            for (int i = 0; i < propsCount; i++) {
                objc_property_t  property = props[i];
                NSString *key = [NSString stringWithUTF8String:property_getName(property)];
                id value = [aDecoder decodeObjectForKey:key];
                if (key && value) {
                    [self setValue:value forKey:key];
                }
            }
            
            free(props);
            cls = class_getSuperclass(cls);
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"%s",__FUNCTION__);
    Class cls = [self class];
    while (cls != [QORMModel class]) {//父类的属性也要遍历到
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(cls, &propsCount);
        
        for (int i = 0; i < propsCount; i++) {
            objc_property_t  property = props[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            id value = [self valueForKey:key];
            if (key && value) {
                [aCoder encodeObject:value forKey:key];
            }
        }
        
        free(props);
        cls = class_getSuperclass(cls);
    }
}

#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    NSLog(@"%s",__FUNCTION__);
    
    Class cls = [self class];
    __typeof(self) copyZone = [cls new];

    while (cls != [QORMModel class]) {//父类的属性也要遍历到
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(cls, &propsCount);
        
        for (int i = 0; i < propsCount; i++) {
            objc_property_t  property = props[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            id value = [self valueForKey:key];
            if (key && value) {
                [copyZone setValue:value forKey:key];
            }
        }
        
        free(props);
        cls = class_getSuperclass(cls);
    }
    
    return copyZone;
}

-(NSString *)description
{
    NSString *desc = [[self modelToDictionary] description];
    //解决中文的unicode码问题
    desc =  [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

-(NSDictionary *)modelToDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    Class cls = [self class];
    while (cls != [QORMModel class]) {//父类的属性也要遍历到
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList(cls, &propsCount);

        for (int i = 0; i < propsCount; i++) {
            objc_property_t  property = props[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            id value = [self valueForKey:key];
            if ([value isKindOfClass: [QORMModel class]]) {
                [dict setValue:[value modelToDictionary] forKey:key];
            }
            else if ([value isKindOfClass: [NSArray class]]) {
                
                [dict setValue:[value arrayToJson] forKey:key];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                
                [dict setValue:[value dictionaryToJson] forKey:key];
            }
            else{
                if (key && value) {
                    [dict setValue:value forKey:key];
                }
            }
        }

        free(props);
        cls = class_getSuperclass(cls);
    }

    return dict;
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
