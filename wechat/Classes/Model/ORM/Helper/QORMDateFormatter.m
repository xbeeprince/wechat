//
//  QORMDateFormatter.m
//  wechat
//
//  Created by iprincewang on 2019/1/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QORMDateFormatter.h"

@interface QORMDateFormatter ()
@property (nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation QORMDateFormatter
- (id)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
        self.generatesCalendarDates = YES;
        self.dateStyle = NSDateFormatterNoStyle;
        self.timeStyle = NSDateFormatterNoStyle;
        self.AMSymbol = nil;
        self.PMSymbol = nil;
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        if (locale) {
            [self setLocale:locale];
        }
    }
    return self;
}
//防止在IOS5下 多线程 格式化时间时 崩溃
- (NSDate *)dateFromString:(NSString *)string
{
    [_lock lock];
    NSDate *date = [super dateFromString:string];
    [_lock unlock];
    return date;
}
- (NSString *)stringFromDate:(NSDate *)date
{
    [_lock lock];
    NSString *string = [super stringFromDate:date];
    [_lock unlock];
    return string;
}
@end
