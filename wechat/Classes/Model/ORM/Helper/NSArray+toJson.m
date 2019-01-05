//
//  NSArray+toJson.m
//  wechat
//
//  Created by tina on 2019/1/5.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "NSArray+toJson.h"
#import "QORMModel.h"
#import "NSDictionary+toJson.h"

@implementation NSArray (toJson)

-(NSArray *)arrayToJson
{
    NSMutableArray *returnArray = [NSMutableArray new];
    for (id object in self) {
        if ([object isKindOfClass: [QORMModel class]]) {
            [returnArray addObject: [object modelToDictionary]];
        }
        else if ([object isKindOfClass: [NSArray class]]) {
            [returnArray addObject: [object arrayToJson]];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [returnArray addObject: [object dictionaryToJson]];
        }
        else {
            [returnArray addObject:object];
        }
    }
    return returnArray;
}

// 只需要在分类中,重写这个方法的实现,不需要导入分类文件就会生效
- (NSString *)descriptionWithLocale:(id)locale
{
    // 定义用于拼接字符串的容器
    NSMutableString *stringM = [NSMutableString string];
    
    // 拼接开头
    [stringM appendString:@"(\n"];
    
    // 拼接中间的数组元素
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [stringM appendFormat:@"\t%@,\n",obj];
        
    }];
    
    // 拼接结尾
    [stringM appendString:@")\n"];
    
    return stringM;
}

@end
