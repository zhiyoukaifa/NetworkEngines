//
//  EMNetworkingManager.h
//  NetworkLayer
//
//  Created by 张三 on 2018/11/12.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMOperationObj.h"
#import "EMUploadImageOperationObj.h"
#import "EMRecordingOperationObj.h"
#import "EMNetworkingResponseObj.h"


NS_ASSUME_NONNULL_BEGIN


/**
 zs20181112 网络请求类 中介者模式中的中介者角色：管理操作对象 业务处理对象  网络请求对象  这三者之间没有耦合
 */
@interface EMNetworkingManager : NSObject

+ (instancetype)sharedManager;



/**
 zs20181112 进行GET POST网络请求

 @param operationObj 请求参数操作对象
 */
- (void)requestWithOperationObj:(EMOperationObj*)operationObj;




/**
  zs20181115 上传单张图片

 @param operationObj 操作对象
 */
- (void)requestUploadSingleImage:(EMUploadImageOperationObj*)operationObj;


/**
 zs20181115 上传多张图片

 @param operationObj 操作对象
 */
- (void)requestUploadImages:(EMUploadImageOperationObj*)operationObj;



/**
 zs20181115  请求上传录音数据

 @param operationObj 操作对象
 */
- (void)requestUploadRecordingData:(EMRecordingOperationObj*)operationObj;


/**
 zs20181112 取消某个任务

 @param sessionDataTask 任务
 */
- (void)cancelRequestWithSessionDataTask:(NSURLSessionDataTask*)sessionDataTask;



/**
 zs20181114 同步请求 当前用于token 超时 重新登录 （此方法当前只有商城使用）

 @param operationObj 操作对象
 @return 同步返回数据
 */
- (NSDictionary*)requestSynchronizeWithOperationObj:(EMOperationObj*)operationObj;



/**
 zs20181114 持续监控当前网络
 */
- (void)monitorNetworkingStatus;


@end

NS_ASSUME_NONNULL_END
