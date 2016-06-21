//
//  baseDatabase.h
//  purchasingManager
//  暂时没有实现fmResultSet回传 所以只家乐普通sql语句的支持 异步的 尽量不要用带结果的回调 如果要使用 需要自己封装业务 只需要集成此类 并在databseQueue保护下进行操作  done！
//  Created by Sky on 15/11/21.
//  Copyright © 2015年 郑州悉知. All rights reserved.
//

#import "GCDataBaseManager.h"
#import <FMDB/FMResultSet.h>

@class  FMResultSet;

@interface baseDatabase : NSObject


/**
 *  在后台线程执行
 *
 *  @param queue queue description
 */
- (void) exBackgroundQueue:(void (^)())queue;

/**
 *  主线程执行
 *
 *  @param queue queue description
 */
- (void) exMainQueue:(void (^)())queue;


/**
 *  获取db对象 进行操作
 *
 *  @param queue queue description
 */
- (void)executeInDatabase:(void (^)(FMDatabase* db))queue;

/**
 *  执行一条sql
 *
 *  @param sql sql
 *
 *  @return return value description
 */
- (BOOL) executeUpdateSql:(NSString* )sql;

/**
 *  后台执行一条sql
 *
 *  @param Sql Sql description
 */
- (void) executeSqlInBackground:(NSString* )Sql;

/**
 *  检查表或某个字段是否存在
 *
 *  @param tableName 表名 必填
 *  @param columName 列名 可选
 *
 *  @return <#return value description#>
 */
- (BOOL) checkIsExist:(NSString* )tableName columName:(NSString* )columName;

//- (FMResultSet* )getResultBySql:(NSString* )sql;


@end
