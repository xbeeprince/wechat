//
//  Array.c
//  wechat
//
//  Created by iprincewang on 2019/1/8.
//  Copyright © 2019 Tencent. All rights reserved.
//
#include <stdlib.h>
#include "Array.h"

static Array* create(int elementTypeSize, int capacity)
{
    Array *array = (Array *)malloc(sizeof(Array) + elementTypeSize * capacity);
    array->data = (char *)array + sizeof(Array);
    array->capacity = capacity;
    
    return array;
}

struct AArray AArray[1] = {
    {
        .create = create
    }
};
