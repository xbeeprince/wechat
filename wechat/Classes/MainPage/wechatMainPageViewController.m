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
#import "QRelationTableView.h"
#import "QFriendListTableView.h"

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
    
    NSLog(@"end.........................");
}

@interface SectionDataModel : NSObject
@property(nonatomic,strong)NSString *sectionName;
@property(nonatomic,strong)NSArray *rows;
@property(nonatomic,strong)NSArray<NSIndexPath *> *indexPaths;
@property(nonatomic,assign)BOOL open;
@property (nonatomic, assign)CGRect inSuperViewFrame;
@end

@implementation SectionDataModel

@end

#define ACOUNT 10
#define BCOUNT 20
@interface wechatMainPageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    QRelationTableView *aTableView;
    QFriendListTableView *bTableView;
    id acells[ACOUNT];
    id bcells[BCOUNT];
    BOOL isCanScrollView;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *data;
@property (nonatomic,strong)SectionDataModel *currentModel;
@property (nonatomic, assign)CGFloat lastContentOffsetY;
@property (nonatomic, assign)CGFloat lastContentSizeHeight;
@end

@implementation wechatMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//
    [self initialize];
    
    //[self runTest];
    
//    [self run];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        SectionDataModel *model = [self.data objectAtIndex:0];
//        model.rows = nil;
//
//        NSMutableIndexSet *set = [NSMutableIndexSet new];
//        [set addIndex:0];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationTop];
//    });
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        SectionDataModel *model = [self.data objectAtIndex:0];
//        NSMutableArray *rows = [NSMutableArray new];
//        for (int j = 0; j<10; j++) {
//            NSString *row = [NSString stringWithFormat: @"    row:%d",j];
//            [rows addObject: row];
//        }
//        model.rows = rows;
//
//        NSMutableIndexSet *set = [NSMutableIndexSet new];
//        [set addIndex:0];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
//    });
    
//    aTableView = [[QRelationTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//    [self.view addSubview:aTableView];
//
//    for(int i = 0 ; i < ACOUNT; i++)
//    {
//        acells[i] = [NSString stringWithFormat:@"cell1 - %d",i];
//    }
//
//
//    bTableView = [[QFriendListTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//    [acells[9] addSubview:bTableView];
//
//    for(int i = 0 ; i < BCOUNT; i++)
//    {
//        bcells[i] = [NSString stringWithFormat:@"cell2 - %d",i];
//    }
//    bTableView.datas = bcells;
//
//    [aTableView reloadData];
//    aTableView.datas = acells;
}

