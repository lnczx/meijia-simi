//
//  MyselfViewController.h
//  simi
//
//  Created by 白玉林 on 15/8/17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface MyselfViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic ,strong)UITableView *releaseTableView;
@property (nonatomic ,strong)UITableView *participationTableView;
@property (nonatomic ,strong)NSString *userID;
@property (nonatomic ,strong)NSString *view_userID;
@property (nonatomic ,assign)NSInteger rootId;
@end
