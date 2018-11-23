//
//  EMNetworkingUIHandle.m
//  MobileFixCar
//
//  Created by 张三 on 2018/11/14.
//  Copyright © 2018年 全球e家电子商务有限公司. All rights reserved.
//

#import "EMNetworkingUIHandle.h"
#import <UIKit/UIKit.h>
@interface EMNetworkingUIHandle()

@property (nonatomic, strong) UIActivityIndicatorView *viewIndicator;       /**<zs20181114  指示器 */

@property (nonatomic, strong) NSMutableDictionary *dicIndicator;       /**<zs20181116  存储指示器的字典 */

@end

@implementation EMNetworkingUIHandle


+ (instancetype)sharedHandle {
    
    static EMNetworkingUIHandle *sharedHandle = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        sharedHandle = [[self alloc] init];
    });
    return sharedHandle;
}

#pragma mark ------ public
- (NSString*)showIndicator
{
    UIViewController *currentVC = [self getCurrentController];
    UIView *view = [currentVC view];
    NSString *strClass = NSStringFromClass([currentVC class]);
    //zs20181116 同一个页面 只创建一个
    UIActivityIndicatorView *viewIndicator = self.dicIndicator[strClass];
    if (viewIndicator) {
        
        [viewIndicator startAnimating];
    } else {
        
         viewIndicator = [self newViewIndicator];
         [view addSubview:viewIndicator];
         [viewIndicator startAnimating];
         [self.dicIndicator setObject:viewIndicator forKey:strClass];
    }
    return strClass;
}
- (void)hiddenIndicator:(NSString*)strCurrentVCName
{
    UIActivityIndicatorView *viewIndicator = self.dicIndicator[strCurrentVCName];
    [viewIndicator stopAnimating];
    [viewIndicator removeFromSuperview];
    if (strCurrentVCName) {
        [self.dicIndicator removeObjectForKey:strCurrentVCName];
    }
}
- (void)removeAlertMessageOnHttpFailure
{
}
- (UIActivityIndicatorView *)newViewIndicator
{
    UIActivityIndicatorView *viewIndicator = [[UIActivityIndicatorView alloc] init];
    [viewIndicator setCenter:CGPointMake([[UIScreen mainScreen]bounds].size.width/2.0, [[UIScreen mainScreen]bounds].size.height/2.0)];//zs20181114 位置写死了
    [viewIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    return viewIndicator;
}


//zs20181123 获取的当前controller 自己封装去
- (UIViewController*)getCurrentController
{
    
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIViewController * VC = [self getVisibleViewControllerFrom:rootViewController];
    return VC;
}
- (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}




#pragma mark - get set
- (NSMutableDictionary *)dicIndicator
{
    if (_dicIndicator == nil) {
        
        _dicIndicator = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dicIndicator;
}

@end
