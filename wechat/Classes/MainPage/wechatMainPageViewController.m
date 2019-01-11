//
//  wechatMainPageViewController.m
//  wechat
//
//  Created by iprincewang on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "wechatMainPageViewController.h"
#import "QORMManager.h"
#import "QPersonModel.h"
#import "QStudentModel.h"
#import "QTeacherModel.h"
#import "QORMTableSearcher.h"
#include "Array.h"
#include "ArrayList.h"
#import <setjmp.h>
#include "coroutine.h"
#include <stdlib.h>

static int function(void) {
    static int i;
    for (i = 0; i < 10; i++)
        return i;   /* won't work, but wouldn't it be nice */
    
    return -1;
}

static int function1(void) {
    static int i, state = 0;
    switch (state) {
        case 0: /* start of function */
            for (i = 0; i < 10; i++) {
                state = 1; /* so we will come back to "case 1" */
                return i;
            case 1:; /* resume control straight after the return */
            }
    }
    return -1;
}

static int function2(void) {
    static int i, state = 0;
    switch (state) {
        case 0: /* start of function */
            for (i = 0; i < 10; i++) {
                state = __LINE__ + 2; /* so we will come back to "case __LINE__" */
                return i;
            case __LINE__:; /* resume control straight after the return */
            }
    }
    return -1;
}

static void loadingRun(Coroutine *coroutine)
{
    NSLog(@"begin.........................");
    
    ACoroutine_Begin();

    ACoroutine_YieldSeconds(5.0);
    
    ACoroutine_YieldSeconds(5.0);
    
    ACoroutine_End();
    
    coroutine->state = CoroutineState_Finish;
    
    NSLog(@"end.........................");
}
    
@interface wechatMainPageViewController ()

@end

@implementation wechatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    
    //[self runTest];
    
    [self run];
}

-(void)initialize
{
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
}




-(void)run
{
    Coroutine *coroutine = ACoroutine->startCoroutine(loadingRun);
    
    while (coroutine->state != CoroutineState_Finish) {
        ACoroutine->update(coroutine,1.0);
        sleep(1);
        NSLog(@"wait 1 秒");
    }
    
    NSLog(@"结束了");
}

#pragma mark -- 测试ORMModel的代码
-(void)runTest
{

    QTeacherModel *teacher = [QTeacherModel new];
    teacher.cardId = [NSString stringWithFormat:@"teacher_%d",0];
    teacher.name = @"老师王子健";
    teacher.age = 21;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] + arc4random()%1000;
    teacher.date = [NSDate dateWithTimeIntervalSince1970:time];
    
    QPersonModel *friendPerson = [QPersonModel new];
    friendPerson.cardId = [NSString stringWithFormat:@"friend_%d",0];
    friendPerson.city = @"上海";
    friendPerson.name = @"小明";
    friendPerson.age = 22;
    time = [[NSDate date] timeIntervalSince1970] + arc4random()%1000;
    friendPerson.date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSMutableArray *students = [NSMutableArray new];
    for (int index = 0; index < 10; index++) {
        QStudentModel *student = [QStudentModel new];
        student.cardId = [NSString stringWithFormat:@"student_%d",index];
        student.city = @"深圳";
        student.name = [NSString stringWithFormat:@"学生_%d",index];
        student.age = 21;
        student.school = @"华中科技大学";
        student.className = @"计算机大班";
        student.sex = arc4random()%2;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970] + arc4random()%1000;
        student.date = [NSDate dateWithTimeIntervalSince1970:time];
        
        student.friendPerson = friendPerson;
        
        [students addObject:student];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (int index = 10; index < 12; index++) {
        QStudentModel *student = [QStudentModel new];
        student.cardId = [NSString stringWithFormat:@"student_%d",index];
        student.city = @"深圳";
        student.name = [NSString stringWithFormat:@"学生_%d",index];
        student.age = 21;
        student.school = @"华中科技大学";
        student.className = @"计算机大班";
        student.sex = arc4random()%2;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970] + arc4random()%1000;
        student.date = [NSDate dateWithTimeIntervalSince1970:time];
        
        student.friendPerson = friendPerson;
        
        NSString *key = [NSString stringWithFormat:@"studet_%d",index];
        [dict setValue:student forKey: key];
    }
    
    teacher.students = students;
    teacher.studentDict = dict;
    
    [[QORMManager getInstance] saveWithModel:teacher];

    QORMModel *model = [QORMTableSearcher searchWithPrimaryKeyValue:@"teacher_0" withClassName:@"QTeacherModel"];
    NSLog(@"result : %@",model);
    
    
    QORMModel *teacherCopy = [model copy];
    NSLog(@"copy result: %@",teacherCopy.description);
}

@end
