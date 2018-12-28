//
//  QORMManager.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMManager.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"

@implementation QORMManager

+(instancetype)getInstance
{
    static QORMManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [QORMManager new];
    });
    return instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)saveWithModel:(QORMModel *)model
{
    NSArray *propertyInfoArray = [QORMPropertyParser parserPropertyInfoWithModel:model];
    
    for (QORMProperty *propertyInfo in propertyInfoArray) {
        if ([propertyInfo.value isKindOfClass: [QORMModel class]]) {
            NSLog(@"存储子表...");
            //继续存储子表操作
            QORMModel *infoModel = (QORMModel *)(propertyInfo.value);
            [self saveWithModel:infoModel];
        }
        else{
            //存储字段
            NSLog(@"存储字段...");
        }
    }
    
    NSLog(@"......");
}


@end
