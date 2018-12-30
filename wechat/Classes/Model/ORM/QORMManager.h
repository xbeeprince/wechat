//
//  QORMManager.h
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN
@class QORMModel;

@interface QORMManager : NSObject

+(instancetype)getInstance;

-(void)saveWithModel:(QORMModel *)model;

-(FMDatabaseQueue *)getDatabaseQueue;

@end

NS_ASSUME_NONNULL_END
