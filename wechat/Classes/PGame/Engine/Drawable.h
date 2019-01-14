//
//  Drawable.h
//  wechat
//
//  Created by iprincewang on 2019/1/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Drawable : NSObject

@property (nonatomic, assign) float width;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) float positionX;
@property (nonatomic, assign) float positionY;
@property (nonatomic, assign) float positionZ;

@property (nonatomic, assign) float     scaleX;
@property (nonatomic, assign) float     scaleY;
@property (nonatomic, assign) float     scaleZ;

@property (nonatomic, assign) float     rotationZ;

/*
 
//Cached MVP matrix when property changed will update

Matrix4   mvpMatrix    [1];


//Cached model matrix when property changed will update

Matrix4   modelMatrix  [1];


//Cached inverse model matrix

Matrix4   inverseMatrix[1];


//Identifier property has changed

int       state;

 */

@end

NS_ASSUME_NONNULL_END
