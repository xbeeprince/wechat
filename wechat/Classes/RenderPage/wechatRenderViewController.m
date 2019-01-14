//
//  wechatRenderViewController.m
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "wechatRenderViewController.h"
#import "GameManager.h"

@implementation wechatRenderViewController
-(instancetype)init
{
    if (self = [super init]) {
        self.preferredFramesPerSecond = 15;
    }
    return self;
}

-(void)update
{
    [[GameManager getInstance] gameLoop];
}

@end
