//
//  QTeacherModel.h
//  wechat
//
//  Created by iprincewang on 2019/1/3.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QTeacherModel : QPersonModel
@property (nonatomic, strong) NSArray *students;

@end

NS_ASSUME_NONNULL_END
