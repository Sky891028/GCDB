//
//  baseDatabase.m
//  purchasingManager
//
//  Created by Sky on 15/11/21.
//  Copyright © 2015年 郑州悉知. All rights reserved.
//

#import "baseDatabase.h"

@implementation baseDatabase


- (void)exBackgroundQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}


- (void)executeInDatabase:(void (^)(FMDatabase* db))queue {
    [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:queue];
}


- (BOOL) executeUpdateSql:(NSString* )sql{

    __block BOOL succeed = YES;
    
    [self executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
        if (db.hadError) {
            succeed = NO;
            NSLog(@"执行sql\n%@",sql);
            NSLog(@"%@",db.lastErrorMessage);
        }

    }];
    
    return succeed;
}

-(void)executeSqlInBackground:(NSString* )Sql{
    [self exBackgroundQueue:^{
        [self executeUpdateSql:Sql];
    }];
}


- (BOOL) checkIsExist:(NSString* )tableName columName:(NSString* )columName{
    if (!tableName){
        NSAssert(NO, @"%s tableName not be nil",__FUNCTION__); return NO;
    }
    __block BOOL exist = NO;
    [self executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        if ([rs next]) exist = [rs intForColumn:@"count"];
    
        if (exist && columName) {
            exist = NO;
            [rs close];
            rs = [db executeQuery:[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName]];
            while ([rs next]) {
                NSString * cName = [rs stringForColumn:@"name"];
                if ([cName isEqualToString:columName]) {
                    exist = YES;
                    NSLog(@"表：%@ 存在字段：%@",tableName,columName);
                    break;
                }
            }
        }
        [rs close];
    }];
    return exist;
}


@end
