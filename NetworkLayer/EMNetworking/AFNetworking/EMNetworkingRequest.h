//
//  EMNetworkingRequest.h
//  NetworkLayer
//
//  Created by 张三 on 2018/11/13.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
NS_ASSUME_NONNULL_BEGIN


/**
 zs20181113 直接面向AFNetworking中的API 此类中不应该涉及任何其他类 所有的网络请求 最终都会进入这个类处理
 */
@interface EMNetworkingRequest : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;      /**<zs20181112  请求管理器*/

+ (instancetype)sharedRequest;



- (NSURLSessionDataTask *)POSTNetworkingRequest:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



- (NSURLSessionDataTask *)GETNetworkingRequest:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask *)POSTUploadFiles:(NSString *)URLString
                               parameters:(id)parameters
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


//zs20181113 同步请求 当前用于获取新token
- (NSDictionary*)connectSync:(NSString*)urlString parameters:(NSDictionary*)parameters;



/**
 zs20181114  持续监控网络状态

 @param result 结果block
 */
- (void)monitorNetworkingStatus:(void (^)(NSInteger status, id responseObject))result;


@end

NS_ASSUME_NONNULL_END
