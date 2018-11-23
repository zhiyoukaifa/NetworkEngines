//
//  EMUploadImageOperationObj.h
//  MobileFixCar
//
//  Created by 张三 on 2018/11/15.
//  Copyright © 2018年 全球e家电子商务有限公司. All rights reserved.
//

#import "EMOperationObj.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


/**
 zs20181115 上传图片 操作对象
 */
@interface EMUploadImageOperationObj : EMOperationObj

@property (nonatomic, strong) UIImage *image;       /**<zs20181115 单张图片  对应单张图片上传 requestUploadSingleImage*/

@property (nonatomic, strong) NSArray *arrayImages;     /**<zs20181115 图片数组 */

@property (nonatomic, assign) float compressionRatio;       /**<zs20181115  图片压缩比例  */

@end

NS_ASSUME_NONNULL_END
