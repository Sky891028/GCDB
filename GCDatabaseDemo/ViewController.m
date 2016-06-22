//
//  ViewController.m
//  GCDatabaseDemo
//
//  Created by Sky on 16/6/20.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "ViewController.h"
#import "baseDatabase.h"
#import "GCCreateDatabase.h"
#import "GCDataBaseManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GCCreateDatabase* cre = [[GCCreateDatabase alloc] init];
    [self testDB:cre withName:@"1"];
    
    [self testDB:cre withName:@"2"];

    [self testDB:cre withName:@"1"];

}

-(void)testDB:(GCCreateDatabase* )cre withName:(NSString* )cName{
    //连接数据 并创建表
    [cre createDatabaseWithName:cName];
    
    //检查表 列...
    [[baseDatabase sharedInstance] checkIsExist:@"channelData" columName:@"mid"];
    
    //后台执行会有一定的不及时 不影响业务时使用此接口
    //    [cre executeSqlInBackground:[NSString stringWithFormat:@"insert into chatData (mid,uid,content) values ('%d','323','哈哈哈')",arc4random() % 10000]];
    
    int x = 100;
    while (x > 0) {
        x --;
        NSLog(@"%@",[[baseDatabase sharedInstance] executeUpdateSql:[NSString stringWithFormat:@"insert into chatData (mid,uid,content) values ('%d','323','哈哈哈')",arc4random() % 10000]]?@"写入成功":@"写入失败");
    }
    
    //调用databasequeue执行xxxxx操作 sql随便玩 没有任何限制
    [[baseDatabase sharedInstance] executeInDatabase:^(FMDatabase *db) {

        FMResultSet* rs = [db executeQuery:@"select mid,uid,content from chatData"];
        while ([rs next]) {
            NSLog(@"%@",[rs resultDictionary]);   //不推荐调用
            NSLog(@"mid = %@",[rs stringForColumn:@"mid"]);
            NSLog(@"uid = %@",[rs stringForColumn:@"uid"]);
            NSLog(@"content = %@",[rs stringForColumn:@"content"]);
        }
        [rs close];
    }];
    
    [cre close];  //断开连接数据库
    
    //查询数据库  无法连接 无法执行方法
    [[baseDatabase sharedInstance] executeInDatabase:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:@"select mid,uid,content from chatData limit 30"];
        while ([rs next]) {
            NSLog(@"%@",[rs resultDictionary]);
        }
        [rs close];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
