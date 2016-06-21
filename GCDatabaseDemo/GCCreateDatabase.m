//
//  GCCreateDatabase.m
//  GongChangSupplier
//
//  Created by sky on 14-6-16.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//


#import "GCCreateDatabase.h"
#import "GCDataBaseManager.h"

@implementation GCCreateDatabase{
    NSString* dbVersion;
}

- (id) init {
    self = [super init];
    if (self) {
        dbVersion = @"2.0.0";
    }
    return self;
}

-(void)createDatabaseWithName:(NSString* )dbName{
    [[GCDataBaseManager defaultDBManager] setDataBaseName:dbName];
    if (![self checkIsExist:@"channelData" columName:nil]) [self createBaseDataBase];
    else  NSLog(@"已经创建数据库");
}

//创建数据库版本2.0
-(void)createBaseDataBase{
        NSString* channelSql = @"CREATE TABLE IF NOT EXISTS channelData (userID INTEGER, conID VARCHAR(24),fromID VARCHAR(24),toID VARCHAR(24), fromName VARCHAR(20),toName VARCHAR(20),fromImage VARCHAR(50),toImage VARCHAR(50),chatType INTEGER,lastMsg VARCHAR(50),updataTime INTEGER,unreadNums INTEGER,getNewMsg BIT,PRIMARY KEY (toID,chatType))";
        //2.0增加字段 attrs json
        NSString* chatDataSql = @"CREATE TABLE IF NOT EXISTS chatData (uid INTEGER,mid VARCHAR(20) PRIMARY KEY,addTime INTEGER, content VARCHAR(300),type INTEGER,timeLenth VARCHAR(10),sender BIT,status BIT,chatType BIT,isRead BIT,retryTimes,attrs VARCAR(0),conID VARCHAR(24))";
        
        NSString* userSql = @"CREATE TABLE IF NOT EXISTS userData (tel VARCHAR(11),userID VARCHAR(24) PRIMARY KEY,location VARCHAR(20) ,userName VARCHAR(20),userNickName VARCHAR(20),headerImageUrl VARCHAR(100),type INTEGER,lcid VARCHAR(24),position VARCHAR(16),company VARCHAR(20),department VARCHAR(20),sex BIT,nameS VARCHAR(10),nameF VARCHAR(20),email VARCHAR(20),updataTime VARCHAR(20),markName VARCHAR(10))";
    
        BOOL res = [self executeUpdateSql:userSql];
        if (!res) {
            NSLog(@"朋友列表表创建失败");
        } else {
            NSLog(@"朋友列表表创建成功");
        }
        NSString* friendListIndex = @"CREATE INDEX time_index2 ON userData(userID,lcid)";
        res = [self executeUpdateSql:friendListIndex];

        //2.0新增索引
        NSString* channelIndex = @"CREATE INDEX channelIndex ON channelData(conID,userID,unreadNums)";
        res = [self executeUpdateSql:channelSql];
        if (!res) {
            NSLog(@"信道表创建失败");
        } else {
            NSLog(@"信道表创建成功");
        }
        [self executeUpdateSql:channelIndex];
        
        res = [self executeUpdateSql:chatDataSql];
        if (!res) {
            NSLog(@"聊天内容表创建失败");
        } else {
            NSLog(@"聊天内容表创建成功");
        }
        NSString* chatIndex = @"CREATE INDEX time_index5 ON chatData(uid,chatType,addTime)";
        res = [self executeUpdateSql:chatIndex];
}

-(void)close{
    [[GCDataBaseManager defaultDBManager] close];
}



@end
