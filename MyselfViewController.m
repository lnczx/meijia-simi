//
//  MyselfViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MyselfViewController.h"
#import "MineViewController.h"
#import "ISLoginManager.h"
#import "ImgWebViewController.h"
#import "FXBlurView.h"

#import "ISLoginManager.h"
#import "DownloadManager.h"

#import "PageTableViewCell.h"
#import "DetailsViewController.h"
#import "UserInfoViewController.h"
#import "ChatViewController.h"

@interface MyselfViewController ()
{
    FXBlurView *blurView;
    //UIView *headView;
    UIImageView *headIamageView;
    UIImageView *headeView;
    UIImageView *tmtView;
    
    UIView *tableScrollView;
    UIImageView *lineIamgeView;
    
    UIButton *participationButton;
    UIButton *releaseButton;
    
    UILabel *nameLabel;
    UILabel *distanceLabel;
    UILabel *positionLabel;
    //卡片Label
    UILabel *cradLabel;
    //订单label
    UILabel *orderLabel;
    //关注label
    UILabel *concernLabel;
    
    NSString *nameString;
    NSString *distanceString;
    NSString *positionString;
    //卡片文字
    NSString *cradString;
    //订单数字
    NSString *orderString;
    //关注数字
    NSString *concernString;
    
    NSDictionary *dict;
    
    UIImageView *genderIamgeView;
    UIButton *gradeButton;
    
    UILabel *titleLabel;
    
    NSArray *myReleaseArray;
    NSString *myReleaseString;
    NSArray *myParticipateArray;
    NSString *myParticipateString;
    
    UILabel *lableHY;
}
@end

@implementation MyselfViewController
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    ISLoginManager *_manager = [ISLoginManager shareManager];
//    if (_manager.isLogin) {
//        UIImage *headimg = [GetPhoto getPhotoFromName:@"image.png"];
//        if (headimg) {
//            headIamageView.image=headimg;
//            headeView.image=headimg;
//        }else{
//            headIamageView.image = [UIImage imageNamed:@"家-我_默认头像"];
//            headeView.image = [UIImage imageNamed:@"家-我_默认头像"];
//        }
//        
//    }else{
//        UIImage *headimg =nil; //[GetPhoto getPhotoFromName:@"image.png"];
//        if (headimg) {
//            headIamageView.image = headimg;
//            headeView.image=headimg;
//        }else{
//            headIamageView.image = [UIImage imageNamed:@"家-我_默认头像"];
//            headeView.image = [UIImage imageNamed:@"家-我_默认头像"];
//        }
//    }
    

}
-(void)viewDidAppear:(BOOL)animated
{
    [self dataLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_rootId==0) {
        ISLoginManager *_manager = [ISLoginManager shareManager];
        _userID=_manager.telephone;
        _view_userID=_manager.telephone;
    }
    
    self.backBtn.hidden=YES;
    self.navlabel.hidden=YES;
    self._backLable.backgroundColor=[UIColor blackColor];
    self._backLable.hidden=YES;
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];
    self.navlabel.backgroundColor=[UIColor clearColor];
    self.navlabel.text=@"个人主页";
    self.view.userInteractionEnabled=YES;
    
    
    
    
//    ISLoginManager *_manager = [ISLoginManager shareManager];
//    if (_manager.isLogin) {
//        NSLog(@"%@",_manager.telephone);
//        [self getjifen:_manager.telephone];
//        NSLog(@"传的事什么%@",_manager.telephone);
//    }

    // Do any additional setup after loading the view.
}
-(void)dataLayout
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":_userID,@"view_user_id":_view_userID};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USER_GRZY] dict:_dict view:nameLabel delegate:self finishedSEL:@selector(DownloadFinish1:) isPost:NO failedSEL:@selector(FailDownload:)];
    
    NSDictionary *dic = @{@"user_id":_view_userID,@"card_from":@"1"};
    [_download requestWithUrl:CARD_LIST dict:dic view:_releaseTableView delegate:self finishedSEL:@selector(myReleaseSuccess:) isPost:NO failedSEL:@selector(myReleaseFailure:)];
    //    [_download requestWithUrl:[NSString stringWithFormat:@"%@",CARD_LIST] dict:_dict view:_releaseTableView delegate:self finishedSEL:@selector(myReleaseSuccess:) isPost:NO failedSEL:@selector(myReleaseFailure:)];
    
    NSDictionary *_dic = @{@"user_id":_view_userID,@"card_from":@"2"};
    [_download requestWithUrl:CARD_LIST dict:_dic view:_participationTableView delegate:self finishedSEL:@selector(myParticipateSuccess:) isPost:NO failedSEL:@selector(myParticipateFailure:)];
}
-(void)myReleaseSuccess:(id)sender
{
    NSLog(@"我发布的数据 %@",sender);
    myReleaseString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    myReleaseArray=[sender objectForKey:@"data"];
    [self tableViewLayout];
}
// 我发布的  获取数据失败方法
-(void)myReleaseFailure:(id)sender
{
    
}
// 我参与的  成功获取数据方法
-(void)myParticipateSuccess:(id)sender
{
    NSLog(@"我参与的数据%@",sender);
    myParticipateString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    myParticipateArray=[sender objectForKey:@"data"];
    [self tableViewLayout];
}
// 我参与的  获取数据失败方法
-(void)myParticipateFailure:(id)sender
{
    
}


