//
//  GCDataBaseManager.h
//  GongChangSupplier
//
//  Created by sky on 14-6-11.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

typedef void (^sucDic)(id sucDic);
typedef void (^errorBlock)(id error);


@interface GCDataBaseManager : NSObject

// unique databaseQueue
@property (nonatomic, strong)   FMDatabaseQueue* databaseQueue;
/**
 *  数据库名称 设置即连接
 */
@property (nonatomic, strong)   NSString* dataBaseName;

// 单例
+(GCDataBaseManager *) defaultDBManager;

// 关闭数据库
- (void) close;
@end

