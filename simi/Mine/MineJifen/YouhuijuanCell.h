//
//  YouhuijuanCell.h
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewCell.h"
#import "YOUHUIDataModels.h"

@interface YouhuijuanCell : FatherViewCell
{
    YOUHUIData *_mydata;
}

@property (nonatomic, strong) YOUHUIData *mydata;

@end
