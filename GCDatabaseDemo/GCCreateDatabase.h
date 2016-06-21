//
//  GCCreateDatabase.h
//  GongChangSupplier
//
//  Created by sky on 14-6-16.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//

#import "baseDatabase.h"

@interface GCCreateDatabase : baseDatabase
{
    
}

-(void)createDatabaseWithName:(NSString* )dbName;

-(void)close;

@end
