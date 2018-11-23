//
//  ViewController.m
//  NetworkLayer
//
//  Created by 张三 on 2018/11/12.
//  Copyright © 2018年 e家机械. All rights reserved.
//

#import "ViewController.h"
#import "EMOperationObj.h"
#import "EMNetworkingManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {

     [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"发送请求" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(200, 200, 100, 100);
    [btn addTarget:self action:@selector(onClickBtns) forControlEvents:(UIControlEventTouchUpInside)];
}


//zs20181112 相当于Biz里面的请求 
- (void)onClickBtns
{
    //创建个网络请求
    EMOperationObj *operationObj = [[EMOperationObj alloc] init];
    operationObj.strURL = @"https://m.kankanews.com/n/1_8657763.html?utm_source=baijia";//zs20181123 自己去配
    operationObj.methodType = EMOperationObjRequestMethodGET;
    operationObj.dicParameters = nil;
    operationObj.isShowIndicator = YES;
    [[EMNetworkingManager sharedManager] requestWithOperationObj:operationObj];
    
//    __weak EMOperationObj *weakOperationObj = operationObj;
    
    [operationObj setOperationObjResponseBlock:^(EMNetworkingResponseObj * _Nullable responseObj) {
    
        if (!responseObj.error) {
            
            NSLog(@"dicResponse___%@___%@",responseObj.responseDataOnGet,responseObj.operationObj);
        } else {
            
            NSLog(@"dicResponse___%@____%@",responseObj.dicResponse,responseObj.operationObj.error.description);
        }
    }];

  
    
}

@end
