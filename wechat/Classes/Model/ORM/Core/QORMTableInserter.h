//
//  QORMTableInserter.h
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QORMModel;

NS_ASSUME_NONNULL_BEGIN

@interface QORMTableInserter : NSObject

+ (BOOL)insertWithModel:(QORMModel *)model;

@end

NS_ASSUME_NONNULL_END
