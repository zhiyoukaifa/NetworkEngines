//
//  EMNetworkingManager.m
//  NetworkLayer
//
//  Created by 张三 on 2018/11/12.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import "EMNetworkingManager.h"
#import "EMNetworkingRequest.h"
#import "EMNetworkingBusinessHandle.h"
#import "EMNetworkingUIHandle.h"

static const int8_t kNumberOperationOnTokenTimeout = 10; //zs20181113 网络超时请求操作 保存的最大的数量


@interface EMNetworkingManager()

@property (nonatomic, strong) NSMutableArray<EMOperationObj*> *arrayOperations;/**<zs20181112 请求操作数组 当前做记录 为了方便取消某个请求*/

@property (nonatomic, strong) NSMutableArray<EMOperationObj*> *arrayTokenTimeoutOperations;/**<zs20181113 记录返回数据code==120 即token超时的操作对象 */

@property (nonatomic, strong) NSMutableArray<EMOperationObj*> *arrayHttpErrorOperations;     /**<zs20181114 网络请求错误的操作对象数组*/

@end

@implementation EMNetworkingManager

+ (instancetype)sharedManager {
    
    static EMNetworkingManager *sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
       
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - public
#pragma mark ------ zs20181114 所有的GET POST 请求入口
- (void)requestWithOperationObj:(EMOperationObj*)operationObj
{
    [self loadRelatedUI:operationObj];
    
    [self.arrayOperations addObject:operationObj];
    
    [self addRequestHeaderMessage:operationObj];
    
    if (operationObj.methodType == EMOperationObjRequestMethodGET) {
        
        [self requestWithGETMethod:operationObj];
    } else if (operationObj.methodType == EMOperationObjRequestMethodPOST){
        
        [self requestWithPostMethod:operationObj];
    }
}

- (void)requestUploadImages:(EMUploadImageOperationObj*)operationObj
{
    [self addRequestHeaderMessage:operationObj];
    
    [[EMNetworkingRequest sharedRequest] POSTUploadFiles:operationObj.strURL parameters:operationObj.dicParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *image in operationObj.arrayImages) {
            NSData *imageData = UIImageJPEGRepresentation(image, operationObj.compressionRatio);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"text.png"mimeType:@"image/jpg/png/jpeg"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSError *error = nil;
        NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            
            [self responseMessage:dicResponse withOperation:operationObj];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [self reponseRequestFailure:error withOperation:operationObj];
    }];
}

- (void)requestUploadSingleImage:(EMUploadImageOperationObj*)operationObj
{
    operationObj.arrayImages = [NSArray arrayWithObjects:operationObj.image, nil];
    [self requestUploadImages:operationObj];
}
- (void)requestUploadRecordingData:(EMRecordingOperationObj*)operationObj
{
    [self addRequestHeaderMessage:operationObj];

    [[EMNetworkingRequest sharedRequest] POSTUploadFiles:operationObj.strURL parameters:operationObj.dicParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:operationObj.dataRecording name:@"file" fileName:@"text.amr" mimeType:@"audio/mpeg3"];

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSError *error = nil;
        NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            [self responseMessage:dicResponse withOperation:operationObj];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [self reponseRequestFailure:error withOperation:operationObj];
    }];
}

- (void)cancelRequestWithSessionDataTask:(NSURLSessionDataTask*)sessionDataTask;
{
    for (EMOperationObj *operationObj in self.arrayOperations) {
        
        if (operationObj.sessionDataTask == sessionDataTask) {
        
            [operationObj.sessionDataTask cancel];
        }
    }
}
#pragma mark ------ zs20181114 同步请求 通过网络管理器 统一管理 不会让客户端直接调用 EMNetworkingRequest
- (NSDictionary*)requestSynchronizeWithOperationObj:(EMOperationObj*)operationObj
{
    return [[EMNetworkingRequest sharedRequest] connectSync:operationObj.strURL parameters:operationObj.dicParameters];
}
- (void)monitorNetworkingStatus
{    
    [[EMNetworkingRequest sharedRequest] monitorNetworkingStatus:^(NSInteger status, id  _Nonnull responseObject) {
      
        [[EMNetworkingBusinessHandle sharedHandle]  handleBusinessOnNetStatusChange:status];
    }];
}


