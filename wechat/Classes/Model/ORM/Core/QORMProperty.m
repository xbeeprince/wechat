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
        returnValue = [[QORMHelper dateFormatter] dateFromString:string];
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
        
    }
    else if ([_type isEqualToString:@"int"]){
        
    }
    else if ([_type isEqualToString:@"short"]){
        
    }
    else if ([_type isEqualToString:@"long"]){
        
    }
    
    
    return returnValue;
}



@end
