//
//  EMNetworkingResponseObj.h
//  NetworkLayer
//
//  Created by 张三 on 2018/11/13.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMOperationObj;


NS_ASSUME_NONNULL_BEGIN


/**
 zs20181113 网络请求 返回的数据对象
 */
@interface EMNetworkingResponseObj : NSObject

@property (nonatomic, strong) EMOperationObj *operationObj;     /**<zs20181113 操作对象（请求参数相关信息）*/

@property (nonatomic, strong) NSDictionary * __nullable dicResponse;        /**<zs20181113 网络请求响应数据 */

@property (nonatomic, strong) NSError *error;       /**<zs20181112 保存错误信息 收到返回数据的时候 是否成功 以这个为准 而不是以operationObj中的error为准*/

@property (nonatomic, strong) id responseDataOnGet;     /**<zs20181114 Get 请求的时候 返回的数据 */

@end

NS_ASSUME_NONNULL_END
