//
//  QORMManager.m
//  wechat
//
//  Created by iprincewang on 2018/12/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "QORMManager.h"
#import "QORMModel.h"
#import "QORMProperty.h"
#import "QORMPropertyParser.h"
#import "QFileHandler.h"
#import "QORMTableCreater.h"

@interface QORMManager ()

@property (nonatomic, strong)FMDatabaseQueue *dbQueue;

@end

@implementation QORMManager

+(instancetype)getInstance
{
    static QORMManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [QORMManager new];
    });
    return instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self databasePath]];
    }
    return self;
}

-(FMDatabaseQueue *)getDatabaseQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self databasePath]];
    }
    return _dbQueue;
}

-(void)saveWithModel:(QORMModel *)model
{
    //创建表
    BOOL result = [QORMTableCreater createTableWithModel:model];
    NSLog(@"%d",result);
}

#pragma mark -- private mothod

-(NSString *)databasePath
{
    NSString *documentDir = [QFileHandler getDocumentPath];
    return [[documentDir stringByAppendingPathComponent: @"mydata"] stringByAppendingPathComponent:@"database.db"];
}

-(void)excuteWithBlock:(void (^)(void))block
{
    
}

@end
