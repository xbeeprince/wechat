//
//  QORMProperty.h
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QORMProperty : NSObject

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) id value;

-(NSString *)codeValueToString;

- (id)decodeValueFromString;

@end

NS_ASSUME_NONNULL_END
