//
//  ArrayList.c
//  wechat
//
//  Created by iprincewang on 2019/1/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

#include "ArrayList.h"
#include <string.h>
#include <stdlib.h>

static inline void addCapacity(ArrayList *arrayList, int increase)
{
    void *data = realloc(arrayList->elementArray->data, (increase + arrayList->elementArray->capacity) * arrayList->elementTypeSize);
    
    arrayList->elementArray->data = data;
    arrayList->elementArray->capacity += increase;
}

static void* GetAdd(ArrayList* arrayList)
{
    if (arrayList->count == arrayList->elementArray->capacity) {
        addCapacity(arrayList, arrayList->increase);
    }
    
    int count = arrayList->count;
    arrayList->count++;
    
    return (char *)arrayList->elementArray->data + arrayList->elementTypeSize * count;
}

static void* GetInsert(ArrayList* arrayList, int index)
{
    if (arrayList->count == arrayList->elementArray->capacity) {
        addCapacity(arrayList, arrayList->increase);
    }
    
    char* from = (char *)arrayList->elementArray->data + arrayList->elementTypeSize * index;
    char* to = from + arrayList->elementTypeSize;
    
    memmove(to,from,arrayList->elementTypeSize * (arrayList->count - index));
    
    return from;
}

static void* add(ArrayList* arrayList, void* element)
{
    return memcpy(GetAdd(arrayList), element, arrayList->elementTypeSize);
}

static void* insert(ArrayList* arrayList, int index, void* element)
{
    return memcpy(GetInsert(arrayList, index), element, arrayList->elementTypeSize);
}

static inline void initArrayList(int elementTypeSize, ArrayList* arrayList)
{
    arrayList->elementArray->data = NULL;
    arrayList->elementArray->capacity = 0;
    arrayList->elementTypeSize = elementTypeSize;
    arrayList->count = 0;
    arrayList->increase = 20;
}

static void init(int elementTypeSize, ArrayList* outArrayList)
{
    initArrayList(elementTypeSize, outArrayList);
}

struct AArrayList AArrayLis[1] = {
    {
        .init = init,
        .add = add,
        .insert = insert
    }
};
