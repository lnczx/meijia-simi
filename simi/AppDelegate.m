//
//  AppDelegate.m
//  guanjia
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

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface AppDelegate ()
<WXApiDelegate>

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize stockDataArray = _stockDataArray;
@synthesize tianjinArray = _tianjinArray;
@synthesize callNum;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
//    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
////    statTracker.channelId = @"ReplaceMeWithYourChannel";//设置您的app的发布渠道
//    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
//    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
//    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
//    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
////    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
//    /*如果有需要，可自行传入adid
//     NSString *adId = @"";
//     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
//     adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//     }
//     statTracker.adid = adId;
//     */
//    [statTracker startWithAppId:@"ReplaceMeWithAppKey"];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
//    
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //极光推送
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];

    
    
    [self ChoseRootController];
    
    [WXApi registerApp:@"wxe62e2a99b0e4578d" withDescription:@"guanjia"];

    
    [self getBeijingcity];
    
    return YES;
}

- (void) sendTextContent
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"【有个管家】真正的懒人神器，家务全能王啊！下载就有20元新人礼1gj.cc/d/推荐给亲们^ω^";
    req.bText = YES;
    req.scene = 1;
    
    [WXApi sendReq:req];
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
        
    }else{

        GuideViewController *_controller = [[GuideViewController alloc]init];
        UINavigationController *root = [[UINavigationController alloc]initWithRootViewController:_controller];
        self.window.rootViewController = root;

    }
}
- (void)getBeijingcity
{
    _stockDataArray = [[NSArray alloc] initWithArray:[[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:2]];
    _tianjinArray = [[NSArray alloc] initWithArray:[[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:3]];
    
    _repartArray = [[NSMutableArray alloc]init];
    
//    NSLog(@"stockDataArray = %@",_stockDataArray);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"guanjia" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"guanjia.sqlite"];
    
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
