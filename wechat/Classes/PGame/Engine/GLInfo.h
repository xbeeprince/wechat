//
//  GLInfo.h
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;
@import OpenGLES;

NS_ASSUME_NONNULL_BEGIN

@interface GLInfo : NSObject
@property (readonly, assign)GLfloat minPointSize;
@property (readonly, assign)GLfloat maxPointSize;

@property (readonly, assign)GLfloat minLineWidth;
@property (readonly, assign)GLfloat maxLineWidth;

@property (readonly, assign)GLint   maxVertexAttribs;
@property (readonly, assign)GLint   maxVertexUniformVectors;
@property (readonly, assign)GLint   maxVertexTextureImageUnits;
@property (readonly, assign)GLint   maxFragmentUniformVectors;
@property (readonly, assign)GLint   maxVaryingVectors;
@property (readonly, assign)GLint   maxCombinedTextureImageUnits;
@property (readonly, assign)GLint   maxTextureImageUnits;

@property (readonly, assign)float   version;

@end

NS_ASSUME_NONNULL_END
