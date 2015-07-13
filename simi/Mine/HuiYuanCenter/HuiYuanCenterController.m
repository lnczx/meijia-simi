//
//  HuiYuanCenterController.m
//  simi
//
//  Created by 赵中杰 on 14/12/6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "HuiYuanCenterController.h"
#import "HuiYuanCenterView.h"
#import "BuyViewController.h"
#import "DownloadManager.h"
#import "VIPLISTBaseClass.h"
#import "BaiduMobStat.h"
@interface HuiYuanCenterController ()
<
    BUYDELEGATE
>
{
    VIPLISTBaseClass *_base;
}

@end
@implementation HuiYuanCenterController
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"会员购买", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"会员购买", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navlabel.text = @"会员购买";
    
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:VIP_LIST dict:nil view:self.view delegate:self finishedSEL:@selector(FinishDown:) isPost:NO failedSEL:@selector(FailDown:)];
    
}

#pragma mark 获取成功
- (void)FinishDown:(id)responsobject
{
    _base = [[VIPLISTBaseClass alloc]initWithDictionary:responsobject];
    if (_base.status == 0) {
        
        float _height = (_HEIGHT == 480) ? 568 : _HEIGHT;
        
        HuiYuanCenterView *_myview = [[HuiYuanCenterView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _height-64) listArray:_base.data];
        _myview.backgroundColor = COLOR_VAULE(242.0);
        _myview.delegate = self;
        
        UIScrollView *_myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
        if (_HEIGHT == 480) {
            [_myscroll setContentSize:CGSizeMake(_WIDTH, 568-64)];
        }
        [self.view addSubview:_myscroll];
        
        [_myscroll addSubview:_myview];

        
    }else{
        
    }
}

- (void)FailDown:(id)responsobject
{
    
}

- (void)buyHuiyuanWithMoney:(NSString *)money
{
    BuyViewController *_controller = [[BuyViewController alloc]init];
    _controller.moneystring = @"0";
    _controller.vipdata = [_base.data objectAtIndex:[money integerValue]-1];
    [self.navigationController pushViewController:_controller animated:YES];
}

@end
