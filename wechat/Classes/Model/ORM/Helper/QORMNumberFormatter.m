//
//  QORMNumberFormatter.m
//  wechat
//
//  Created by iprincewang on 2019/1/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QORMNumberFormatter.h"

@implementation QORMNumberFormatter

- (NSString *)stringFromNumber:(NSNumber *)number
{
    NSString *string = [number stringValue];
    if (!string) {
        string = [NSString stringWithFormat:@"%lf", [number doubleValue]];
    }
    return string;
}
- (NSNumber *)numberFromString:(NSString *)string
{
    NSNumber *number = [super numberFromString:string];
    if (!number) {
        number = @(string.doubleValue);
    }
    return number;
}


@end
