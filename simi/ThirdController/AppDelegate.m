//
//  AppDelegate.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "RootViewController.h"
#import "DatabaseManager.h"
#import "APService.h"
#import "GuideViewController.h"
#import "BaiduMobStat.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "MyLogInViewController.h"
//环信

#import "LoginViewController.h"

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+MagicalRecord.h"
//讯飞
#import "iflyMSC/iflySetting.h"
#import "Definition.h"
#import "iflyMSC/IFlySpeechUtility.h"
//百度map
#import "BMKMapManager.h"
#import "WeiXinPay.h"

//qq
#import <TencentOpenAPI/TencentOAuth.h>
//weibo
#import "WeiboSDK.h"

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface AppDelegate ()<WXApiDelegate,BPushDelegate,WeiboSDKDelegate>
{
    UIImageView *splashView;
    
    BMKMapManager * _mapManager;
    
    UINavigationController *navigationController;
    
    NSDictionary *myDic;
}

@end

@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize stockDataArray = _stockDataArray;
@synthesize tianjinArray = _tianjinArray;
@synthesize callNum;
@synthesize deletate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    APPLIACTION.application = application;
    APPLIACTION.leiName = @"66";
    

//    myDic = [[NSDictionary alloc]initWithDictionary:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baiduBangding) name:@"NO_BAIDUBANGDING" object:nil];
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
//    statTracker.channelId = @"AppStore";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
//    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
    /*如果有需要，可自行传入adid
     NSString *adId = @"add9c6242d";
     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
     adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     }
     statTracker.adid = adId;
    */
    [statTracker startWithAppId:@"c09edce680"];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey  百度统计
    

    //极光推送
    //极光推送
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    
    
      [WXApi registerApp:WXAppKey withDescription:@"simi"];
    

//    [WXApi registerApp:@"wx1c0cdfad5f3bbc79"];
    
    
  
//    NSURL *schemeUrl = [[NSURL alloc]initWithString:@"wx1c0cdfad5f3bbc79"];

//    [WXApi handleOpenURL:schemeUrl delegate:self];
//    NSThread *thread =[[NSThread alloc]initWithTarget:self selector:@selector(getBeijingcity) object:nil];
//    [thread start];
    
    [self getBeijingcity];
    
    
    //环信
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    

    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    // 初始化UIDemoDB部分，本db只存储uidemo上的好友申请等信息，不存储im消息。im消息存储已经由sdk处理了，您不需要单独处理。
    [self setupUIDemoDB];
    
    [[EaseMob sharedInstance].chatManager enableDeliveryNotification];
    
    //讯飞
    
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
#warning 绑定百度推送之前 先调登录接口 看是否已经绑定过
    
//百度推送

    // iOS8 下需要使用新的 API
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
    
#warning 上线 AppStore 时需要修改 pushMode
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"Y31eOZA3t0OH8YfTQg9rKefl" pushMode:BPushModeProduction isDebug:NO];
    
//        [BPush setupChannel:launchOptions];
    
    // 设置 BPush 的回调
    [BPush setDelegate:self];

    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#warning 百度地图初始化
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"BSAQSU2uAP2AYP3mG43v4cyU"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    
    
    
    //新浪注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:XLAppKey];

    
    
    //    //设置默认启动页的停留时间
    [NSThread sleepForTimeInterval:0.1];
    //    //end
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [self ChoseRootController];
    
    return YES;
}

//启动页
- (void)showWord
{
    [splashView removeFromSuperview];
}
- (void)huanxin
{
    [self loginStateChange:nil];
}
#pragma mark 环信
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
//    UINavigationController *nav = nil;
    
//    [self.deletate navPush];
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        [self.deletate LoginSuccessNavPush]; //登录成功 跳maincontroller
        //加载申请通知的数据
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (_mainController == nil) {
//            _mainController = [[MainViewController alloc] init];
//            [_mainController networkChanged:_connectionState];
//            nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        }else{
//            nav  = _mainController.navigationController;
        }
    }else{//登陆失败加载登陆页面控制器
//        _mainController = nil;
//        LoginViewController *loginController = [[LoginViewController alloc] init];
//        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
//        loginController.title = NSLocalizedString(@"私秘", @"EaseMobDemo");
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"IM登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        [self.deletate LoginFailNavpush];
//        self.window.rootViewController = nav;
    }
    
    //设置7.0以下的导航栏
