//
//  Graphics.m
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "Graphics.h"
#import "GLInfo.h"

@interface Graphics ()
@property (nonatomic, assign)BOOL useVao;
@property (nonatomic, assign)BOOL useVbo;
@property (nonatomic, strong)GLInfo *glInfo;
@end

@implementation Graphics

-(instancetype)init
{
    if (self = [super init]) {
        [self initGLInfo];
    }
    return self;
}

-(void)initGLInfo
{
    _glInfo = [GLInfo new];
}

- (void)setUseVao:(BOOL)useVao
{
    if (useVao && _glInfo.version > 2.0) {
        
    }
    else{
        
    }
}


-(BOOL)isUseVao
{
    return _useVao;
}

@end
