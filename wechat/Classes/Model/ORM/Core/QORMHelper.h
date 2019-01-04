//
//  QORMHelper.h
//  wechat
//
//  Created by iprincewang on 2019/1/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#ifdef NSLog
#define QORMModelWarningLog(...) NSLog(@"#QORMModelLog Warning:\n" , ##__VA_ARGS__);
#define QORMModelErrorLog(...) NSLog(@"#QORMModelLog Error:\n" , ##__VA_ARGS__);
#else
#define QORMModelWarningLog(...) NSLog(@"\n#QORMModelLog Warning: %s  [Line %d] \n" , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define QORMModelErrorLog(...) NSLog(@"\n#QORMModelLog ERROR: %s  [Line %d] \n" , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif
#else
#define QORMTableErrorLog(...)
#endif

@interface QORMHelper : NSNumberFormatter

+ (NSString *)databasePath;

+ (NSNumberFormatter *)numberFormatter;

+ (NSDateFormatter *)dateFormatter;

+ (NSString *)stringWithDate:(NSDate *)date;

+ (NSDate *)dateWithString:(NSString *)str;

+ (NSString *)getImagePathWithName:(NSString *)filename;

+ (NSString *)getDataPathWithName:(NSString *)filename;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dictionaryToJsonString:(NSDictionary *)dic;

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

+ (NSString*)arrayToJsonString:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
