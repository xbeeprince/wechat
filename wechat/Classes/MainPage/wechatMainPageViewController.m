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
    QStudentModel *student = [QStudentModel new];
    student.city = @"深圳";
    student.name = @"王子健";
    student.age = 21;
    student.school = @"华中科技大学";
    
//    QPersonModel *friendPerson = [QPersonModel new];
//    friendPerson.city = @"上海";
//    friendPerson.name = @"小明";
//    friendPerson.age = 22;
//
//    student.friendPerson = friendPerson;
    
    [[QORMManager getInstance] saveWithModel:student];
}

@end
