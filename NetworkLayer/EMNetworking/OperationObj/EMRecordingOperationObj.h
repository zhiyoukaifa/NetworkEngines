//
//  EMRecordingOperationObj.h
//  MobileFixCar
//
//  Created by 张三 on 2018/11/15.
//  Copyright © 2018年 全球e家电子商务有限公司. All rights reserved.
//

#import "EMOperationObj.h"

NS_ASSUME_NONNULL_BEGIN


/**
 zs20181115  上传录音操作对象
 */
@interface EMRecordingOperationObj : EMOperationObj

@property (nonatomic, strong) NSData *dataRecording;        /**<zs20181115 录音数据 */

@end

NS_ASSUME_NONNULL_END
