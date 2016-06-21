//
//  GCCreateDatabase.m
//  GongChangSupplier
//
//  Created by sky on 14-6-16.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//

/*
 数据库版本变动说明  如果要变动数据库 需要在首页里面更改判断
 
 
 V1     --1.0.2 V1初始数据库版本
 
 --1.1.3 增加朋友圈状态标记、本地图片路径、和远程
 
 
 V2     --2.0.0  把聊天列表放入channelData
 
 
 --next！
 
 */



#import "GCCreateDatabase.h"
#import "initWithBaseData.h"
#import "GCDataBaseManager.h"



@implementation GCCreateDatabase{
    NSString* dbVersion;
}

- (id) init {
    self = [super init];
    if (self) {
        //        dbVersion = @"1.0.2";
        //        dbVersion = @"1.2.0";
        dbVersion = @"2.0.0";
    }
    return self;
}


-(void)createDatabase{
    
//    [[GCDataBaseManager defaultDBManager] close];
    [[GCDataBaseManager defaultDBManager] setDataBaseName:hostUser.userID];
    NSLog(@"%@",userDefaults.databaseVersion);
    NSLog(@"%@",hostUser.userID);

    if ([userDefaults.databaseVersion isEqualToString:dbVersion]) {
        NSLog(@"dataBase OK");
    }else if ([userDefaults.databaseVersion isEqualToString:@"1.0.2"]){
        [self updataFrom102Version];
    }else if ([userDefaults.databaseVersion isEqualToString:@"1.2.0"]){
        [self updataFrom120Version];
    }else if (userDefaults.databaseVersion){
        [self updataFrom170Version];
    }else{
        [self createBaseDataBase];
    }
    userDefaults.databaseVersion = dbVersion;
}

-(void)updataFrom170Version{
    [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:^(FMDatabase *db) {
        //增加字段
        NSString* channelSql = @"alter table channelData add lastMsg VARCHAR(50)";
        BOOL res  = [db executeUpdate:channelSql];
        
        channelSql = @"alter table channelData add updataTime INTEGER";
        res  = [db executeUpdate:channelSql];
        
        channelSql = @"alter table channelData add unreadNums INTEGER";
        res  = [db executeUpdate:channelSql];
        
        //索引
        NSString* channelIndex = @"CREATE INDEX channelIndex ON channelData(conID,chatType,userID)";
        res = [db executeUpdate:channelIndex];
        if (!res) {
            NSLog(@"2.0索引成功");
        }else{
            NSLog(@"2.0表索引失败");
            NSLog(@"%@",db.lastErrorMessage);
        }
    }];
}


-(void)updataFrom120Version{
    [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:^(FMDatabase *db) {
        NSString* chatSql = @"alter table chatData add retryTimes INTEGER";
        BOOL res  = [db executeUpdate:chatSql];
        if (!res) {
            NSLog(@"1.3表失败");
        }else{
            NSLog(@"1.3表成功");
            NSLog(@"%@",db.lastErrorMessage);
        }
    }];
}

-(void)updataFrom102Version{
    [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:^(FMDatabase *db) {
        NSString* eventSql = @"CREATE TABLE IF NOT EXISTS  eventData (incremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,type INTEGER,cid VARCHAR(20),status INTEGER, title VARCHAR(50), content VARCHAR(100),addTime INTEGER,updateTime INTEGER)";
        BOOL res = [db executeUpdate:eventSql];
        if (!res) {
            NSLog(@"插入事件表失败");
        }else{
            NSLog(@"插入事件表成功");
            NSLog(@"%@",db.lastErrorMessage);
        }
        NSString* eventIndexSql = @"CREATE INDEX time_index6 ON eventData(status)";
        res = [db executeUpdate:eventIndexSql];
        if (!res) {
            NSLog(@"插入事件表失败");
        }else{
            NSLog(@"插入事件表成功");
            NSLog(@"%@",db.lastErrorMessage);
        }
        
        //alert
        NSString* formSql = @"alter table momentData add localImageUrl VARCHAR(50)";
        res = [db executeUpdate:formSql];
        formSql = @"alter table momentData add sendStatus INTEGER";
        res = [db executeUpdate:formSql];
        if (!res) {
            NSLog(@"插入事件表失败");
        }else{
            NSLog(@"插入事件表成功");
            NSLog(@"%@",db.lastErrorMessage);
        }
        
        NSString* chatSql = @"alter table chatData add isRead BIT";
        res = [db executeUpdate:chatSql];
        chatSql = @"alter table chatData add retryTimes INTEGER";
        res = [db executeUpdate:chatSql];
        if (!res) {
            NSLog(@"插入事件表失败");
        }else{
            NSLog(@"插入事件表成功");
            NSLog(@"%@",db.lastErrorMessage);
        }
    }];
}

