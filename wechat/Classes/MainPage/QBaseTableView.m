//
//  QBaseTableView.m
//  wechat
//
//  Created by iprincewang on 2019/1/30.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QBaseTableView.h"

@implementation QBaseTableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

//默认
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark -- QBaseTableViewDelegate
-(BOOL)resignFirstResponderToScroll
{
    BOOL scrollEnable = [self isScrollEnabled];
    if (scrollEnable) {
        self.canScroll = YES;
    }
    return scrollEnable;
}

@end
