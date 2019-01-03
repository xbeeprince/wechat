//
//  QORMTableUpdater.h
//  wechat
//
//  Created by tina on 2018/12/31.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QORMModel;
NS_ASSUME_NONNULL_BEGIN

@interface QORMTableUpdater : NSObject

/**
 整体更新model

 @param model 需要更新的model
 @return 返回更新结果
 */
+ (BOOL)updateWithModel:(QORMModel *)model;

/**
 自定义更新或不更新指定的部分字段，updateArray 与 ignorArray 互斥，优先信任 updateArray，若为nil，则 信任 ignorArray

 @param model 需要更新的model
 @param updateArray 需要更新的字段属性集合
 @param ignorArray 不需要更新的字段属性集合
 @return 返回更新结果
 */

+ (BOOL)updateWithModel:(QORMModel *)model withNeedUpdatePropertyArray:(nullable NSArray *)updateArray withIgnorUpdatePropertyArray:(nullable NSArray *)ignorArray;

@end

NS_ASSUME_NONNULL_END
