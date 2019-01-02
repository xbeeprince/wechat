//
//  QORMTableSearcher.h
//  wechat
//
//  Created by iprincewang on 2019/1/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QORMTableSearcher : NSObject

+ (NSArray *)searchWithPrimaryKeyValue:(NSString *)value withClassName:(NSString *)clsName;

@end

NS_ASSUME_NONNULL_END
