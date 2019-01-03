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

@interface wechatMainPageViewController ()

@end

@implementation wechatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    
    [self runTest];
}

-(void)initialize
{
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark -- 测试ORMModel的代码
-(void)runTest
{
    QTeacherModel *teacher = [QTeacherModel new];
    teacher.cardId = [NSString stringWithFormat:@"teacher_%d",0];
    teacher.name = @"老师王子健";
    teacher.age = 21;
    
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
        
        QPersonModel *friendPerson = [QPersonModel new];
        friendPerson.cardId = [NSString stringWithFormat:@"friend_%d",index];
        friendPerson.city = @"上海";
        friendPerson.name = @"小明";
        friendPerson.age = 22;
        
        student.friendPerson = friendPerson;
        
        [students addObject:student];
    }
    
    [[QORMManager getInstance] saveWithModel:teacher];

    QORMModel *model = [QORMTableSearcher searchWithPrimaryKeyValue:@"teacher_0" withClassName:@"QTeacherModel"];
    NSLog(@"result : %@",model.description);
    
}

@end
