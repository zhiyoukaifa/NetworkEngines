//
//  EMOperationObj.h
//  NetworkLayer
//
//  Created by 张三 on 2018/11/12.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMNetworkingResponseObj.h"

@class EMOperationObj;
@class EMNetworkingResponseObj;


NS_ASSUME_NONNULL_BEGIN



/**zs20181112
 * operationObjResponseBlock  接口相应数据
 * operationObjProgressBlock  进度响应
 */
typedef void(^operationObjResponseBlock)(EMNetworkingResponseObj *__nullable responseObj);
typedef void(^operationObjProgressBlock)(EMNetworkingResponseObj *__nullable responseObj);



//zs20181112 HTTP请求方法
typedef NS_ENUM(NSInteger,EMOperationObjRequestMethod){
    
    EMOperationObjRequestMethodPOST = 0,
    EMOperationObjRequestMethodGET = 1
};




/**
 zs20181112 封装的网络请求操作对象
 */
@interface EMOperationObj : NSObject

@property (nonatomic, copy) NSString *strURL;

@property (nonatomic, strong) NSDictionary * __nullable dicParameters;      /**<zs20181112 接口参数 */

@property (nonatomic, assign) BOOL isShowIndicator;     /**<zs20181114 是否展示小菊花 */

@property (nonatomic, assign) EMOperationObjRequestMethod methodType;       /**<zs20181112f HTTP请求方法 */

@property (nonatomic, assign) NSInteger timeoutInterval;        /**<zs20181112 超时时间  */

@property (nonatomic, strong) NSError *error;       /**<zs20181112 保存错误信息 放在操作对象里 是想要记录失败队列的时候 通过obj的error 判断请求失败的原因 */

@property (nonatomic, assign) NSURLSessionDataTask *sessionDataTask;       /**<zs20181112 请求的任务 */

@property (nonatomic, assign) NSInteger count;      /**<zs20181112 统计被执行的次数 超过次数需要移除*/

@property (nonatomic, copy) operationObjResponseBlock operationObjResponseBlock;

@property (nonatomic, copy) operationObjProgressBlock operationObjProgressBlock;

@property (nonatomic, copy) NSString *strCurrentVCName;     /**<zs20181116  当前controller 的类名  当前用于处理菊花指示器*/

@end

NS_ASSUME_NONNULL_END
