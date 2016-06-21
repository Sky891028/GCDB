//
//  GCDataBaseManager.m
//  GongChangSupplier
//
//  Created by sky on 14-6-11.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//

#import "GCDataBaseManager.h"

@interface GCDataBaseManager(){
    
}
@property (nonatomic, strong)     NSString* dataBasePath;
@end

@implementation GCDataBaseManager

+ (GCDataBaseManager *) defaultDBManager{
    static GCDataBaseManager *_sharedDBmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDBmanager = [[GCDataBaseManager alloc]init];
    });
    return _sharedDBmanager;
}


-(void)setDataBaseName:(NSString *)dataBaseName{
    _dataBaseName = dataBaseName;
    [self initializeDBWithName:dataBaseName];
}


-(FMDatabaseQueue* )databaseQueue{
    if (!_databaseQueue) NSLog(@"没有连接数据库，无法完成操作");
    return _databaseQueue;
}
/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 */

- (void)initializeDBWithName : (NSString *) name {
    if (!name) assert(@"dataBaseName not null");
    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docPatch:%@",docp);
    self.dataBasePath       =       [docp stringByAppendingString:[NSString stringWithFormat:@"/v2%@.sqlite",name]];
    self.databaseQueue      =       [[FMDatabaseQueue alloc] initWithPath:_dataBasePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:_dataBasePath];
    if (!exist) {
        NSLog(@"数据创建|连接失败");
    } else {
        NSLog(@"数据已连接");
    }
    
}

/// 关闭连接
- (void)close {
    [_databaseQueue close];
    _databaseQueue = nil;
    _dataBaseName = nil;
    NSLog(@"数据库已断开连接");
}


@end