//    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
//        nav.navigationBar.barStyle = UIBarStyleDefault;
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
//                                forBarMetrics:UIBarMetricsDefault];
//        
//        [nav.navigationBar.layer setMasksToBounds:YES];
//    }
//
//    [nav setNavigationBarHidden:NO];
//    [nav setNavigationBarHidden:NO];
}
/**
 *百度推送
**/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志 textView 中
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//角标
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"userinfo:%@",userInfo);
//    NSString *url = [userInfo objectForKey:@"url"];
//    if (![url isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OPENWEBVIEW" object:userInfo];
//    }
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert" ] delegate:self cancelButtonTitle:@"不错哦" otherButtonTitles:nil];
//    [alert show];
    
    NSString *alert2 = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSLog(@"推送的内容：%@",alert2);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REVICENOTIFICATION" object:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"66" forKey:@"UNREADMESSAGES"];
    [userDefaults synchronize];
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
//    [self baiduBangding];
}
- (void)baiduBangding{
    NSLog(@"test:%@",APPLIACTION.deviceToken);
    [BPush registerDeviceToken:APPLIACTION.deviceToken];
    [BPush bindChannel];
}
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSLog(@"test:%@",deviceToken);
////    [BPush registerDeviceToken:deviceToken];
////    [BPush bindChannel];
//    
//    // 打印到日志 textView 中
//    //    [self.viewController addLogString:[NSString stringWithFormat:@"Register use deviceToken : %@",deviceToken]];
//
//}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
//    [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",method,data]];
    NSLog(@"%@",[NSString stringWithFormat:@"Method: %@\n%@",method,data]);
    NSString *app_id = [data objectForKey:@"app_id"];
    NSString *channel_id = [data objectForKey:@"channel_id"];
    NSString *user_id = [data objectForKey:@"user_id"];
    
    
    if (app_id && channel_id && user_id) {
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:_manager.telephone  forKey:@"user_id"];
        [sourceDic setObject:app_id forKey:@"app_id"];
        [sourceDic setObject:channel_id forKey:@"channel_id"];
        [sourceDic setObject:user_id forKey:@"app_user_id"];
        [sourceDic setObject:@"ios" forKey:@"device_type"];

        NSLog(@"%@",sourceDic);

        AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
        [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,baidu_bangding]  parameters:sourceDic success:^(AFHTTPRequestOperation *opretion, id responseObject){
            
            NSLog(@"绑定成功");

        }
         
        failure:^(AFHTTPRequestOperation *opration, NSError *error){
            
            NSLog(@"请求失败: %@",error);
            
        }];

    }
    
}
/*
 end
 */
- (void) sendTextContent
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"【私秘】今天终于体验了“私人秘书”的服务，大家快来试试吧！下载有礼1gj.cc/d/";
    req.bText = YES;
    req.scene = 1;
    
    [WXApi sendReq:req];
}
//微信的回调
-(void) onResp:(BaseResp*)resp{
    NSLog(@"%@",resp);
    NSLog(@"errStr %@",[resp errStr]);
    NSLog(@"errCode %d",[resp errCode]);
    NSLog(@"type %d",[resp type]);
 
//微信分享
    if([resp errCode] == 0 && [resp type] == 0){
  
        if([resp isKindOfClass:[SendMessageToWXResp class]])
        {
            ISLoginManager *logmanager = [[ISLoginManager alloc]init];
            
            NSDictionary *_dict = @{@"user_id":logmanager.telephone,
                                    @"share_type":@"weixin",
                                    @"share_account":@""};
            
            AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
            
            [mymanager POST:[NSString stringWithFormat:@"%@%@",SERVER_DRESS,@"/simi/app/user/share.json"] parameters:_dict success:^(AFHTTPRequestOperation *opretion, id responseObject){
                
                NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
                NSString * _message= [responseObject objectForKey:@"msg"];
                NSLog(@"%@",_message);
                if (_status == 0) {
                    
                }else{
                    
                    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                    //
                    //                [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *opration, NSError *error){
                
            }];

        }
    }
    
//微信支付
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINCHAXUN" object:nil];
                break;
            default:
                NSLog(@"支付失败， retcode=%d",resp.errCode);
                break;
        }
    }
