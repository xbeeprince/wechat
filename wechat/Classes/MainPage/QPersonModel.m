//
//  QPersonModel.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QPersonModel.h"

@implementation QPersonModel

+ (NSString *)primaryKey {
    return @"cardId";
}

+ (NSArray *)ignoredProperties {
    return @[@"date"];
}

@end
