//
//  QBaseTableView.h
//  wechat
//
//  Created by iprincewang on 2019/1/30.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QBaseTableViewDelegate <NSObject>

@optional

-(BOOL)resignFirstResponderToScroll;

@end
@interface QBaseTableView : UITableView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)_Nullable id<QBaseTableViewDelegate> tableViewDelegate;
@property (nonatomic,assign)BOOL canScroll;
@property (nonatomic,strong)NSArray *datas;
@end

NS_ASSUME_NONNULL_END
