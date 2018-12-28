//
//  QORMPropertyParser.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMPropertyParser.h"
#import <objc/runtime.h>
#import "QORMProperty.h"
#import "QORMModel.h"


static NSString  *const type_char=@"char";
static NSString  *const type_int=@"int";
static NSString  *const type_short=@"short";
static NSString  *const type_long=@"long";
static NSString  *const type_unsigned_char=@"unsigned char";
static NSString  *const type_unsigned_int=@"unsigned int";
static NSString  *const type_unsigned_short=@"unsigned short";
static NSString  *const type_unsigned_long=@"unsigned long";
static NSString  *const type_unsigned_long_long=@"unsigned long long";
static NSString  *const type_float=@"float";
static NSString  *const type_double=@"double";
static NSString  *const type_BOOL=@"BOOL";
static NSString  *const type_void=@"void";
static NSString  *const type_char_X=@"char *";
static NSString  *const type_char_SEL=@"SEL";
static NSString  *const type_char_id=@"id";
static NSString  *const type_char_Class=@"Class";

static NSString *const type_NSArray=@"NSArray";
static NSString *const type_NSMutableArray=@"NSMutableArray";
static NSString *const type_NSObject=@"NSObject";
static NSString *const type_NSDictionary=@"NSDictionary";
static NSString *const type_NSMutalbleDictionary=@"NSMutalbleDictionary";
static NSString *const type_NSString=@"NSString";
static NSString *const type_NSMutalbleString=@"NSMutalbleString";
static NSString *const type_NSValue=@"NSValue";
static NSString *const type_NSNumber=@"NSNumber";

static NSString *const protocol_NSCopying=@"NSCopying";

static NSDictionary *_QORMTypeDict=nil;

@implementation QORMPropertyParser

+(void)load
{
    _QORMTypeDict=@{@"c":type_char,
                    @"i":type_int,
                    @"s":type_short,
                    @"q":type_long,
                    @"C":type_unsigned_char,
                    @"I":type_unsigned_int,
                    @"S":type_unsigned_short,
                    @"Q":type_unsigned_long,
                    @"Q":type_unsigned_long_long,
                    @"f":type_float,
                    @"d":type_double,
                    @"B":type_BOOL,
                    @"v":type_void,
                    @"*":type_char_X,
                    @":":type_char_SEL,
                    @"@":type_char_id,
                    @"#":type_char_Class};
}

+(NSArray *)parserPropertyInfoWithModel:(QORMModel *)model
{
    NSMutableArray *propertyInfoArray = [NSMutableArray new];
    {
        unsigned int propsCount;
        objc_property_t *props = class_copyPropertyList([model class], &propsCount);
        
        for (int i = 0; i < propsCount; i++) {
            objc_property_t  property = props[i];
            QORMProperty *propertyInfo = [QORMProperty new];
            propertyInfo.type = [self propertyType:property];
            propertyInfo.name = [self propertyName:property];
            propertyInfo.value = [model valueForKey: propertyInfo.name];
            
            [propertyInfoArray addObject:propertyInfo];
        }
    }
    return propertyInfoArray;
}

#pragma mark -- private

+(NSString *)propertyName:(objc_property_t)property{
    return [NSString stringWithUTF8String:property_getName(property)];
}

+(NSString *)propertyType:(objc_property_t)property{
    NSString *property_data_type = nil;
    const char * property_attr = property_getAttributes(property);
    if (property_attr[1] == '@') {
        char * occurs1 =  strchr(property_attr, '@');
        char * occurs2 =  strrchr(occurs1, '"');
        char dest_str[40]= {0};
        strncpy(dest_str, occurs1, occurs2 - occurs1);
        char * realType = (char *)malloc(sizeof(char) * 50);
        int i = 0, j = 0, len = (int)strlen(dest_str);
        for (; i < len; i++) {
            if ((dest_str[i] >= 'a' && dest_str[i] <= 'z') ||
                (dest_str[i] >= 'A' && dest_str[i] <= 'Z')) {
                realType[j++] = dest_str[i];
            }
        }
        realType[j] = '\0';
        property_data_type = [NSString stringWithUTF8String:realType];
        free(realType);
    }else {
        char t = property_attr[1];
        NSString *typeStr = [NSString stringWithFormat:@"%c",t];
        if (typeStr) {
            property_data_type = _QORMTypeDict[typeStr];
        }
    }
    return property_data_type;
}

@end
