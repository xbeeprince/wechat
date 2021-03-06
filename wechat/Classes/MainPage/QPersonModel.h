//
//  QPersonModel.h
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMModel.h"
#import "QORMHelper.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPersonModel : QORMModel

@property (nonatomic, strong) NSString *cardId;

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int age;

@property (nonatomic, assign) int sex;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) QPersonModel *friendPerson;

@end

NS_ASSUME_NONNULL_END
