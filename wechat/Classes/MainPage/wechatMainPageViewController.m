//
//  wechatMainPageViewController.m
//  wechat
//
//  Created by iprincewang on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "wechatMainPageViewController.h"

@interface wechatMainPageViewController ()

@end

@implementation wechatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
}

-(void)initialize
{
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
