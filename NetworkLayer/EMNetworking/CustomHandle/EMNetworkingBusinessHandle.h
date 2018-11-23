//
//  EMNetworkingBusinessHandle.h
//  NetworkLayer
//
//  Created by 张三 on 2018/11/13.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const NSInteger kEMNetworkingBusinessHandleContinueRun = 1024;      /**<zs20181114 返回未登录的状态 token没有传值*/
/**
 zs20181113 网络层请求数据后的业务处理
 */
@interface EMNetworkingBusinessHandle : NSObject

+ (instancetype)sharedHandle;

/**
 zs20181113 处理项目中自定义的情况 关联到具体业务了

 @param dicResponse 返回的数据
 */
- (void)handleProjectCustomCases:(NSDictionary*)dicResponse withURL:(NSString*)strURL response:(void (^)(NSInteger code, id responseObject))result;



/**
 zs20181113 当获取新的token的时候 处理相关的业务

 @param dicResponse 获取token返回的数据
 @return YES token获取成功
 */
- (BOOL)handleRelatedEventOnLoadedNewToken:(NSDictionary*)dicResponse;



/**
 zs20181115 当网络状态变化的时候 处理网络事务

 @param status 参考AFNetworking网络状态值
 */
- (void)handleBusinessOnNetStatusChange:(NSInteger)status;



@end

NS_ASSUME_NONNULL_END
