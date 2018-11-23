//
//  EMOperationObj.m
//  NetworkLayer
//
//  Created by 张三 on 2018/11/12.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import "EMOperationObj.h"


@interface EMOperationObj()<NSCopying>


@end

static const NSInteger kTimeoutInterval = 15;



@implementation EMOperationObj


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.timeoutInterval = kTimeoutInterval;
    }
    return self;
}

//zs20181112 实现NSCopying 协议 重写copy 方法
- (id)copyWithZone:(NSZone *)zone
{
    EMOperationObj *obj = [[[self class] alloc] init];
    obj.strURL = self.strURL;
    obj.methodType = self.methodType;
    obj.timeoutInterval = self.timeoutInterval;
    obj.dicParameters = self.dicParameters;
    obj.error = self.error;
//    obj.taskID = self.taskID;
    obj.sessionDataTask = self.sessionDataTask;
    obj.count = self.count;

    return obj;
}



- (NSString *)description
{
    NSString *strDescription = [NSString stringWithFormat:
                                @"\n strURL=%@\n methodType=%zi\n timeoutInterval=%zi\n dicParameters=%@\n count=%zi\n  error=%@\n ",
                                self.strURL, self.methodType, self.timeoutInterval,self.dicParameters,self.count,self.error.description];
    return strDescription;
}


@end
