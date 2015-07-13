//
//  FatherViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ISLoginManager.h"
#import "MyLogInViewController.h"
#import "ImgWebViewController.h"
@interface FatherViewController ()<UIAlertViewDelegate>
{
    NSString *url;
    NSString *webTitle;
}
@end

@implementation FatherViewController
@synthesize navlabel = _navlabel;
@synthesize backBtn = _backBtn;
@synthesize backlable = _backlable;
@synthesize hxPassword,hxUserName,imToUserID,imToUserName,ID;
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
    
    UILabel *backlable = [[UILabel alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, NAV_HEIGHT)];
    backlable.backgroundColor = HEX_TO_UICOLOR(0xf9f9f9, 1.0);
    [self.view addSubview:backlable];
    
    _navlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, self.view.frame.size.width-100, 44)];
    _navlabel.backgroundColor = HEX_TO_UICOLOR(0xf9f9f9, 1.0);
    _navlabel.textAlignment = NSTextAlignmentCenter;
    _navlabel.font = [UIFont systemFontOfSize:16];
    _navlabel.textColor = [UIColor blackColor];
    [self.view addSubview:_navlabel];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(0, 63, SELF_VIEW_WIDTH, 1)];
    lable.backgroundColor = [UIColor grayColor];
    lable.alpha = 0.3;
    [self.view addSubview:lable];

    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = FRAME(0, 20, 60, 40);
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-50/2)/2, 50/2, 50/2)];
    img.image = [UIImage imageNamed:@"nav-arrow"];
    [_backBtn addSubview:img];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWebView:) name:@"OPENWEBVIEW" object:nil];
    
}
- (void)hideTabbar
{
    RootViewController *rot = [[RootViewController alloc]init];
    [rot tabbarhidden];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}   
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openWebView:(NSNotification *)obj
{

    NSLog(@"%@",obj.object);
    url = [obj.object objectForKey:@"msgid"];
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    if (![url isEqualToString:@""]&& url !=nil) {
          url = [NSString stringWithFormat:
                            @"http://182.92.160.194/simi-oa/upload/html/%@.html?mobile='%@'",
                             [obj.object objectForKey:@"msgid"],
                             manager.telephone];
//        url = [NSString stringWithFormat:@"%@%@",[obj.object objectForKey:@"url"],mobile];
    }
//    webTitle = [[obj.object objectForKey:@"aps"]objectForKey:@"alert" ];
    webTitle = @"消息";

    if (![url isEqualToString:@""]&& url != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[obj.object objectForKey:@"aps"]objectForKey:@"alert" ] delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在查看", nil];
        
        [alert show];
    }
    
    if([url isEqualToString:@""]||url == nil){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息通知" message:[[obj.object objectForKey:@"aps"]objectForKey:@"alert" ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ImgWebViewController *web = [[ImgWebViewController alloc]init];
        web.imgurl = url;
        web.title = webTitle;
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark 返回字符串高度
- (CGSize)returnMysizeWithCgsize:(CGSize)mysize text:(NSString*)mystring font:(UIFont*)myfont
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:myfont,NSFontAttributeName, nil];
    CGSize size = [mystring boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(width -16.0, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height + 16.0;
}

#pragma mark 颜色值
-(UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}
//时间戳转字符串
- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}


#pragma mark
#pragma mark AlertView
- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
    
    [alert show];
}

- (void)pushToIM
{
    
    BOOL login = [self loginYesOrNo];
    if (login == YES) {

    }
    else{
        return;
    }
    
    
//    int senior = APPLIACTION.huanxinBase.is_senior;
//    NSString * toID;
//    NSString *userName;
//    if (senior == 1) {
//        toID = APPLIACTION.huanxinBase.im_senior_username;
//        userName = APPLIACTION.huanxinBase.im_senior_nickname;
//    }else{
//        toID = APPLIACTION.huanxinBase.im_robot_username;
//        userName = APPLIACTION.huanxinBase.im_robot_nickname;
//    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *to = [userDefaults objectForKey:@"TOHXUSERID"];
    NSString *name = [userDefaults objectForKey:@"TOHXUSERNAME"];
    ChatViewController *chat = [[ChatViewController alloc] initWithChatter:to isGroup:NO];
    chat.title = name;
//    chat._baojie = APPLIACTION._baseSource.data.serviceTypes.baojie;
//    chat._zuofan = APPLIACTION._baseSource.data.serviceTypes.zuofan;
//    chat._xiyi = APPLIACTION._baseSource.data.serviceTypes.xiyi;
//    chat._jiadian = APPLIACTION._baseSource.data.serviceTypes.jiadian;
//    chat._caboli = APPLIACTION._baseSource.data.serviceTypes.caboli;
//    chat._guandao = APPLIACTION._baseSource.data.serviceTypes.guandao;
//    chat._xinju = APPLIACTION._baseSource.data.serviceTypes.xinju;
//    chat.baseData = APPLIACTION.huanxinBase;
    [self.navigationController pushViewController:chat animated:YES];
}
//判断是否登录
-(BOOL)loginYesOrNo
{
    ISLoginManager *manager = [ISLoginManager shareManager];
    if (manager.isLogin) {
        return YES;
    }else{
        return NO;
    }
   
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//    if (alertView.tag == 20) {
//        if (buttonIndex == 0) {
//            NSLog(@"222");
//        }else{
//            NSLog(@"111");
//            //            MyLogInViewController *login = [[MyLogInViewController alloc]init];
//            //            [self.navigationController presentViewController:login animated:YES completion:nil];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"PRESENTMYLOGINVIEW" object:nil];
//        }
//    }
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
