//
//  baseDatabase.h
//  purchasingManager
//  我特么也不知道为啥 fmresultSet不能回调  会警告数据库内存问题 所以只家乐普通sql语句的支持 异步的 尽量不要用带结果的回调 如果要使用 请用在异步线程！
//  Created by Sky on 15/11/21.
//  Copyright © 2015年 郑州悉知. All rights reserved.
//

#import "baseBlock.h"
#import "GCDataBaseManager.h"

typedef void (^result_BOOL)(BOOL result);


@interface baseDatabase : baseBlock


- (void) exBackgroundQueue:(void (^)())queue;

- (void) exMainQueue:(void (^)())queue;

- (void)executeUpdateSql:(NSString* )sql;

-(void)executeSqlInBackground:(NSString* )Sql;

- (FMResultSet* ) exectuSql:(NSString* )sql ohter:(NSString* )other,...NS_REQUIRES_NIL_TERMINATION;


//- (void) executeUpdateSqlWithResult:(NSString *)sql sucess:(result_BOOL)suc;

@end
