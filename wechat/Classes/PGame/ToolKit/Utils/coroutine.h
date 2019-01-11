//
//  coroutine.h
//  wechat
//
//  Created by iprincewang on 2019/1/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#ifndef coroutine_h
#define coroutine_h


#include <stdio.h>

typedef enum
{
    /**
     * Coroutine enter queue ready to running
     */
    CoroutineState_Ready,
    
    /**
     * Coroutine has started to execute
     */
    CoroutineState_Running,
    
    /**
     * Coroutine already finished and waiting for reuse
     */
    CoroutineState_Finish,
}
CoroutineState;


typedef struct Coroutine Coroutine;

typedef void (*CoroutineRun)(Coroutine* coroutine);

struct Coroutine {
    
    void* step;
    
    CoroutineRun run;
    
    CoroutineState state;
    
    float waitValue;
    
    float curWaitValue;
};

struct ACoroutine {
    
    Coroutine* (*startCoroutine)(CoroutineRun run);
    
    void (*update) (Coroutine* coroutine, float detalSeconds);
};

extern struct ACoroutine ACoroutine[1];

/**
 * Construct goto label with line number
 */
#define ACoroutine_StepName(line) Step##line
#define ACoroutine_Step(line)     ACoroutine_StepName(line)


#define ACoroutine_Begin()                    \
    if (coroutine->step != NULL)              \
    {                                         \
        goto *coroutine->step;                \
    }                                         \
    coroutine->state = CoroutineState_Running


#define ACoroutine_End() \
    coroutine->state = CoroutineState_Finish


/**
 * Called between ACoroutine_Begin and ACoroutine_End
 *
 * waitSecond: CoroutineRun wait seconds and running again
 */
#define ACoroutine_YieldSeconds(waitSeconds)                \
    coroutine->waitValue    = waitSeconds;                  \
    coroutine->curWaitValue = 0.0f;                         \
    coroutine->step         = &&ACoroutine_Step(__LINE__);  \
    return;                                                 \
    ACoroutine_Step(__LINE__):

#endif /* coroutine_h */
