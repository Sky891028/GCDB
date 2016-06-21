//
//  GCDataBaseManager.h
//  GongChangSupplier
//
//  Created by sky on 14-6-11.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
//#import "FMDatabaseAdditions.h"

/**
 * @brief 对数据链接进行管理，包括链接，关闭连接
 * 可以建立长连接 
 *
 */


@interface GCDataBaseManager : NSObject

// unique databaseQueue
@property (nonatomic, strong)   FMDatabaseQueue* databaseQueue;

/**
 *  初始化数据库传入名称
 */
@property (nonatomic, strong)   NSString* dataBaseName;

// 单例模式
+(GCDataBaseManager *) defaultDBManager;

// 关闭数据库
- (void) close;
@end

