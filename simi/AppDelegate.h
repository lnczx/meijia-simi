//
//  AppDelegate.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#import "MainViewController.h"
#import "ApplyViewController.h"
#import "IChatManagerDelegate.h"
#import "SERVICEBaseClass.h"
#import "HuanxinBase.h"
#import "BPush.h"
@protocol appDelegate <NSObject>

- (void)LoginSuccessNavPush;
- (void)LoginFailNavpush;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
    sqlite3 *database;
    NSArray *_stockDataArray;
    NSArray *_tianjinArray;
    
    EMConnectionState _connectionState;
    
    __weak id<appDelegate> delegate;
}

@property (nonatomic, weak) id<appDelegate> deletate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSArray *stockDataArray;
@property (nonatomic, strong) NSArray *tianjinArray;

@property (nonatomic, strong) NSMutableArray *repartArray;
@property (nonatomic, strong) NSString  *callNum;
@property (nonatomic, strong) SERVICEBaseClass *_baseSource;
@property (nonatomic, strong) HuanxinBase *huanxinBase;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) UIApplication *application;
@property (nonatomic, strong) NSString  *leiName;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)ChoseRootController;

- (void) sendTextContent;

- (void)huanxin;

@end
