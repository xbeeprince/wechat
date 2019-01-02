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
        else if ([value isKindOfClass:[NSDictionary class]]) {
            
        }
        else {
            
        }
    }
    return returnValue;
}

- (id)decodeValueFromString
{
    id returnValue = nil;
    
    return returnValue;
}



@end
