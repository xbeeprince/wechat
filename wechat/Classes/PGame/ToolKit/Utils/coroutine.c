//
//  coroutine.c
//  wechat
//
//  Created by iprincewang on 2019/1/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#include <stdlib.h>
#include "coroutine.h"
#include "ArrayList.h"

static Coroutine* startCoroutine(CoroutineRun run)
{
    Coroutine *coroutine = (Coroutine *)malloc(sizeof(Coroutine));
    
    coroutine->run = run;
    coroutine->step = NULL;
    coroutine->waitValue = 0.0f;
    coroutine->curWaitValue = 0.0f;
    
    return coroutine;
}

static void update(Coroutine* coroutine, float deltaSecond)
{
    if (coroutine->curWaitValue >= coroutine->waitValue) {
        coroutine->run(coroutine);
        
        if (coroutine->state == CoroutineState_Finish) {
            printf("################################## stop run ...\n");
        }
        else{
            printf("################################## start run ...\n");
        }
    }
    else{
        coroutine->curWaitValue += deltaSecond;
        printf("runing...\n");
    }
}

struct ACoroutine ACoroutine[1] = {
    {
        .startCoroutine = startCoroutine,
        .update = update,
    }
};
