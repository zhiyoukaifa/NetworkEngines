//
//  EMNetworkingBusinessHandle.m
//  NetworkLayer
//
//  Created by 张三 on 2018/11/13.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import "EMNetworkingBusinessHandle.h"



@implementation EMNetworkingBusinessHandle


+ (instancetype)sharedHandle {
    
    static EMNetworkingBusinessHandle *sharedHandle = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        sharedHandle = [[self alloc] init];
    });
    return sharedHandle;
}


#pragma mark - public
- (void)handleProjectCustomCases:(NSDictionary*)dicResponse withURL:(NSString*)strURL response:(void (^)(NSInteger code, id responseObject))result
{
    /**
     * zs20181123 处理自己的业务..........
     */
    result(kEMNetworkingBusinessHandleContinueRun,nil);
}

- (BOOL)handleRelatedEventOnLoadedNewToken:(NSDictionary*)dicResponse
{
    /**
     * zs20181123 处理自己的业务..........
     */
    return YES;
}

- (void)handleBusinessOnNetStatusChange:(NSInteger)status
{
   
/*zs20181115 此处为了解耦 将枚举值直接切换成数字 如果AFNetworking 更新 注意此处的枚举是否变更
    AFNetworkReachabilityStatusUnknown          = -1,
    AFNetworkReachabilityStatusNotReachable     = 0,
    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    AFNetworkReachabilityStatusReachableViaWiFi = 2,
*/
    NSInteger netStatus = 0;
    switch (status) {
            
        case -1://NSLog(@"未识别的网络");
            
            netStatus = -1;
            
            break;
            
        case 0: {// NSLog(@"不可达的网络(未连接)");
            
            netStatus = 0;
        }
            break;
            
        case 1: {//zs0129 有网的时候需要刷新一下 轮播广告 NSLog(@"2G,3G,4G...的网络");
            netStatus = 1;
        }
            break;
            
        case 2: {//      NSLog(@"wifi的网络");
            netStatus = 2;
        }
            break;
        default:
            break;
    }
}











@end
