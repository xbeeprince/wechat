//
//  GameDefine.h
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#ifndef GameDefine_h
#define GameDefine_h

//单例宏
#define Single_Interface(class)  + (class *)getInstance;

// .m里面调用
#define Single_implementation(class) \
static class *_instance; \
\
+ (class *)getInstance \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

#endif /* GameDefine_h */
