//
//  QORMHelper.m
//  wechat
//
//  Created by iprincewang on 2019/1/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QORMHelper.h"
#import "QORMNumberFormatter.h"
#import "QORMDateFormatter.h"
#import "QFileHandler.h"

@implementation QORMHelper

#pragma mark -- private
+ (NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[QORMNumberFormatter alloc] init];
    });
    return numberFormatter;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[QORMDateFormatter alloc] init];
    });
    return format;
}
+ (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [self dateFormatter];
    NSString *datestr = [formatter stringFromDate:date];
    if (datestr.length > 19) {
        datestr = [datestr substringToIndex:19];
    }
    return datestr;
}
+ (NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter *formatter = [self dateFormatter];
    NSDate *date = [formatter dateFromString:str];
    return date;
}

+ (NSString *)getImagePathWithName:(NSString *)filename
{
    NSString *dir = [NSString stringWithFormat:@"QORMDatabaseImage/%@", NSStringFromClass(self)];
    return [QFileHandler getPathForDocuments:filename inDir:dir];
}
+ (NSString *)getDataPathWithName:(NSString *)filename
{
    NSString *dir = [NSString stringWithFormat:@"QORMDatabaseData/%@", NSStringFromClass(self)];
    return [QFileHandler getPathForDocuments:filename inDir:dir];
}

#pragma mark -- 字典、字符串互转
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJsonString:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark -- 数组、字符串互转
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

+ (NSString*)arrayToJsonString:(NSArray *)array
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
