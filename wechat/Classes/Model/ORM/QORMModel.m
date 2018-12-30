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

#pragma mark -- private
-(void)parser
{
    
}

@end