//微信登录
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        if (aresp.errCode== 0) {
            //        NSString *code = aresp.code;
            //        NSDictionary *dic = @{@"code":code};
            NSLog(@"微信登录成功");
            [WXgetUserInfo GetTokenWithCode:aresp.code];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"MylogVcBack" object:nil];
            
        }
    }
    
}



#pragma mark
- (void)ChoseRootController
{
    
    NSUserDefaults *_userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *_guidstring = [_userdefaults objectForKey:@"GUIDE"];
    NSLog(@"(guidstring:%@",_guidstring);
    if (_guidstring) {

        RootViewController *controller = [[RootViewController alloc]init];
        UINavigationController *navcontroller = [[UINavigationController alloc]initWithRootViewController:controller];
        self.window.rootViewController = navcontroller;
        navcontroller.navigationBarHidden = YES;
        
        //设置启动页
        splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
        
        [splashView setImage:[UIImage imageNamed:@"Default@2x"]];
        
        [self.window addSubview:splashView];
        
        [self.window bringSubviewToFront:splashView];
        
        [self performSelector:@selector(showWord) withObject:nil afterDelay:2.0f];
        
        UIActivityIndicatorView *acview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        acview.center = CGPointMake((self.window.bounds.size.width/2), self.window.bounds.size.height/2+50);
        
        [splashView addSubview:acview];
        
        [acview startAnimating];
        
        
        //end
        
    }else{

        GuideViewController *_controller = [[GuideViewController alloc]init];
        UINavigationController *root = [[UINavigationController alloc]initWithRootViewController:_controller];
        self.window.rootViewController = root;

    }
    
    
}
- (void)getBeijingcity
{
    
//    [[DatabaseManager sharedDatabaseManager] chaxunTableName:@"cell" timeZiduan:@"C_OPER_TIME"];
    
//    _stockDataArray = [[NSArray alloc] initWithArray:[[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:2]];
//    _tianjinArray = [[NSArray alloc] initWithArray:[[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:3]];
//    [[DatabaseManager sharedDatabaseManager] chaxuntableName:@"cell" cellId:@"3642"];
    _repartArray = [[NSMutableArray alloc]init];
    
//    NSLog(@"stockDataArray = %@",_stockDataArray);
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    /*
     qq登陆
     */
    
//    if ([url.scheme isEqualToString:@"tencent222222"]) {
//        return [TencentOAuth HandleOpenURL:url];
//    }
    
    /*
     新浪微博登陆
     */
//    if ([url.scheme isEqualToString:@"2045436852"]) {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSDictionary *payDic = resultDic;
            NSLog(@"%@",payDic);
            NSString * status = [payDic objectForKey:@"resultStatus"];
            
            if ([status isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QIANBAOSUCCESS" object:nil];
            }
        }];
    }
    
    /*
     微信分享
    */
    //如果涉及其他应用交互,请做如下判断,例如:还可能和新浪微博进行交互
    if ([url.scheme isEqualToString:@"wx93aa45d30bf6cba3"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    /*
     qq登陆
     */

    if ([url.scheme isEqualToString:@"tencent222222"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    /*
     新浪微博登陆
     */
//    if ([url.scheme isEqualToString:@"2045436852"]) {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }

    
    return YES;
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
    
    [BPush handleNotification:userInfo]; // 可选
    
//    application.applicationIconBadgeNumber += 1;
    NSLog(@"userinfo:%@",userInfo);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert" ] delegate:self cancelButtonTitle:@"不错哦" otherButtonTitles:nil];
    [alert show];
    
    NSString *alert2 = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSLog(@"推送的内容：%@",alert2);
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
    if (_mainController) {
        [_mainController jumpToChatList];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"simi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"simi.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
