//
//  BookingViewController.h
//  simi
//
//  Created by 白玉林 on 15/8/6.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface BookingViewController : FatherViewController
//出发与到达城市名称字符串
@property(nonatomic ,strong)NSString *setoutString;
@property(nonatomic ,strong)NSString *destinationString;
@property(nonatomic ,strong)NSNumber *fromID;
@property(nonatomic ,strong)NSNumber *toID;
@end