- (void)DownloadFinish1:(id)responsobject
{
    dict = [responsobject objectForKey:@"data"];
    [self imageViewLayout];
    [self nameLabelLayout];
    NSLog(@"下载成功的数据%@",dict);
    
}
- (void)FailDownload:(id)error
{
    NSLog(@"error: %@",error);
}

-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)imageViewLayout
{
    [blurView removeFromSuperview];
    [headeView removeFromSuperview];
    [headIamageView removeFromSuperview];
    NSString *headString=[NSString stringWithFormat:@"%@",[dict objectForKeyedSubscript:@"head_img"]];
    NSLog(@"1%@2",headString);
    if (_rootId==1) {
        
        headeView=[[UIImageView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT*0.51)];
        if ([headString length]==1||[headString length]==0) {
            headeView.image =[UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
            headeView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
        }
        
        [self.view addSubview:headeView];
        
        self.backBtn.hidden=NO;
        self.navlabel.hidden=NO;
        blurView = [FXBlurView new];
        // [[self blurView]setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        blurView.frame = CGRectMake(0, 64, WIDTH, HEIGHT*0.51);
        blurView.backgroundColor = [UIColor brownColor];
        [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self.view addSubview:blurView];
    }else{
        self.backBtn.hidden=YES;
        self.navlabel.hidden=YES;
        headeView=[[UIImageView alloc]initWithFrame:FRAME(0, 20, WIDTH, HEIGHT*0.51)];
        if ([headString length]==1||[headString length]==0) {
            headeView.image = [UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
            headeView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
        }

        [self.view addSubview:headeView];
        self.backBtn.hidden=YES;
        titleLabel.hidden=YES;
        blurView = [FXBlurView new];
        // [[self blurView]setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        blurView.frame = CGRectMake(0, 20, WIDTH, HEIGHT*0.51);
        blurView.backgroundColor = [UIColor brownColor];
        [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
        [self.view addSubview:blurView];
    }
    
    headIamageView=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-HEIGHT*0.14)/2, HEIGHT*0.04, HEIGHT*0.14, HEIGHT*0.14)];
    if ([headString length]==0||[headString length]==1) {
        headIamageView.image = [UIImage imageNamed:@"家-我_默认头像"];
    }else
    {
        headIamageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"head_img"]]]];
    }

    //headIamageView.backgroundColor=[UIColor redColor];
    
    [headIamageView.layer setCornerRadius:CGRectGetHeight([headIamageView bounds]) / 2];
    headIamageView.layer.masksToBounds = YES;
    headIamageView.layer.borderWidth = 2;
    headIamageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    //headIamageView.layer.cornerRadius=headIamageView.frame.size.width/2;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActiion:)];
    tap.delegate=self;
    tap.cancelsTouchesInView=YES;
    [headIamageView addGestureRecognizer:tap];
    [blurView addSubview:headIamageView];
    blurView.userInteractionEnabled=YES;
    headIamageView.userInteractionEnabled=YES;
    nameLabel=[[UILabel alloc]init];
    
    UIView *buttonView=[[UIView alloc]initWithFrame:FRAME(0, blurView.frame.size.height+blurView.frame.origin.y+20, WIDTH, HEIGHT*0.06)];
    buttonView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [self.view addSubview:buttonView];
    
    releaseButton=[[UIButton alloc]initWithFrame:FRAME(0, 0, WIDTH/2-0.5, HEIGHT*0.058)];
    [releaseButton setTitle:@"我发布的" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    releaseButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
    releaseButton.tag=10001;
    releaseButton.backgroundColor=[UIColor whiteColor];
    [releaseButton addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:releaseButton];
    
    participationButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+0.5, 0, WIDTH/2-0.5, HEIGHT*0.058)];
    [participationButton setTitle:@"我参与的" forState:UIControlStateNormal];
    [participationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    participationButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
    participationButton.tag=10002;
    participationButton.backgroundColor=[UIColor whiteColor];
    [participationButton addTarget:self action:@selector(tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:participationButton];
    
    lineIamgeView=[[UIImageView alloc]initWithFrame:FRAME(0, HEIGHT*0.06-2, WIDTH/2, 2)];
    lineIamgeView.backgroundColor=[UIColor redColor];
    [buttonView addSubview:lineIamgeView];
    [self controlLayour];
    

    
}
//头像点击事件
-(void)tapActiion:(UITapGestureRecognizer *)sender
{
    UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
    [self presentViewController:userinfo animated:YES completion:nil];
    NSLog(@"点击了 ");
}
-(void)controlLayour
{
    
    [self nameLabelLayout];
    
    genderIamgeView=[[UIImageView alloc]initWithFrame:FRAME(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y, 10, 20)];
    //genderIamgeView.backgroundColor=[UIColor blackColor];
    genderIamgeView.image=[UIImage imageNamed:@"WD_XB_ ♀_TB"];
    [blurView addSubview:genderIamgeView];
    
    gradeButton=[[UIButton alloc]initWithFrame:FRAME(genderIamgeView.frame.size.width+genderIamgeView.frame.origin.x+10, nameLabel.frame.origin.y, 30, 20)];
    [gradeButton setImage:[UIImage imageNamed:@"WD_DJ_TB_@2x"] forState:UIControlStateNormal];
    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, 0, 30, 20)];
    label.text=@"LV1";
    label.font=[UIFont fontWithName:@"Arial" size:10];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [gradeButton addSubview:label];
    //gradeButton.backgroundColor=[UIColor redColor];
    [blurView addSubview:gradeButton];
    
    distanceLabel=[[UILabel alloc]init];
    positionLabel=[[UILabel alloc]init];
    [self distanceLabelLayout];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME((WIDTH-130/2)/2, distanceLabel.frame.size.height+distanceLabel.frame.origin.y+HEIGHT*0.019, 130/2, 22)];
    image.image=[UIImage imageNamed:@"YE"];
    int userId=[_userID intValue];
    int viewUserId=[_view_userID intValue];
    //NSLog(@"%@,%@",_userID,userId);
    if (userId==viewUserId) {
        image.hidden=NO;
    }else{
        image.hidden=YES;
    }

    [blurView addSubview:image];
    UIButton *balanceButton=[[UIButton alloc]initWithFrame:FRAME(0,0,image.frame.size.width,image.frame.size.height)];
    //[balanceButton setTitle:@"¥2010" forState:UIControlStateNormal];
    balanceButton.titleLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"rest_money"]];
    [balanceButton setTintColor:[UIColor whiteColor]];
    [image addSubview:balanceButton];
        //添加好友按钮
    UIButton *addButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2-221/2, image.frame.size.height+image.frame.origin.y+HEIGHT*0.03, 204/2, HEIGHT*0.04)];
    if (userId==viewUserId) {
        addButton.hidden=YES;
    }else{
        addButton.hidden=NO;
    }
    [addButton setImage:[UIImage imageNamed:@"JHY"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:addButton];
    
    UILabel *addLabel=[[UILabel alloc]init];
    addLabel.text=@"添加好友";
    addLabel.textColor=[UIColor whiteColor];
    addLabel.font=[UIFont fontWithName:@"Arial" size:15];
    addLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [addLabel setNumberOfLines:1];
    [addLabel sizeToFit];
    addLabel.frame=FRAME((addButton.frame.size.width-addLabel.frame.size.width)/2, (addButton.frame.size.height-addLabel.frame.size.height)/2, addLabel.frame.size.width, addLabel.frame.size.height);
    [addButton addSubview:addLabel];
    //私聊按钮
    UIButton *whisperButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH/2+17/2, addButton.frame.origin.y, 204/2, HEIGHT*0.04)];
    if (userId==viewUserId) {
        whisperButton.hidden=YES;
    }else{
        whisperButton.hidden=NO;
    }
    [whisperButton setImage:[UIImage imageNamed:@"SL"] forState:UIControlStateNormal];
    [whisperButton addTarget:self action:@selector(whisperAction:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:whisperButton];
    
    UILabel *whisperLabel=[[UILabel alloc]init];
    whisperLabel.text=@"私聊";
    whisperLabel.textColor=[UIColor whiteColor];
    whisperLabel.font=[UIFont fontWithName:@"Arial" size:15];
    whisperLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [whisperLabel setNumberOfLines:1];
    [whisperLabel sizeToFit];
    whisperLabel.frame=FRAME((whisperButton.frame.size.width-whisperLabel.frame.size.width)/2, (whisperButton.frame.size.height-whisperLabel.frame.size.height)/2, whisperLabel.frame.size.width, whisperLabel.frame.size.height);
    [whisperButton addSubview:whisperLabel];
    
    tmtView=[[UIImageView  alloc]initWithFrame:FRAME(0, blurView.frame.size.height-HEIGHT*0.09, WIDTH, HEIGHT*0.09)];
    tmtView.image=[UIImage imageNamed:@"TMT(2)"];
    [blurView addSubview:tmtView];
    //个人中心按钮
    UIButton *meButton=[[UIButton alloc]initWithFrame:FRAME(29/2, 38/2, 20, 30)];
    //meButton.backgroundColor=[UIColor redColor];
    [meButton addTarget:self action:@selector(meAction:) forControlEvents:UIControlEventTouchUpInside];
    [meButton setImage:[UIImage imageNamed:@"WD_GRZX_TB_@2"] forState:UIControlStateNormal];
    [blurView addSubview:meButton];
    //信封按钮
    UIButton *envelopeButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-29/2-40, 38/2, 40, 30)];
    envelopeButton.backgroundColor=[UIColor redColor];
    [envelopeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [envelopeButton addTarget:self action:@selector(envelopeAction:) forControlEvents:UIControlEventTouchUpInside];
    //[blurView addSubview:envelopeButton];
    
    NSArray *array=@[@"卡片",@"优惠券",@"好友"];
    for (int i=0; i<array.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:FRAME(WIDTH/3*i+0.5, tmtView.frame.size.height-19/2-11, WIDTH/3-0.5, 11)];
        label.text=array[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont fontWithName:@"Arial" size:11];
        [tmtView addSubview:label];
        if (i!=2) {
            UIView *lineView=[[UIView alloc]initWithFrame:FRAME(WIDTH/3-0.5+WIDTH/3*i, (HEIGHT*0.09-HEIGHT*0.037)/2, 1, HEIGHT*0.037)];
            lineView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            [tmtView addSubview:lineView];
        }
        
    }
    cradLabel=[[UILabel alloc]init];
    [self cradLabelLayout];
    orderLabel=[[UILabel alloc]init];
    [self orderLabelLayout];
    concernLabel=[[UILabel alloc]init];
    [self concernLabelLayout];
    
}
#pragma mark表格初始化
-(void)tableViewLayout
{
    tableScrollView=[[UIView alloc]initWithFrame:FRAME(0, blurView.frame.size.height+blurView.frame.origin.y+20+HEIGHT*0.06, WIDTH*2, HEIGHT-(blurView.frame.size.height+blurView.frame.origin.y+20+HEIGHT*0.06+50))];
    [self.view addSubview:tableScrollView];
    
    _releaseTableView=[[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-(HEIGHT*0.51+20+HEIGHT*0.06+50))];
    _releaseTableView.dataSource=self;
    _releaseTableView.delegate=self;
    _releaseTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    _releaseTableView.tag=1001;
    [tableScrollView addSubview:_releaseTableView];
    
    _participationTableView=[[UITableView alloc]initWithFrame:FRAME(WIDTH, 0, WIDTH, tableScrollView.frame.size.height)];
    _participationTableView.dataSource=self;
    _participationTableView.delegate=self;
    _participationTableView.separatorStyle=UITableViewCellSelectionStyleNone;;
    _participationTableView.tag=1002;
    [tableScrollView addSubview:_participationTableView];
}
#pragma mark发布 参与按钮点击方法
-(void)tabBarAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10001:
        {
            [releaseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [participationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            lineIamgeView.frame=FRAME(0, HEIGHT*0.06-2, WIDTH/2, 2);
            tableScrollView.frame=FRAME(0, blurView.frame.size.height+blurView.frame.origin.y+20+HEIGHT*0.06, WIDTH*2, HEIGHT-(blurView.frame.size.height+20+HEIGHT*0.06));
            [UIView commitAnimations];
            
        }
            break;
        case 10002:
        {
            [releaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [participationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            lineIamgeView.frame=FRAME(WIDTH/2, HEIGHT*0.06-2, WIDTH/2, 2);
            tableScrollView.frame=FRAME(-WIDTH, blurView.frame.size.height+blurView.frame.origin.y+20+HEIGHT*0.06, WIDTH*2, HEIGHT-(blurView.frame.size.height+20+HEIGHT*0.06));
            [UIView commitAnimations];
            
           
        }
            break;
            
        default:
            break;
    }
}

-(void)myLayout
{
    
    
//    [download requestWithUrl:[NSString stringWithFormat:@"%@",CARD_LIST] dict:_dic view:_participationTableView delegate:self finishedSEL:@selector(myParticipateSuccess:) isPost:NO failedSEL:@selector(myParticipateFailure:)];
}
// 我发布的  成功获取数据方法
#pragma mark卡片文字显示方法
-(void)cradLabelLayout
{
    cradString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_card"]];
    cradLabel.text=cradString;
    cradLabel.textAlignment=NSTextAlignmentCenter;
    cradLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [cradLabel setNumberOfLines:1];
    [cradLabel sizeToFit];
    cradLabel.frame=FRAME(0, HEIGHT*0.09*0.2, WIDTH/3-0.5, 32/2);
    cradLabel.textColor=[UIColor whiteColor];
    cradLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [tmtView addSubview:cradLabel];
    
}
#pragma mar订单文字显示方法
-(void)orderLabelLayout
{
    orderString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_coupon"]];
    orderLabel.text=orderString;
    orderLabel.textAlignment=NSTextAlignmentCenter;
    orderLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [orderLabel setNumberOfLines:1];
    [orderLabel sizeToFit];
    orderLabel.frame=FRAME(WIDTH/3+0.5, HEIGHT*0.09*0.2, WIDTH/3-1, 32/2);
    orderLabel.textColor=[UIColor whiteColor];
    orderLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [tmtView addSubview:orderLabel];
}
#pragma mark关注文字显示方法
-(void)concernLabelLayout
{
    concernString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_friends"]];
    concernLabel.text=concernString;
    concernLabel.textAlignment=NSTextAlignmentCenter;
    concernLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [concernLabel setNumberOfLines:1];
    [concernLabel sizeToFit];
    concernLabel.frame=FRAME(WIDTH/3*2+0.5, HEIGHT*0.09*0.2, WIDTH/3-0.5, 32/2);
    concernLabel.textColor=[UIColor whiteColor];
    concernLabel.font=[UIFont fontWithName:@"Arial" size:16];
    [tmtView addSubview:concernLabel];
}
-(void)nameLabelLayout
{
    
    nameString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    nameLabel.text=nameString;
//    nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize: 20];
    //nameLabel.backgroundColor=[UIColor redColor];
    nameLabel.frame=FRAME((WIDTH-nameLabel.frame.size.width)/2, headIamageView.frame.origin.y+headIamageView.frame.size.height+HEIGHT*0.02, nameLabel.frame.size.width, 20);
    nameLabel.textColor=[UIColor whiteColor];
    
    [blurView addSubview:nameLabel];
    genderIamgeView.frame=FRAME(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y, 10, 20);
    gradeButton.frame=FRAME(genderIamgeView.frame.size.width+genderIamgeView.frame.origin.x+10, nameLabel.frame.origin.y, 30, 20);
}
-(void)distanceLabelLayout
{
    distanceString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"province_name"]];
    positionString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"province_name"]];
    distanceLabel.text=distanceString;
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.adjustsFontSizeToFitWidth=YES;
    [distanceLabel setNumberOfLines:1];
    [distanceLabel sizeToFit];
    distanceLabel.frame=FRAME((WIDTH-distanceLabel.frame.size.width)/2-distanceLabel.frame.size.width/2-5, nameLabel.frame.size.height+nameLabel.frame.origin.y+HEIGHT*0.02, distanceLabel.frame.size.width, 10);
    distanceLabel.font=[UIFont fontWithName:@"Arial" size:10];
    distanceLabel.textColor=[UIColor whiteColor];
    [blurView addSubview:distanceLabel];
    
    positionLabel.text=positionString;
    positionLabel.textAlignment = NSTextAlignmentLeft;
    [positionLabel setNumberOfLines:1];
    [positionLabel sizeToFit];
    positionLabel.adjustsFontSizeToFitWidth=YES;
    positionLabel.font=[UIFont fontWithName:@"Arial" size:9];
    positionLabel.textColor=[UIColor whiteColor];
    positionLabel.frame=FRAME(WIDTH/2+5, distanceLabel.frame.origin.y+1, positionLabel.frame.size.width, 9);
    [blurView addSubview:positionLabel];
}