#pragma mark - private
#pragma mark ------ zs20181112 Post 请求
- (void)requestWithPostMethod:(EMOperationObj*)operationObj
{
      operationObj.sessionDataTask = [[EMNetworkingRequest sharedRequest]  POSTNetworkingRequest:operationObj.strURL parameters:operationObj.dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *dicResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
         
            [self responseMessage:dicResponse withOperation:operationObj];
        } else {
            
            [self responseMessageOnSerializationFailure:operationObj];
        }
        
        [self removeOperationObjOnArrayOperations:operationObj];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self reponseRequestFailure:error withOperation:operationObj];
    }];
    
}
#pragma mark ------ zs20181112 Get 请求  !!!当前还没有用 没有进行测试 ！！！
- (void)requestWithGETMethod:(EMOperationObj*)operationObj
{
    operationObj.sessionDataTask = [[EMNetworkingRequest sharedRequest] GETNetworkingRequest:operationObj.strURL parameters:operationObj.dicParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self hiddenIndicator:operationObj];
        if (operationObj.operationObjResponseBlock) {
            
            EMNetworkingResponseObj *responseObj = [[EMNetworkingResponseObj alloc] init];
            responseObj.operationObj = [operationObj copy];//zs20181113 传入的操作对象和返回的操作对象脱离关系
            responseObj.responseDataOnGet = responseObject;
            NSError *error = nil;
            NSDictionary *dicResponse   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                responseObj.dicResponse = dicResponse;
            }
            operationObj.operationObjResponseBlock(responseObj);
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [self reponseRequestFailure:error withOperation:operationObj];
    }];
}
#pragma mark ------ zs20181112 正常返回信息
- (void)responseMessage:(NSDictionary*)dicResponse withOperation:(EMOperationObj*)operationObj
{
    [self hiddenIndicator:operationObj];
    //zs20181113 进行项目定义的业务逻辑的相关处理  处理项目中定义的网络事务 关联业务了
    [[EMNetworkingBusinessHandle sharedHandle] handleProjectCustomCases:dicResponse withURL:operationObj.strURL response:^(NSInteger code, id  _Nonnull responseObject) {
        
        if (code == kEMNetworkingBusinessHandleContinueRun) {
            
            if (operationObj.operationObjResponseBlock) {
                
                EMNetworkingResponseObj *responseObj = [[EMNetworkingResponseObj alloc] init];
                responseObj.operationObj = [operationObj copy];//zs20181113 传入的操作对象和返回的操作对象脱离关系
                responseObj.dicResponse = dicResponse;
                operationObj.operationObjResponseBlock(responseObj);
            }
        } //else 根据自己的业务还有其他情况
    }];
}
#pragma mark ------ zs20181112 json 解析失败 无业务操作直接返回
- (void)responseMessageOnSerializationFailure:(EMOperationObj*)operationObj
{
    [self hiddenIndicator:operationObj];

    if (operationObj.operationObjResponseBlock) {
       
        EMNetworkingResponseObj *responseObj = [[EMNetworkingResponseObj alloc] init];
        responseObj.operationObj = [operationObj copy];
        
        NSDictionary *dicResponse = @{@"message":@"未获取到相关数据",//数据序列化失败
                                      @"status":@0
                                      };
        responseObj.dicResponse = dicResponse;
        operationObj.operationObjResponseBlock(responseObj);
    }
}
#pragma mark ------ zs20181112 http 请求报错
- (void)reponseRequestFailure:(NSError *)error withOperation:(EMOperationObj*)operationObj
{
    [self hiddenIndicator:operationObj];
    [[EMNetworkingUIHandle sharedHandle] removeAlertMessageOnHttpFailure];
    
     operationObj.error = error;
    [self removeOperationObjOnArrayOperations:operationObj];
    
    if (operationObj.operationObjResponseBlock) {
      
        EMOperationObj *obj = [operationObj copy];
        EMNetworkingResponseObj *responseObj = [[EMNetworkingResponseObj alloc] init];
        responseObj.operationObj = obj;
        responseObj.dicResponse = nil;
        responseObj.error = error;
        operationObj.operationObjResponseBlock(responseObj);
    }
}
- (void)removeOperationObjOnArrayOperations:(EMOperationObj*)operationObj
{
    [self.arrayHttpErrorOperations addObject:operationObj];
    [self.arrayOperations removeObject:operationObj];
}

#pragma mark ------ zs20181113 维护因为token超时导致的请求失败的操作对象数组
- (void)maintainArrayOnTokenTimeout:(EMOperationObj*)operationObj
{
    if (self.arrayTokenTimeoutOperations.count == 0) {
        
        [self.arrayTokenTimeoutOperations addObject:operationObj];//zs20181113 记录由于token超时失败的请求
    } else {

        for (EMOperationObj *obj in self.arrayTokenTimeoutOperations) {
            
            if ([obj.strURL isEqualToString:operationObj.strURL]) {
                return;
            }
        }
        if (self.arrayTokenTimeoutOperations.count >= kNumberOperationOnTokenTimeout) {
            
            [self.arrayTokenTimeoutOperations removeObjectAtIndex:0];
            [self.arrayTokenTimeoutOperations addObject:operationObj];
        } else {
            [self.arrayTokenTimeoutOperations addObject:operationObj];
        }
    }
}
#pragma mark ------ zs20181113 获取新token 
- (void)updateToken
{
  //业务代码
}

#pragma mark ------ 添加请求头信息
- (void)addRequestHeaderMessage:(EMOperationObj*)opeartionObj
{
   
}
#pragma mark - 网络层UI处理
- (void)loadRelatedUI:(EMOperationObj*)opeartionObj
{
    if (opeartionObj.isShowIndicator) {
        opeartionObj.strCurrentVCName = [[EMNetworkingUIHandle sharedHandle] showIndicator];
    }
}
- (void)hiddenIndicator:(EMOperationObj*)opeartionObj
{
    [[EMNetworkingUIHandle sharedHandle] hiddenIndicator:opeartionObj.strCurrentVCName];
}


#pragma mark - get set
- (NSMutableArray<EMOperationObj *> *)arrayOperations
{
    if (_arrayOperations == nil) {
        
        _arrayOperations = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrayOperations;
}
- (NSMutableArray<EMOperationObj *> *)arrayTokenTimeoutOperations
{
    if (_arrayTokenTimeoutOperations == nil) {
        
        _arrayTokenTimeoutOperations = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrayTokenTimeoutOperations;
}
- (NSMutableArray<EMOperationObj *> *)arrayHttpErrorOperations
{
    if (_arrayHttpErrorOperations == nil) {
        
        _arrayHttpErrorOperations = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrayHttpErrorOperations;
}





@end
