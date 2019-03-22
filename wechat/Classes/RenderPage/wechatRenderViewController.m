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
    
    for (int i = 0; i<10000000; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zhaoliying@2x" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile: path];
        if (image) {
            NSLog(@"find...");
        }
    }
    
}

@end