-(void)addAction:(UIButton *)sender
{
    
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    
    NSString *name=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    NSString *mobile=[NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
    NSDictionary *_dict = @{@"user_id":_view_userID,@"name":name,@"mobile":mobile};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_TJHY dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"添加成功:");
}
-(void)DownFail:(id)sender
{
    
}
-(void)whisperAction:(UIButton *)sender
{
    ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[dict objectForKey:@"im_user_name"] isGroup:YES];
    vcr.title=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    [vcr.navigationController setNavigationBarHidden:NO];
    //NSLog(@"%@,,,%@",[dict objectForKey:@"im_sec_nickname"],[dict objectForKey:@"im_sec_username"]);
    [self.navigationController pushViewController:vcr animated:YES];
}
//-(void)envelopeAction:(UIButton *)sender
//{
//    ISLoginManager *manager = [[ISLoginManager alloc]init];
//    NSString *url = [NSString stringWithFormat:@"http://123.57.173.36/simi-wwz/wx-news-list.html?user_id=%@&page=1",manager.telephone];
//    ImgWebViewController *img = [[ImgWebViewController alloc]init];
//    img.imgurl =url;
//    img.title = @"消息列表";
//    [self.navigationController pushViewController:img animated:YES];
//}

-(void)meAction:(UIButton *)sender
{
    MineViewController *vc=[[MineViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PageTableViewCell *cell =[[PageTableViewCell alloc]init];
    return cell.view.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rows;
    // Return the number of rows in the section.
    if (tableView.tag==1001) {
        if ([myReleaseString isEqualToString:@""]) {
            [lableHY removeFromSuperview];
            lableHY.hidden=NO;
            lableHY=[[UILabel alloc]initWithFrame:FRAME(20, 30, WIDTH-40, 25)];
            lableHY.text=@"欢迎使用私密";
            lableHY.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            lableHY.font=[UIFont fontWithName:@"Arial" size:20];
            [tableScrollView addSubview:lableHY];
            rows=0;
        }else
        {
            lableHY.hidden=YES;
            rows=myReleaseArray.count;
        }
        
        
    }else if (tableView.tag==1002)
    {
        if ([myParticipateString isEqualToString:@""]) {
            [lableHY removeFromSuperview];
            lableHY.hidden=NO;
            lableHY=[[UILabel alloc]initWithFrame:FRAME(WIDTH+20, 30, WIDTH-40, 25)];
            lableHY.text=@"欢迎使用私密";
            lableHY.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
            lableHY.font=[UIFont fontWithName:@"Arial" size:20];
            [tableScrollView addSubview:lableHY];
            rows=0;
        }else
        {
            lableHY.hidden=YES;
            rows=myParticipateArray.count;
        }
        
    }
    return rows;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[[NSDictionary alloc]init];
    if (tableView.tag==1001) {
        dic=myReleaseArray[indexPath.row];
    }else
    {
        dic=myParticipateArray[indexPath.row];
    }
    
    static NSString *identifier = @"cell";
    
    PageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        NSString *clString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        int clID=[clString intValue];
        if (clID==1) {
            cell.promptlabel.text=@"处理中";
        }else if (clID==2){
            cell.promptlabel.text=@"秘书处理中";
        }else if(clID==3){
            cell.promptlabel.text=@"以完成";
        }else if (clID==0){
            cell.promptlabel.text=@"以取消";
        }
        
        //cell.promptlabel.backgroundColor=[UIColor blueColor];
        [cell.promptlabel setNumberOfLines:1];
        [cell.promptlabel sizeToFit];
        cell.promptlabel.frame=CGRectMake(WIDTH-cell.promptlabel.frame.size.width-15 ,14,cell.promptlabel.frame.size.width,55-26);
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(cell.promptlabel.frame.size.width, 0, 10, cell.promptlabel.frame.size.height)];
        image.image=[UIImage imageNamed:@"SYCELL_YHB_@2x"];
        
        [cell.promptlabel addSubview:image];
        UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, cell.promptlabel.frame.size.width+20, cell.promptlabel.frame.size.height)];
        image2.image=[UIImage imageNamed:@"SYCELL_YHBY_@2x"];
        
        [cell.promptlabel addSubview:image2];
        
    }
    NSArray *headImageArray=@[@"HYXQ_HEAD",@"MSJZ_HEAD",@"SWTX_HEAD",@"YYTZ_HEAD",@"CLGH_HEAD"];
    int card_type_Id=[[dic objectForKey:@"card_type"]intValue];
    NSArray *headArray=@[@"HY",@"ZJ",@"SW",@"YY",@"CL"];
    cell.heideImage.image=[UIImage imageNamed:@"SYCELL_HEAD_CY_@2x"];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type_name"]];
    [cell.titleLabel setNumberOfLines:1];
    [cell.titleLabel sizeToFit];
    
    double timeS=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeS];
    NSString* dateString = [formatter stringFromDate:date];
    
    cell.timeLabel.text=[NSString stringWithFormat:@"%@",dateString];
    [cell.timeLabel setNumberOfLines:1];
    [cell.timeLabel sizeToFit];
    
    if (card_type_Id==1) {
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"会议地点:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=NO;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"add_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        cell.costLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_addr"]];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.addressLabel.hidden=NO;
        cell.addressLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.addressLabel.frame=CGRectMake(cell.address.frame.size.width+cell.address.frame.origin.x, 59, WIDTH-148-cell.address.frame.size.width, 14);
        
    }else if (card_type_Id==2){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"提醒人:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=YES;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"add_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.costLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        cell.addressLabel.hidden=YES;
        
    }else if (card_type_Id==3){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"提醒人:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=YES;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"add_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.costLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        
        cell.addressLabel.hidden=YES;
    }else if (card_type_Id==4){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"时间:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"邀约人:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.hidden=YES;
        cell.address.text=@"提醒人:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"add_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
        NSString *personnel=[nameArr componentsJoinedByString:@","];
        cell.costLabel.text=[NSString stringWithFormat:@"%@",personnel];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        
        cell.addressLabel.hidden=YES;
    }else if (card_type_Id==5){
        cell.heideImage.image=[UIImage imageNamed:headArray[card_type_Id-1]];
        cell.descriptionView.image=[UIImage imageNamed:headImageArray[card_type_Id-1]];
        cell.sjLabel.text=@"城市:";
        [cell.sjLabel setNumberOfLines:1];
        [cell.sjLabel sizeToFit];
        cell.sjLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.sjLabel.frame=CGRectMake(129, 13, cell.sjLabel.frame.size.width, 14);
        
        cell.moneyLabel.text=@"时间:";
        [cell.moneyLabel setNumberOfLines:1];
        [cell.moneyLabel sizeToFit];
        cell.moneyLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.moneyLabel.frame=CGRectMake(129, 36, cell.moneyLabel.frame.size.width, 14);
        
        cell.address.text=@"航班:";
        [cell.address setNumberOfLines:1];
        [cell.address sizeToFit];
        cell.address.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.address.frame=CGRectMake(129, 59, cell.address.frame.size.width, 14);
        
        double inTime=[[dic objectForKey:@"add_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        NSString *fromCityName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ticket_from_city_name"]];
        NSLog(@"出发%@",fromCityName);
        NSString *toCityName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"ticket_to_city_name"]];
        NSString *cityName=[NSString stringWithFormat:@"从 %@ 到 %@",fromCityName,toCityName];
        cell.inTimeLabel.text=[NSString stringWithFormat:@"%@",cityName];
        cell.inTimeLabel.frame=CGRectMake(cell.sjLabel.frame.size.width+cell.sjLabel.frame.origin.x, 13, WIDTH-148-cell.sjLabel.frame.size.width, 14);
        
        cell.costLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        cell.costLabel.frame=CGRectMake(cell.moneyLabel.frame.size.width+cell.moneyLabel.frame.origin.x, 36, WIDTH-148-cell.moneyLabel.frame.size.width, 14);
        cell.addressLabel.text=[NSString stringWithFormat:@"航班"];
        cell.addressLabel.frame=CGRectMake(cell.address.frame.size.width+cell.address.frame.origin.x, 59, WIDTH-148-cell.address.frame.size.width, 14);
    }
    
    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    
    
    cell.praiseLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    cell.commentLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_comment"]];
    
    cell.zaButton.hidden=YES;
    cell.plButton.hidden=YES;
    cell.fxButton.hidden=YES;
