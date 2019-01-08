//
//  Array.h
//  wechat
//
//  Created by iprincewang on 2019/1/8.
//  Copyright © 2019 Tencent. All rights reserved.
//

#ifndef Array_h
#define Array_h

#include <stdio.h>

typedef struct {
 
    void *data;
    int capacity;
    
}Array;

struct AArray {
    Array* (*create)(int elementTypeSize, int capacity);
    void* (*getData)(Array *array,int elementTypeSize);
};

extern struct AArray AArray[1];


#define AArray_GetData(array,elementType) \
    (elementType*)((array)->data)
#define AArray_Get(array,elementType,index) \
    (AArray_GetData(array,elementType))[index]
#define AArray_Set(array,elementType,index,element) \
(AArray_GetData(array,elementType))[index] = element


#define Array_GetPtr(array,elementType,index) \
    (AArray_GetData(array,elementType)) + (index)


#endif /* Array_h */
