//
//  AppDelegate.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/23.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "AppDelegate.h"
#import "ShareTools.h"
#import "Reachability.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [SVProgressHUD setBackgroundColor:kAppBgColor];
    [ShareTools initShare];//分享
    
    self.window.backgroundColor = kAppBgColor;
    
    [UINavigationBar appearance].barTintColor=[UIColor colorWithRed:245/255.0  green:245/255.0  blue:245/255.0 alpha:1];
    
    [self getRequestID];
    
    return YES;
}
                  
//TODO:判断是否登陆
//- (void)isEmptyOfKeyChain
//{
//    if(![keychainItemManager readSessionId])
//    {
//        //如果为空就调用登陆控制器
//        [self gotoLogingWithSuccess:^(BOOL isSuccess)
//         {
//             if (isSuccess)
//             {
//                 [self makeToast:@"登录成功"];
//             }
//         }class:@"LoginVC"];
//    }
//    
//}


//TODO:测试时间
- (void)getRequestID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.10f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    
    NSString *requestId = [dateTime stringByAppendingString:randompassword];
    NSLog(@"random : %f",random);
    NSLog(@"randomString : %@",randomString);
    NSLog(@"randompassword : %@",randompassword);
    NSLog(@"requestId : %@",requestId);
}

/*----------------------------*/
//TODO:开启网路监听
- (void)openNetworkingReachability
{
    // 开启网络状态的监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    // 初始化一个网络监听的对象
     Reachability* hostReach = [Reachability reachabilityForInternetConnection];
    [hostReach startNotifier];// 开启一个监听

}
// 查看帮助文档
-(void)checkHelpVersion
{
    // 检查自带的帮助文档版本高于已经更新过的版本时，删除更新的帮助文档
    if(HELP_VER>=[NS_USERDEFAULT integerForKey:@"help_version"]){
        [NS_USERDEFAULT setInteger:HELP_VER forKey:@"help_version"];
        [NS_USERDEFAULT synchronize];
        dispatch_async(dispatch_queue_create(0,0), ^{
            NSFileManager *fileMan = [NSFileManager defaultManager];
            [fileMan removeItemAtPath:getPathInDocument(@"help") error:nil];
        });
    }
}

// 网络连接改变
- (void) reachabilityChanged:(NSNotification* )note
{
    Reachability* curReach = [note object];
    if([curReach isKindOfClass:[Reachability class]])
    {
        //从钥匙串中获取SessionId
        if([curReach isReachable]&&IsEmpty(((NSString*)[keychainItemManager readSessionId])))
        {
            //版本号查询
            
            //查询成功后保存信息
            [UtilMethod saveVersionInfo:nil];
            
        }

    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"0result = %@",resultDic);
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:url.host message:nil delegate:nil cancelButtonTitle:@"1" otherButtonTitles:@"2", nil];
            [a show];

        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"1result = %@",resultDic);
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:url.host message:nil delegate:nil cancelButtonTitle:@"1" otherButtonTitles:@"2", nil];
            [a show];
        }];
    }
    return YES;
}
/*----------------------------*/
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
