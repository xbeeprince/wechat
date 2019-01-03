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

/**
 整体插入model
 
 @param model 需要插入的model
 @return 返回插入结果
 */
+ (BOOL)insertWithModel:(QORMModel *)model;

/**
 自定义插入或不插入指定的部分字段，updateArray 与 ignorArray 互斥，优先信任 updateArray，若为nil，则 信任 ignorArray
 
 @param model 需要插入的model
 @param updateArray 需要插入的字段属性集合
 @param ignorArray 不需要插入的字段属性集合
 @return 返回插入结果
 */
+ (BOOL)insertWithModel:(QORMModel *)model withNeedInsertPropertyArray:(nullable NSArray *)updateArray withIgnorInsertPropertyArray:(nullable NSArray *)ignorArray;

@end

NS_ASSUME_NONNULL_END
