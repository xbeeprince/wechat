//
//  QORMProperty.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMProperty.h"
#import "QORMHelper.h"
#import <UIKit/UIKit.h>
#import "QFileHandler.h"

@implementation QORMProperty

- (NSString *)codeValueToString
{
    NSString *returnValue = nil;
    id value = _value;
    if (value == nil) {
        returnValue = nil;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        returnValue = value;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        returnValue = [[QORMHelper numberFormatter] stringFromNumber:value];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        returnValue = [QORMHelper stringWithDate:value];
    }
    else if ([value isKindOfClass:[UIColor class]]) {
        UIColor *color = value;
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        returnValue = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", r, g, b, a];
    }
    else if ([value isKindOfClass:[UIImage class]]) {
        long random = arc4random();
        long date = [[NSDate date] timeIntervalSince1970];
        NSString *filename = [NSString stringWithFormat:@"img%ld%ld", date & 0xFFFFF, random & 0xFFF];
        NSData *datas = UIImageJPEGRepresentation(value, 1);
        [datas writeToFile:[QORMHelper getImagePathWithName:filename]
                atomically:YES];
        
        returnValue = filename;
    }
    else if ([value isKindOfClass:[NSData class]]) {
        long random = arc4random();
        long date = [[NSDate date] timeIntervalSince1970];
        NSString *filename = [NSString stringWithFormat:@"data%ld%ld", date & 0xFFFFF, random & 0xFFF];
        
        [value writeToFile:[QORMHelper getDataPathWithName:filename] atomically:YES];
        
        returnValue = filename;
    }
    else if ([value isKindOfClass:[NSValue class]]) {
        
    }
    else if ([value isKindOfClass:[NSURL class]]) {
        returnValue = [value absoluteString];
    }
    else {
        if ([value isKindOfClass:[NSArray class]]) {
            
        }
        else if ([value isKindOfClass:[NSSet class]]) {
            
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            
        }
        else {
            returnValue = [value string];
        }
    }
    return returnValue;
}

- (id)decodeValueFromString:(NSString *)string
{
    id returnValue = nil;
    if ([_type isEqualToString:@"NSString"]) {
        returnValue = string;
    }
    else if ([_type isEqualToString:@"NSNumber"]) {
        returnValue = [[QORMHelper numberFormatter] numberFromString:string];
    }
    else if ([_type isEqualToString:@"NSDate"]) {
        returnValue = [QORMHelper dateWithString:string];
    }
    else if ([_type isEqualToString:@"UIColor"]) {
        NSString *colorString = string;
        NSArray *array = [colorString componentsSeparatedByString:@","];
        float r, g, b, a;
        r = [[array objectAtIndex:0] floatValue];
        g = [[array objectAtIndex:1] floatValue];
        b = [[array objectAtIndex:2] floatValue];
        a = [[array objectAtIndex:3] floatValue];
        
        returnValue = [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    else if ([_type isEqualToString:@"UIImage"]) {
        NSString *filename = string;
        NSString *filepath = [QORMHelper getImagePathWithName:filename];
        if ([QFileHandler isFileExists:filepath]) {
            returnValue = [[UIImage alloc] initWithContentsOfFile:filepath];
        }
    }
    else if ([_type isEqualToString:@"NSData"]) {
        NSString *filename = string;
        NSString *filepath = [QORMHelper getDataPathWithName:filename];
        if ([QFileHandler isFileExists:filepath]) {
            returnValue = [NSData dataWithContentsOfFile:filepath];
        }
    }
    else if ([_type isEqualToString:@"NSValue"]) {
        
    }
    else if ([_type isEqualToString:@"NSURL"]) {
        NSString *urlString = string;
        returnValue = [NSURL URLWithString:urlString];
    }
    else if ([_type isEqualToString:@"NSArray"]) {
        
    }
    else if ([_type isEqualToString:@"NSSet"]) {
        
    }
    else if ([_type isEqualToString:@"NSDictionary"]) {
        
    }
    else if ([_type isEqualToString:@"char"]){
        returnValue = string;
    }
    else if ([_type isEqualToString:@"unsigned char"]){
        returnValue = string;
    }
    else if ([_type isEqualToString:@"int"]){
        int value = [string intValue];
        returnValue = [NSNumber numberWithInt:value];
    }
    else if ([_type isEqualToString:@"unsigned int"]){
        unsigned int value = [string intValue];
        returnValue = [NSNumber numberWithUnsignedInt:value];
    }
    else if ([_type isEqualToString:@"short"]){
        short value = [string intValue];
        returnValue = [NSNumber numberWithShort:value];
    }
    else if ([_type isEqualToString:@"unsigned short"]){
        unsigned short value = [string intValue];
        returnValue = [NSNumber numberWithUnsignedShort:value];
    }
    else if ([_type isEqualToString:@"long"]){
        long value = [string longLongValue];
        returnValue = [NSNumber numberWithLong:value];
    }
    else if ([_type isEqualToString:@"unsigned long"]){
        unsigned long value = [string longLongValue];
        returnValue = [NSNumber numberWithUnsignedLong:value];
    }
    else if ([_type isEqualToString:@"long long"]){
        long long value = [string longLongValue];
        returnValue = [NSNumber numberWithLongLong:value];
    }
    else if ([_type isEqualToString:@"unsigned long long"]){
        unsigned long long value = [string longLongValue];
        returnValue = [NSNumber numberWithUnsignedLongLong:value];
    }
    else if ([_type isEqualToString:@"NSInteger"]){
#if __LP64__ || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
        long value = [string longLongValue];
        returnValue = [NSNumber numberWithLong:value];
#else
        int value = [string intValue];
        returnValue = [NSNumber numberWithInt:value];
#endif
    }
    else if ([_type isEqualToString:@"NSUInteger"]){
#if __LP64__ || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
        unsigned long value = [string longLongValue];
        returnValue = [NSNumber numberWithUnsignedLong:value];
#else
        unsigned int value = [string intValue];
        returnValue = [NSNumber numberWithUnsignedInt:value];
#endif
    }
    else{
        NSLog(@"未能识别到类型！！！");
        returnValue = string;
    }
    return returnValue;
}



@end