//    NSArray *array=@[@"common_icon_like_c@2x",@"common_icon_review@2x",@"common_icon_share@2x"];
//    UIButton *zaButton=[[UIButton alloc]initWithFrame:CGRectMake(42, cell.view.frame.size.height-36, 22, 22)];
//    [zaButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
//    [zaButton setTag:indexPath.row];
//    [zaButton addTarget:self action:@selector(zaButtonan:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:zaButton];
//    UIButton *plButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*1, cell.view.frame.size.height-36, 22, 22)];
//    [plButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateNormal];
//    [plButton setTag:indexPath.row];
//    [plButton addTarget:self action:@selector(plButtonan:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:plButton];
//    UIButton *fxButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*2, cell.view.frame.size.height-36, 22, 22)];
//    [fxButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateNormal];
//    [fxButton setTag:indexPath.row];
//    [fxButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:fxButton];
    
    
    //    [cell.plButton addTarget:self action:@selector(buttonan:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.fxButton addTarget:self action:@selector(buttonan:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==1001) {
        NSString *card_ID=[myReleaseArray[indexPath.row]objectForKey:@"card_id"];
        NSLog(@"card_id%@",card_ID);
        DetailsViewController *vc=[[DetailsViewController alloc]init];
        //vc.pathId=(int)indexPath.row;
        vc.card_ID=[card_ID intValue];
        [self.navigationController pushViewController:vc animated:YES];
        [_releaseTableView deselectRowAtIndexPath:indexPath animated:NO];
    }else
    {
        NSString *card_ID=[myParticipateArray[indexPath.row]objectForKey:@"card_id"];
        NSLog(@"card_id%@",card_ID);
        DetailsViewController *vc=[[DetailsViewController alloc]init];
        //vc.pathId=(int)indexPath.row;
        vc.card_ID=[card_ID intValue];
        [self.navigationController pushViewController:vc animated:YES];
        [_participationTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
}

//-(void)zaButtonan:(UIButton *)sender
//{
//    ISLoginManager *_manager = [ISLoginManager shareManager];
//    DownloadManager *_download = [[DownloadManager alloc]init];
//    NSString *card_Id=[myReleaseArray[sender.tag]objectForKey:@"card_id"];
//    NSLog(@"ID%@",card_Id);
//    NSDictionary *dic = @{@"card_id":card_Id,@"user_id":_manager.telephone};
//    NSLog(@"字典数据%@",dic);
//    [_download requestWithUrl:CARD_DZ dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
//    
//}
//-(void)logDowLoadDA:(id)sender
//{
//    NSLog(@"点赞成功");
//    ISLoginManager *_manager = [ISLoginManager shareManager];
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
//    service_date_str=morelocationString;
//    _download = [[DownloadManager alloc]init];
//    
//    _dict = @{@"service_date":service_date_str,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
//    NSLog(@"字典数据%@",_dict);
//    [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableview delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
//    
//}
//-(void)DZDownFail:(id)sender
//{
//    NSLog(@"点赞失败");
//}
//
//-(void)plButtonan:(UIButton *)sender
//{
//    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
//    NSLog(@"card_id%@",card_ID);
//    DetailsViewController *vc=[[DetailsViewController alloc]init];
//    //vc.pathId=(int)indexPath.row;
//    vc.card_ID=[card_ID intValue];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//-(void)fxButtonan:(UIButton *)sender
//{
//    //    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
//    //    NSLog(@"card_id%@",card_ID);
//    //    DetailsViewController *vc=[[DetailsViewController alloc]init];
//    //    //vc.pathId=(int)indexPath.row;
//    //    vc.card_ID=[card_ID intValue];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    ShareFriendViewController *_controller = [[ShareFriendViewController alloc]init];
//    [self.navigationController pushViewController:_controller animated:YES];
//    
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
