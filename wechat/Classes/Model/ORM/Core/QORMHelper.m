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
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
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
    NSString *dir = [NSString stringWithFormat:@"dbimg/%@", NSStringFromClass(self)];
    return [QFileHandler getPathForDocuments:filename inDir:dir];
}
+ (NSString *)getDataPathWithName:(NSString *)filename
{
    NSString *dir = [NSString stringWithFormat:@"dbdata/%@", NSStringFromClass(self)];
    return [QFileHandler getPathForDocuments:filename inDir:dir];
}

@end