//创建数据库版本2.0
-(void)createBaseDataBase{
    [[[GCDataBaseManager defaultDBManager] databaseQueue] inDatabase:^(FMDatabase *db) {
        NSString* channelSql = @"CREATE TABLE IF NOT EXISTS channelData (userID INTEGER, conID VARCHAR(24),fromID VARCHAR(24),toID VARCHAR(24), fromName VARCHAR(20),toName VARCHAR(20),fromImage VARCHAR(50),toImage VARCHAR(50),chatType INTEGER,lastMsg VARCHAR(50),updataTime INTEGER,unreadNums INTEGER,getNewMsg BIT,PRIMARY KEY (toID,chatType))";
        //1.2新增字段 isRead     bit
        //1.3新增字段 retryTimes integer
        //2.0增加字段 attrs json
        NSString* chatDataSql = @"CREATE TABLE IF NOT EXISTS chatData (uid INTEGER,mid VARCHAR(20) PRIMARY KEY,addTime INTEGER, content VARCHAR(300),type INTEGER,timeLenth VARCHAR(10),sender BIT,status BIT,chatType BIT,isRead BIT,retryTimes,attrs VARCAR(0),conID VARCHAR(24))";
        NSString* userSql = @"CREATE TABLE IF NOT EXISTS userData (tel VARCHAR(11),userID VARCHAR(24) PRIMARY KEY,location VARCHAR(20) ,userName VARCHAR(20),userNickName VARCHAR(20),headerImageUrl VARCHAR(100),type INTEGER,lcid VARCHAR(24),position VARCHAR(16),company VARCHAR(20),department VARCHAR(20),sex BIT,nameS VARCHAR(10),nameF VARCHAR(20),email VARCHAR(20),updataTime VARCHAR(20),markName VARCHAR(10))";
        //朋友圈数据库
        //1.3新增字段  localImageUrl 本地图片地址  sendStatu
        NSString* momentSql =  @"CREATE TABLE IF NOT EXISTS momentData (mid INTEGER PRIMARY KEY,fid VARCHAR(10),fName VARCHAR(20),writeDic BOLB,images VARCHAR(100),ftype BIT,mtype INTEGER,commentNum INTEGER,zanNum INTEGER,share BLOB,addTime INTEGER,content VARCHAR(100),comments BLOB,isAnonymous BIT,isZan BIT,zanStr BLOB,localImageUrl VARCHAR(50),sendStatus BIT)";
        //企业信息数据库
        NSString* companyInfoSql = @"CREATE TABLE IF NOT EXISTS COMPANYINFO (addtime INTEGER,r_time INTEGER,com_num VARCHAR(15),com_code VARCHAR(20) PRIMARY KEY,com_name VARCHAR(20),com_legal VARCHAR(10),com_info VARCHAR(1),isCol BIT,comments VARCHAR(200),contacts VARCHAR(200),keyWord VARCHAR(20),province VARCHAR(5),shareUrl VARCHAR(50),colID INTEGER)";
        //历史数据库
        NSString* historySql = @"CREATE TABLE IF NOT EXISTS historyData (type INTEGER,userID INTEGER,cid VARCHAR(20), title VARCHAR(50), content VARCHAR(100),updataTime INTEGER,imageUrl VARCHAR(50),isTop BIT,isMine BIT,unReadNum INTEGER, anonymousfrom VARCHAR(50),anonymousTo VARCHAR(24))";
        
        //事件数据库、待处理事件数据库   1.3新增表
        NSString* eventSql = @"CREATE TABLE IF NOT EXISTS  eventData (incremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,type INTEGER,cid VARCHAR(20),status INTEGER, title VARCHAR(50), content VARCHAR(100),addTime INTEGER,updateTime INTEGER)";
        
        //联系人
        NSString* companyIndexSql = @"CREATE INDEX time_index1 ON COMPANYINFO(addtime)";
        //            sqlite> CREATE INDEX testtable_idx ON testtable(first_col);
        //            --创建联合索引，该索引基于某个表的多个字段，同时可以指定每个字段的排序规则(升序/降序)。
        //            sqlite> CREATE INDEX testtable_idx2 ON testtable(first_col ASC,second_col DESC);
        BOOL res = [db executeUpdate:companyInfoSql];
        res = [db executeUpdate:companyIndexSql];
        if (!res) {
            NSLog(@"公司信息表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"公司信息表创建成功");
        }
        
        res = [db executeUpdate:userSql];
        NSString* friendListIndex = @"CREATE INDEX time_index2 ON userData(userID,lcid)";
        res = [db executeUpdate:friendListIndex];
        //
        //            friendListIndex = @"CREATE INDEX tel_index ON userData(tel)";
        //            res = [_db executeUpdate:friendListIndex];
        
        if (!res) {
            NSLog(@"朋友列表表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"朋友列表表创建成功");
        }
        
        [db executeUpdate:@"INSERT INTO userData (tel,lcid,userID) values('4','4',4),('6','6',6),('7','7',7)"];
        
        //2.0新增索引
        NSString* channelIndex = @"CREATE INDEX channelIndex ON channelData(conID,userID,unreadNums)";
        res = [db executeUpdate:channelSql];
        if (!res) {
            NSLog(@"信道表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"信道表创建成功");
        }
        [db executeUpdate:channelIndex];
        
        NSString* momentListIndex = @"CREATE INDEX time_index3 ON momentData(addTime,fid,mid)";
        res = [db executeUpdate:momentSql];
        res = [db executeUpdate:momentListIndex];
        if (!res) {
            NSLog(@"圈子表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"圈子表创建成功");
        }
        
        res = [db executeUpdate:chatDataSql];
        if (!res) {
            NSLog(@"聊天内容表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"聊天内容表创建成功");
        }
        NSString* chatIndex = @"CREATE INDEX time_index5 ON chatData(uid,chatType,addTime)";
        res = [db executeUpdate:chatIndex];
        
        
        NSString* historyIndex = @"CREATE INDEX time_index4 ON historyData(updataTime)";
        res = [db executeUpdate:historySql];
        res = [db executeUpdate:historyIndex];
        if (!res) {
            NSLog(@"历史表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"历史表创建成功");
        }
        
        NSString* eventIndexSql = @"CREATE INDEX time_index6 ON eventData(status)";
        
        res = [db executeUpdate:eventSql];
        res = [db executeUpdate:eventIndexSql];
        
        if (!res) {
            NSLog(@"待处理事件表创建失败");
            NSLog(@"%@",db.lastErrorMessage);
        } else {
            NSLog(@"待处理事件表创建成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [initWithBaseData initWithv2];
        });
    }];
}




@end
