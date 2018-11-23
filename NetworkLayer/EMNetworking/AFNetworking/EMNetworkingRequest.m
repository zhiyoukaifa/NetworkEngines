//
//  EMNetworkingRequest.m
//  NetworkLayer
//
//  Created by 张三 on 2018/11/13.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import "EMNetworkingRequest.h"
#import "AFNetworking.h"

@interface EMNetworkingRequest()


@end


@implementation EMNetworkingRequest


+ (instancetype)sharedRequest
{
    static EMNetworkingRequest *sharedRequest = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        sharedRequest = [[self alloc] init];
    });
    return sharedRequest;
}


#pragma mark - public
- (NSURLSessionDataTask *)POSTNetworkingRequest:(NSString *)URLString
                                     parameters:(id)parameters
                                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *task = [self.sessionManager POST:URLString
                                                parameters:parameters
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                       success(task,responseObject);
                                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                       failure(task,error);
                                                   }];
    return task;
}

- (NSURLSessionDataTask *)GETNetworkingRequest:(NSString *)URLString
                                    parameters:(id)parameters
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *task = [self.sessionManager GET:URLString
                                               parameters:parameters
                                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      success(task,responseObject);
                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                       failure(task,error);
                                                  }];
    return task;
}
- (NSURLSessionDataTask *)POSTUploadFiles:(NSString *)URLString
                               parameters:(id)parameters
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *task = [self.sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:block
        
    success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(task,error);
    }];
    return task;
}
//zs20181113  同步请求数据 拿的之前的代码 当前做刷新token操作
- (NSDictionary*)connectSync:(NSString*)urlString parameters:(NSDictionary*)parameters
{
    __block NSDictionary *dicValue = nil;
    dispatch_semaphore_t disp = dispatch_semaphore_create(0); //信号量
    
    AFHTTPRequestSerializer* requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:parameters  error:nil];

    [request setTimeoutInterval:15.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError*error){
        if (error.code != 0) {
            dicValue = nil;
            dispatch_semaphore_signal(disp);
            
        }else{
            dicValue = error ? : [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_semaphore_signal(disp);
        }
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
    return dicValue;
}

#pragma mark ------ zs20181114 监控网络状态
- (void)monitorNetworkingStatus:(void (^)(NSInteger status, id responseObject))result
{
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];//zs1201
    
        /**zs1201设计思想
         * 这个方法调用一回就行啦 它就会实施监听网络状态
         * 之后我们通过保存到本地的NetStatus 进行判断
         * 当前只需要判断有网和无网
         */
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
            result(status,nil);
        }];
    
        [manager startMonitoring];
}


#pragma mark - set get
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        
        _sessionManager = [AFHTTPSessionManager manager];//manager 也是每次都创建
        //      zs20181112 返回数据自动解析 当前没有解析 返回的是二进制  https://www.cnblogs.com/Mr-zyh/p/5853797.html
        [_sessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [[_sessionManager responseSerializer] setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/png", nil]];
        [[_sessionManager requestSerializer] setTimeoutInterval:15.0];

    }
    return _sessionManager;
}







@end
