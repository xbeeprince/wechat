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
    QPersonModel *person = [QPersonModel new];
    person.city = @"深圳";
    person.name = @"王子健";
    person.age = 21;
    
    QPersonModel *friendPerson = [QPersonModel new];
    friendPerson.city = @"上海";
    friendPerson.name = @"小明";
    friendPerson.age = 22;
    
    person.friendPerson = friendPerson;
    
    [[QORMManager getInstance] saveWithModel:person];
}

@end