-(void)initialize
{
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];

    NSMutableArray *data = [NSMutableArray new];
    for (int i = 0; i< 50; i++) {
        SectionDataModel *model = [SectionDataModel new];
        model.sectionName = [NSString stringWithFormat: @"section:%d",i];
        NSMutableArray *rows = [NSMutableArray new];
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int j = 0; j<20; j++) {
            NSString *row = [NSString stringWithFormat: @"    model.sectionName  row:%d",j];
            [rows addObject: row];

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [indexPaths addObject:indexPath];
        }
        model.indexPaths = indexPaths;
        model.rows = rows;
        [data addObject:model];
    }

    _data = data;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60.0)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 60.0)];
    SectionDataModel *model = [_data objectAtIndex:section];
    [button setTitle:model.sectionName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapToOpenOrClose:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    [sectionView addSubview:button];

    return sectionView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionDataModel *model = [_data objectAtIndex:section];
    if (model.open) {
        if ([model.rows count] > 0) {
            return [model.rows count];
        }
        else{
            return 0;
        }
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    SectionDataModel *model = [_data objectAtIndex:indexPath.section];
    NSString *string = [model.rows objectAtIndex:indexPath.row];
    [cell.textLabel setText:string];

    return cell;
}

-(void)tapToOpenOrClose:(id)sender{
    UIButton * tapGR = (UIButton *)sender;
    NSInteger section = tapGR.tag;
    SectionDataModel *model = [_data objectAtIndex:section];
    
    NSMutableIndexSet *set = [NSMutableIndexSet new];
    [set addIndex:section];
    
    CGRect frame = [self.tableView rectForHeaderInSection:section];
    frame.origin.y = [self sectionFrameInTableView:section];
    CGRect frame1 = [self.tableView convertRect:frame toView:self.tableView.superview];
    NSLog(@"+++++++++++++++++++++++ frame.y：%f     frame1.y：%f     contentOffsetY = %f",frame.origin.y,frame1.origin.y,self.tableView.contentOffset.y);
    
    if (model.open == NO) {
        
//        NSMutableArray *rows = [NSMutableArray new];
//        for (int j = 0; j<5; j++) {
//            NSString *row = [NSString stringWithFormat: @"    model.sectionName  row:%d",j];
//            [rows addObject: row];
//        }
//        model.rows = rows;
        _lastContentOffsetY = _tableView.contentOffset.y;
        _lastContentSizeHeight = _tableView.contentSize.height;
        _currentModel = model;
        model.inSuperViewFrame = frame1;
        NSLog(@"-------------------0  contentOffsetY = %f, contentSize.height = %f",self.tableView.contentOffset.y,self.tableView.contentSize.height);
        model.open = !model.open;
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:model.indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        [_tableView endUpdates];
//        [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, model.lastContentOffsetY)];
        
        NSLog(@"-------------------0  contentOffsetY = %f, contentSize.height = %f",self.tableView.contentOffset.y,self.tableView.contentSize.height);
    }
    else {
//        model.rows = nil;
        _currentModel = nil;
        
        
        if (frame1.origin.y <= 64) {
            
            
            CGFloat x = _tableView.contentOffset.x;
            CGFloat y = [self sectionFrameInTableView:section];
            CGFloat afterdetetedHeight = [self afterDeletedTotalFrameHeight:section];
            
            if (y + _tableView.bounds.size.height > afterdetetedHeight) {
                y = afterdetetedHeight - _tableView.frame.size.height;
                [_tableView setContentOffset:CGPointMake(x, y)];
            }
            else {
                [_tableView setContentOffset:CGPointMake(x, y - 64)];
            }
            
        }
        
        
         NSLog(@"-------------------3  contentOffsetY = %f, contentSize.height = %f",self.tableView.contentOffset.y,self.tableView.contentSize.height);
//        NSArray *deleteIndexPaths = [[model.indexPaths reverseObjectEnumerator] allObjects];
        model.open = !model.open;
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:model.indexPaths  withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        
        NSLog(@"-------------------3  contentOffsetY = %f, contentSize.height = %f",self.tableView.contentOffset.y,self.tableView.contentSize.height);
        
//        NSLog(@"-------------------1  contentOffsetY = %f",self.tableView.contentOffset.y);
//        if (frame1.origin.y < 64) {
//            CGFloat x = _tableView.contentOffset.x;
//            CGFloat y = frame.origin.y - 64;
//            [_tableView setContentOffset:CGPointMake(x, y)];
//            NSLog(@"-------------------2  contentOffsetY = %f",self.tableView.contentOffset.y);
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//
        
        
    }
}

//-(CGFloat)afterDeletedTotalFrameHeight:(NSInteger)section
//{
//    CGFloat height = _groupTableView.contentSize.height;
//    if (section < [_friendList count]) {
//        FriendListHeaderModel *model = [_friendList objectAtIndex:section];
//        if ([model.cellDataList count] > 0) {
//            CGFloat cellHeight = [self tableView:_groupTableView heightForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:section]];
//            CGFloat totalCellHeight = cellHeight * [model.cellDataList count];
//            height = height - totalCellHeight;
//        }
//    }
//
//    return height;
//}

-(CGFloat)sectionFrameInTableView:(NSInteger)section
{
    CGFloat height = 0.f;
    
    for (int index = 0; index < section; index++) {
        SectionDataModel *model = [_data objectAtIndex:index];
        height += 60.0;
        if (model.open) {
            height += ([model.indexPaths count] * 100);
        }
    }
    
    return height;
}

-(CGFloat)sectionTotalFrameInTableView
{
    CGFloat height = _tableView.contentSize.height;
    
    return height;
}

-(CGFloat)afterDeletedTotalFrameHeight:(NSInteger)section
{
    CGFloat height = [self sectionTotalFrameInTableView];
    
    SectionDataModel *model = [_data objectAtIndex:section];
    
    height = height - ([model.indexPaths count] * 100);
    
    return height;
}


- (void)resizeTableViewFrameHeight
{
    // Table view does not scroll, so its frame height should be equal to its contentSize height
    CGRect frame = self.tableView.frame;
    frame.size = self.tableView.contentSize;
    self.tableView.frame = frame;
}

- (CGSize)preferredContentSize
{
    // Force the table view to calculate its height
    [self.tableView layoutIfNeeded];
    return self.tableView.contentSize;
}

- (void)test2:(NSNotification *)n
{
    isCanScrollView = YES;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@".............................  contentOffsetY = %f",self.tableView.contentOffset.y);
    if (_currentModel) {
        NSIndexPath *indexPath = [_currentModel.indexPaths firstObject];
        CGRect frame = [self.tableView rectForHeaderInSection:indexPath.section];
        frame.origin.y  = frame.origin.y;
        CGRect frame1 = [self.tableView convertRect:frame toView:self.tableView.superview];
        NSLog(@"====================== frame.y：%f     frame1.y：%f       contentOffsetY = %f",frame.origin.y,frame1.origin.y,self.tableView.contentOffset.y);
        
        if (frame1.origin.y >= 64) {
            _lastContentOffsetY = frame1.origin.y;
        }
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
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
