//
//  ArrayList.h
//  wechat
//
//  Created by iprincewang on 2019/1/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

#ifndef ArrayList_h
#define ArrayList_h

#include <stdio.h>
#include "Array.h"

typedef struct {
    
    int increase;
    
    int elementTypeSize;
    
    int count;
    
    Array(elementType) elementArray[1];
    
}ArrayList;

struct AArrayList
{
    void (*init)(int elementTypeSize, ArrayList* outArrayList);
    void* (*add)(ArrayList* arrayList, void* element);
    void* (*insert)(ArrayList* arrayList, int index, void* element);
};

extern struct AArrayList AArrayList[1];

#define ArrayList(elementType) ArrayList;

/**
 * Initialize constant ArrayList
 */
#define AArrayList_Init(elementType, increase) \
    {                                          \
        increase,                              \
        sizeof(elementType),                   \
        0,                                     \
        {                                      \
            NULL,                              \
            0,                                 \
        },                                     \
    }


/**
 * Instead of AArrayList->get for quick iterate element
 * return element
 */
#define AArrayList_Get(arrayList, index, elementType) \
(AArrayList_GetData(arrayList, elementType))[index]

/**
 * Instead of AArrayList->set for quick set element
 */
#define AArrayList_Set(arrayList, index, element, elementType) \
AArrayList_Get(arrayList, index, elementType) = element


/**
 * Instead of AArrayList->get for quick iterate element
 * return elementPtr
 */
#define AArrayList_GetPtr(arrayList, index, elementType) \
(AArrayList_GetData(arrayList, elementType) + (index))





#endif /* ArrayList_h */
