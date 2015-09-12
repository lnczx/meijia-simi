//
//  FoundViewController.h
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface FoundViewController : FatherViewController<UIScrollViewDelegate>
@property(nonatomic ,strong)UIScrollView *scrollerView;
@property(nonatomic ,strong)UIImageView *lineImageView;
@property(nonatomic ,strong) NSString *imgurl;
@property(nonatomic ,assign)NSInteger vcID;
@end
