//
//  QORMTableCreater.h
//  wechat
//
//  Created by iprincewang on 2018/12/29.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QORMModel;

@interface QORMTableCreater : NSObject

+(BOOL)createTableWithModel:(QORMModel *)model;

@end

NS_ASSUME_NONNULL_END
