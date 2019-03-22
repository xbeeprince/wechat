//
//  FirstTableView.m
//  wechat
//
//  Created by iprincewang on 2019/1/30.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QRelationTableView.h"

@interface QRelationTableView ()<QBaseTableViewDelegate>

@end

@implementation QRelationTableView

// 是否支持多手势触发，返回YES，则可以多个手势一起触发方法(子tableview也可以滑动)，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
        self.canScroll = YES;
    }
    return self;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"relationTablecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"relationTablecell"];
    }
    cell.textLabel.text = (NSString *)([self.datas objectAtIndex:indexPath.row]);
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.canScroll)
    {
        //大于这个临界值就保持不变
        if(scrollView.contentOffset.y > 300)
        {
            [scrollView setContentOffset:CGPointMake(0, 300) animated:NO];
            
            if (self.tableViewDelegate && [self.tableViewDelegate respondsToSelector:@selector(resignFirstResponderToScroll)]) {
                if ([self.tableViewDelegate resignFirstResponderToScroll]) {
                    self.canScroll = NO;
                };
            }
        }
    }
    else
    {
        [scrollView setContentOffset:CGPointMake(0, 300) animated:NO];
    }
}

@end
