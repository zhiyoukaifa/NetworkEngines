//
//  EMNetworkingUIHandle.h
//  MobileFixCar
//
//  Created by 张三 on 2018/11/14.
//  Copyright © 2018年 全球e家电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 zs20181114 网络请求中的通用UI处理
 */
@interface EMNetworkingUIHandle : NSObject


+ (instancetype)sharedHandle;

- (NSString*)showIndicator;

- (void)hiddenIndicator:(NSString*)strCurrentVCName;


/**
 zs20181114 移除“加载中”类似的提示框
 */
- (void)removeAlertMessageOnHttpFailure;

@end

NS_ASSUME_NONNULL_END
