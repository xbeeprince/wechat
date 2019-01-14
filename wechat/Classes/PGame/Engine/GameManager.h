//
//  GameManager.h
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameManager : NSObject
Single_Interface(GameManager);

-(void)gameLoop;

@end

NS_ASSUME_NONNULL_END
