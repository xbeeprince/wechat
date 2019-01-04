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
#import "QORMTableInserter.h"
#import "QORMTableSearcher.h"
#import "QORMHelper.h"

@interface QORMManager ()
@property (nonatomic, strong)FMDatabaseQueue *dbQueue;
@property (nonatomic, strong)NSDictionary *classPropertyInfoCache;
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
    BOOL insert_result = [QORMTableInserter insertWithModel:model];
    NSLog(@"insert result = %@",insert_result ? @"YES":@"NO");
}

-(void)addClassPropertyInfoCache:(NSArray *)propertyInfoArray withClassName:(NSString *)className
{
    if ([className length] > 0 && propertyInfoArray) {
        NSMutableDictionary *tmpDict = nil;
        if ([_classPropertyInfoCache.allKeys count] > 0) {
            tmpDict = [NSMutableDictionary dictionaryWithDictionary:_classPropertyInfoCache];
        }
        else{
            tmpDict = [NSMutableDictionary new];
        }
        
        [tmpDict setValue:propertyInfoArray forKey:className];
        
        _classPropertyInfoCache = tmpDict;
    }
}

-(NSArray *)propertyInfoCacheWithClassName:(NSString *)className
{
    if ([className length] > 0) {
        return [_classPropertyInfoCache valueForKey:className];
    }
    return nil;
}

#pragma mark -- private mothod

-(NSString *)databasePath
{
    NSString *path = [QORMHelper databasePath];
    return path;
}

-(void)excuteWithBlock:(void (^)(void))block
{
    
}

@end
