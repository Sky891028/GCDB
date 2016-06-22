GCDB Demo project
==============

GCDB is an extension for `FMDB`(<https://github.com/ccgus/fmdb>).

Demo
==============
run `GCDB/GCDatabaseDemo.xcodeproj`

Installation
==============

### CocoaPods

1. Add `pod 'GCDB'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<GCDB/baseDatabase.h\> 
4. Inherit  @interface xxx : baseDatabase 

### Manually

1. Download all the files in the `GCDB` subdirectory.
2. Add the source files to your Xcode project.
3. Link with required frameworks:
     `sqlite3`
4. Import `FMDB`.



### HOW TO USE

######Connect
[[GCDataBaseManager defaultDBManager] setDataBaseName:@"xxx"];

######Close
[[GCDataBaseManager defaultDBManager] close];

######Execute sql
[[baseDatabase sharedInstance] executeUpdateSql:[NSString stringWithFormat:@"insert into chatData (mid,uid,content) values ('%d','323','hahaha')",arc4random() % 10000]];

######InBackground
[[baseDatabase sharedInstance] executeSqlInBackground:[NSString stringWithFormat:@"insert into chatData (mid,uid,content) values ('%d','323','hahaha')",arc4random() % 10000]];

######operation database | select
[[baseDatabase sharedInstance] executeInDatabase:^(FMDatabase *db) {
    FMResultSet* rs = [db executeQuery:@"select mid,uid,content from chatData"];
    while ([rs next]) {
        //NSLog(@"%@",[rs resultDictionary]);   deprecated
        NSLog(@"mid = %@",[rs stringForColumn:@"mid"]);
        NSLog(@"uid = %@",[rs stringForColumn:@"uid"]);
        NSLog(@"content = %@",[rs stringForColumn:@"content"]);
    }
    [rs close];
}];


Requirements
==============
This library requires `iOS 6.0+` and `Xcode 7.0+`.

Notice
==============




<br/>
---
中文介绍
==============

`GCDB`是一个高性能的sql库。

为了尽量更加自由，没有提供ORM、自动存储等接口

全局队列管理，后期会加入多队列


演示项目
==============
查看并运行 `GCDB/GCDatabaseDemo.xcodeproj`


安装
==============

### CocoaPods

1. 在 Podfile 中添加  `pod 'GCDB'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<GCDB/baseDatabase.h\> 。
4. 类中继承  @interface xxx : baseDatabase

### 手动安装

1. 下载 GCDB 文件夹内的所有内容。
2. 将 GCDB 内的源文件添加(拖放)到你的工程。
3. 添加FMDB相关 并配置依赖
4. 导入 `GCDB/baseDatabase.h`



### 如何使用？

######连接数据库
[[GCDataBaseManager defaultDBManager] setDataBaseName:@"xxx"];

######关闭数据库
[[GCDataBaseManager defaultDBManager] close];

######执行sql
[[baseDatabase sharedInstance] executeUpdateSql:[NSString stringWithFormat:@"insert into chatData (mid,uid,content) values ('%d','323','hahaha')",arc4random() % 10000]];

######后台执行sql
[[baseDatabase sharedInstance] executeSqlInBackground:[NSString stringWithFormat:@"insert into chatData (mid,uid,content) values ('%d','323','hahaha')",arc4random() % 10000]];

######操作数据库 | 查询
[[baseDatabase sharedInstance] executeInDatabase:^(FMDatabase *db) {
    FMResultSet* rs = [db executeQuery:@"select mid,uid,content from chatData"];
    while ([rs next]) {
        //NSLog(@"%@",[rs resultDictionary]);   deprecated
        NSLog(@"mid = %@",[rs stringForColumn:@"mid"]);
        NSLog(@"uid = %@",[rs stringForColumn:@"uid"]);
        NSLog(@"content = %@",[rs stringForColumn:@"content"]);
    }
    [rs close];
}];



系统要求
==============
该项目最低支持 `iOS 6.0` 和 `Xcode 7.0`。




