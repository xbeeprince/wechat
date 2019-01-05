//
//  NSDictionary+toJson.m
//  wechat
//
//  Created by tina on 2019/1/5.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "NSDictionary+toJson.h"
#import "QORMModel.h"
#import "NSArray+toJson.h"

@implementation NSDictionary (toJson)

-(NSDictionary *)dictionaryToJson
{
    NSMutableDictionary *returnDict = [NSMutableDictionary new];
    
    for (NSString *key in self.allKeys) {
        id value = [self valueForKey:key];
        if ([value isKindOfClass: [QORMModel class]]) {
            [returnDict setValue:[value modelToDictionary] forKey:key];
        }
        else if ([value isKindOfClass: [NSArray class]]) {
            [returnDict setValue:[value arrayToJson] forKey:key];
        }
        else if ([value isKindOfClass: [NSDictionary class]]) {
            [returnDict setValue:[value dictionaryToJson] forKey:key];
        }
        else {
            [returnDict setValue:value forKey:key];
        }
    }
    
    return returnDict;
}

// 只需要在分类中,重写这个方法的实现,不需要导入分类文件就会生效
- (NSString *)descriptionWithLocale:(id)locale
{
    // 定义用于拼接字符串的容器
    NSMutableString *stringM = [NSMutableString string];
    
    // 拼接开头
    [stringM appendString:@"{\n"];
    
    // 遍历字典,拼接内容
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringM appendFormat:@"\t%@ = %@;\n",key,obj];
    }];
    
    // 拼接结尾
    [stringM appendString:@"}\n"];
    
    return stringM;
}

@end
