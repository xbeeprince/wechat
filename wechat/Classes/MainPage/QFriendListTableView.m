//
//  SecondTableView.m
//  wechat
//
//  Created by iprincewang on 2019/1/30.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QFriendListTableView.h"

@interface QFriendListTableView()<QBaseTableViewDelegate>
{
   
}
@end

@implementation QFriendListTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
    }
    return self;
}

-(BOOL)isScrollEnabled
{
    if (self.contentSize.height > self.bounds.size.height) {
        return YES;
    }
    return NO;
}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.canScroll == NO)
    {
        [scrollView setContentOffset:CGPointZero animated:NO];
    }
    else
    {
        if(scrollView.contentOffset.y <= 0)
        {
            if (self.tableViewDelegate && [self.tableViewDelegate respondsToSelector:@selector(resignFirstResponderToScroll)]) {
                if ([self.tableViewDelegate resignFirstResponderToScroll]) {
                    self.canScroll = NO;
                };
            }
        }
    }
}

@end
