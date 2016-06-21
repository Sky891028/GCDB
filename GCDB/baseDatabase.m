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


- (void) executeUpdateSql:(NSString* )sql{
        [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sql];
            if (db.hadError) {
                NSLog(@"执行sql\n%@",sql);
                NSLog(@"%@",db.lastErrorMessage);
            }
        }];
}

-(void)executeSqlInBackground:(NSString* )Sql{
    [self exBackgroundQueue:^{
        [self executeUpdateSql:Sql];
    }];
}
//- (FMResultSet* ) exectuSql:(NSString* )sql ohter:(NSString* )other,...NS_REQUIRES_NIL_TERMINATION{
//    [self exectuSql:"@1" ohter:@"111",@"das",@"ffsaf", nil];
//    [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:^(FMDatabase *db) {
//        FMResultSet* aaa = [db executeQuery:@"select * from chatData where sss = ?, ss = ? ;......." withArgumentsInArray:@[@"aa",@"dd"]];
//        NSMutableArray* dd = [NSMutableArray new];
//    va_list args;
//    va_start(args, other);
//    for(id str = other; str != nil; str = va_arg(args, id)){
//        [dd addObject:other];
//    }
//        [db executeQuery:sql withArgumentsInArray:dd];
//    va_end(args);
//    }];
//    
//}


@end
