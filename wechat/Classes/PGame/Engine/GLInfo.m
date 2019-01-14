//
//  GLInfo.m
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GLInfo.h"

@implementation GLInfo

-(instancetype)init
{
    if (self = [super init]) {
        [self initOpenGL];
    }
    return self;
}

-(void)initOpenGL
{
    char* vendor     = (char*) glGetString(GL_VENDOR);
    char* renderer   = (char*) glGetString(GL_RENDERER);
    char* version    = (char*) glGetString(GL_VERSION);
    char* extensions = (char*) glGetString(GL_EXTENSIONS);
    
    NSLog(@"vendor = %s \n renderer = %s \n version = %s \n extensions = %s",vendor, renderer, version, extensions);
    
    if(strstr(version, "OpenGL ES 3.") != NULL)
    {
        _version = 3.0f;
    }
    else
    {
        _version = 2.0f;
    }
    
    GLfloat range[2];
    glGetFloatv  (GL_ALIASED_POINT_SIZE_RANGE,          range);
    _minPointSize = range[0];
    _maxPointSize = range[1];
    
    glGetFloatv  (GL_ALIASED_LINE_WIDTH_RANGE,          range);
    _minLineWidth = range[0];
    _maxLineWidth = range[1];
    
    glGetIntegerv(GL_MAX_VERTEX_ATTRIBS,               &_maxVertexAttribs);
    glGetIntegerv(GL_MAX_VERTEX_UNIFORM_VECTORS,       &_maxVertexUniformVectors);
    glGetIntegerv(GL_MAX_FRAGMENT_UNIFORM_VECTORS,     &_maxFragmentUniformVectors);
    glGetIntegerv(GL_MAX_VARYING_VECTORS,              &_maxVaryingVectors);
    glGetIntegerv(GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS,   &_maxVertexTextureImageUnits);
    glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, &_maxCombinedTextureImageUnits);
    glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS,          &_maxTextureImageUnits);
}

@end
