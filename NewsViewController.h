//
//  NewsViewController.h
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface NewsViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)NSArray *shujuArray;
@end
