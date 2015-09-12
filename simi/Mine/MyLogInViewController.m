//
//  MyLogInViewController.m
//  simi
//
//  Created by zrj on 15-3-17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MyLogInViewController.h"
#import "ChoiceDefine.h"
#import "MBProgressHUD+Add.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "BaiduMobStat.h"
#import "AppDelegate.h"
#import "WeiXinPay.h"
#import "ImgWebViewController.h"

#import "WeiboSDK.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "RootViewController.h"

@interface MyLogInViewController ()
<
UITextFieldDelegate,
TencentSessionDelegate,
WBHttpRequestDelegate,
appDelegate
>
{
    UIView *view;
    UIButton *btn;
    UIButton * noGetbtn;
    NSInteger secondsDown;
    NSTimer *countDownTimer;
    UITextField *textField;
    
    int wxID;
    
}
@end
@implementation MyLogInViewController
@synthesize leiMing,
            tencentOAuth = _tencentOAuth;
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"登录", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"登录", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"WEIXINDENGLU_CG" object:nil];
    if (self.loginYesOrNo == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:nil];

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    wxID=0;
   // super.backBtn.hidden=YES;
    
    if (self.loginYesOrNo == YES) {
        [self pushToIM];
        RootViewController *vc=[[RootViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        secondsDown = 60;
        
        self.navlabel.text = @"登录";
        self.backBtn.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"MylogVcBack" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToIM) name:@"PUSHTOCHAT" object:nil];
        
        //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    //    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        //    [backBtn setImage:[UIImage imageNamed:@"nav-arrow"] forState:UIControlStateNormal];
        //    backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //    backBtn.frame = FRAME(18, 25, 40, 30);
        //    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];  //17/2   16
        //    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        //    [self.view addSubview:backBtn];
        
        view = [[UIView alloc]initWithFrame:FRAME(0, NAV_HEIGHT+9, SELF_VIEW_WIDTH, 1.5+108)];
        view.backgroundColor = HEX_TO_UICOLOR(CHOICE_BACK_VIEW_COLOR, 1.0);
        [self.view addSubview:view];
        
        
        for (int i = 0; i < 2; i++) {
            UIView *vie = [[UIView alloc]initWithFrame:FRAME(0, 0.5+(108/2*i+i*0.5), SELF_VIEW_WIDTH, 108/2)];
            vie.backgroundColor = HEX_TO_UICOLOR(0xFFFFFF, 1.0);
            [view addSubview:vie];
            
            textField = [[UITextField alloc]initWithFrame:FRAME(10, 0.5+(108/2*i+i*0.5), SELF_VIEW_WIDTH, 108/2)];
            textField.backgroundColor = HEX_TO_UICOLOR(0xFFFFFF, 1.0);
            textField.delegate = self;
            textField.tag = 100+i;
            [view addSubview:textField];
            
        }
        
        for (UIView *view1 in view.subviews) {
            if ([view1 isKindOfClass:[UITextField class]]) {
                if (view1.tag == 100) {
                    [(UITextField *)view1 setPlaceholder:@"在此输入您的手机号"];
                }
                else if (view1.tag == 101) {
                    [(UITextField *)view1 setPlaceholder:@"请输入验证码"];
                    
                    noGetbtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH - 18 - 162/2-10, 9, 162/2+10, 108/2-18)];
                    [noGetbtn setTitle:@"没有收到？" forState:UIControlStateNormal];
                    [noGetbtn setBackgroundColor:DEFAULT_COLOR];
                    [noGetbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [noGetbtn.layer setCornerRadius:5.0];
                    noGetbtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [noGetbtn addTarget:self action:@selector(meishoudao:) forControlEvents:UIControlEventTouchUpInside];
                    [view1 addSubview:noGetbtn];
                    noGetbtn.hidden = YES;
                    view1.userInteractionEnabled = YES;
                }
            }
        }
        
        btn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH - 18 - 162/2-10, 9, 162/2+10, 108/2-18)];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setBackgroundColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0)];
        [btn.layer setCornerRadius:5.0];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(yanzheng:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        // Do any additional setup after loading the view.
        UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
        bttn.frame = FRAME(14, NAV_HEIGHT+9+14+108+1.5, 584/2, 108/2);
        [bttn setBackgroundColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0)];
        [bttn setTitle:@"登录" forState:UIControlStateNormal];
        [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bttn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        //    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        [self.view addSubview:bttn];
        
        UILabel *xieyiLab = [[UILabel alloc]initWithFrame:FRAME(14, bttn.bottom+8, 584/2, 20)];
        //    xieyiLab.text = @"点击“登录”，即表示您同意《有个管家使用协议》";
        xieyiLab.textAlignment = NSTextAlignmentLeft;
        xieyiLab.font = [UIFont systemFontOfSize:12];
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"点击“登录”，即表示您同意《私秘使用协议》"];
        [text1 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(13, 8)];
        xieyiLab.attributedText = text1;
        [self.view addSubview:xieyiLab];
        
        xieyiLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *xieyiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(XieYiAction)];
        [xieyiLab addGestureRecognizer:xieyiTap];
        
        UITapGestureRecognizer *first = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction)];
        [self.view addGestureRecognizer:first];
#pragma mark 微信登录  qq登陆  新浪登陆
        
        UIView *hengXian = [[UIView alloc]initWithFrame:FRAME(20, xieyiLab.bottom+30, SELF_VIEW_WIDTH-40, 1)];
        hengXian.backgroundColor = [UIColor grayColor];
        hengXian.alpha = 0.5;
        [self.view addSubview:hengXian];
        
        UILabel *logLab = [[UILabel alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH/2-40, xieyiLab.bottom+21, 80, 20)];
        logLab.text = @"一 键 登 录";
        logLab.textColor = [UIColor grayColor];
        logLab.textAlignment = NSTextAlignmentCenter;
        logLab.backgroundColor = HEX_TO_UICOLOR(BAC_VIEW_COLOR, 1.0);
        logLab.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:logLab];
        
        NSArray *arr = [[NSArray alloc]initWithObjects:@"微信",@"logqq",@"logxinlang", nil];
        
        for (int i = 0 ; i < 3 ; i++) {
            UIButton *thirdLogin = [[UIButton alloc]initWithFrame:FRAME(25+(i*120), xieyiLab.bottom+70, 25, 25)];
            thirdLogin.tag = i;
            [thirdLogin setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            thirdLogin.backgroundColor = [UIColor redColor];
            [thirdLogin addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
            [thirdLogin setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:thirdLogin];
            
            
            if (i == 1||i == 2) {
                thirdLogin.hidden = YES;
            }else {
                thirdLogin.frame = FRAME((SELF_VIEW_WIDTH - 30)/2, xieyiLab.bottom+70, 30, 30);
            }
        }
    }
    
    
    
    
}
- (void)ThirdPartyLogSuccessWhitOpenID:(NSString *)openid type:(NSString *)type name:(NSString *)name headImgUrl:(NSString *)imgurl
{
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *param = @{@"openid":openid,@"3rd_type":type,@"name":name,@"head_img":imgurl,@"login_from":@"0"};
    
    [_download requestWithUrl:Third_LOG dict:param view:self.view delegate:self finishedSEL:@selector(ThirdPardyLogSuccess:) isPost:YES failedSEL:@selector(DownFail:)];
    [self back];
}
-(void)back
{
    if (self.loginYesOrNo==YES) {
        RootViewController *vc=[[RootViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)ThirdPardyLogSuccess:(id)dict
{
    int status = [[dict objectForKey:@"status"] intValue];
    NSDictionary *dataDic = [dict objectForKey:@"data"];
    
    //登陆后的信息
    if (status == 0) {
        NSString *userid = [dataDic objectForKey:@"id"];
        
        UITextField *textfield  = (UITextField *) [view viewWithTag:100];
        ISLoginManager *_logmanager = [ISLoginManager shareManager];
        _logmanager.isLogin = YES;
        NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
        [_default setObject:@"login" forKey:@"islogin"];
        NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
        [mydefaults setObject:userid forKey:@"telephone"];
        [mydefaults synchronize];
        
        [self getUserInfo];
//        [self dismissViewControllerAnimated:YES completion:nil];
        
//        textfield.text = [textfield.text isEqual:[NSNull null] ]? @"":textfield.text;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"THIRD_LOGIN_SUCCESS" object:[dataDic objectForKey:@"id"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:[dataDic objectForKey:@"id"]];

        
        
//        [self.navigationController popViewControllerAnimated:YES];




        NSString *app_id = [dataDic objectForKey:@"app_id"];
        NSString *channel_id = [dataDic objectForKey:@"channel_id"];
        NSString *app_user_id = [dataDic objectForKey:@"app_user_id"];
        
        if ([app_id isEqualToString:@""] || [channel_id isEqualToString:@""] || [app_user_id isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NO_BAIDUBANGDING" object:nil];
        }
        
    }
}

- (void)viewAction
{
    UITextField *textField1 = (UITextField *)[view viewWithTag:100];
    [textField1 resignFirstResponder];
    UITextField *textField2 = (UITextField *)[view viewWithTag:101];
    [textField2 resignFirstResponder];

}
- (void)XieYiAction
{
    ImgWebViewController *web = [[ImgWebViewController alloc]init];
    web.title = @"私秘使用协议";
    web.imgurl = @" http://123.57.173.36/html/simi/agreement.htm";
    [self.navigationController pushViewController:web animated:YES];
    
}
- (void)thirdLogin:(UIButton *)sender
{
    if (sender.tag == 0) {
        wxID=1;
        [WeiXinPay sendAuthRequest];
        NSLog(@"微信登陆");
    }else if(sender.tag == 1)
    {
        NSLog(@"qq登陆");
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:tencentAPPID andDelegate:self];
        NSArray * _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
        [_tencentOAuth authorize:_permissions inSafari:NO];

        
    }else
    {
        NSLog(@"新浪登陆");
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = XLRedirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }
}
#pragma mark 新浪微博
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}



#pragma mark 腾讯登陆协议
- (void)tencentDidLogin
{
    NSLog(@"登陆成功");
    [_tencentOAuth getUserInfo];

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        
        NSLog(@"%@腾讯登陆后的数据  token：%@ id:%@",_tencentOAuth.accessToken,_tencentOAuth.openId);
    }
    else
    {
       NSLog(@"登录不成功 没有获取accesstoken");
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"腾讯用户登录取消");
    }
    else
    {
        NSLog(@"腾讯登录失败");
    }
}
-(void)tencentDidNotNetWork
{
   NSLog(@"无网络连接，请设置网络");
}
//获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response
{
    NSString *name = [response.jsonResponse objectForKey:@"nickname"];
    NSString *xingbie = [response.jsonResponse objectForKey:@"gender"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[response.jsonResponse objectForKey:@"figureurl_qq_1"]]]];
    [WXgetUserInfo SaveImgage:image];//图片保存到本地
    [self ThirdPartyLogSuccessWhitOpenID:_tencentOAuth.openId type:@"0" name:name headImgUrl:[response.jsonResponse objectForKey:@"figureurl_qq_1"]];

}

- (void)yanzheng:(UIButton *)sender
{
    UITextField *textfield  = (UITextField *) [view viewWithTag:100];
    NSLog(@"手机号： %@",textfield.text);
    NSString *phonestring = textfield.text;
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:phonestring];
    if (isValid) {
        [self getYanzhengma];
    }
    else
    {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
    }
}
- (void)sureAction:(UIButton *)sender
{
    
    UITextField *textfield  = (UITextField *) [view viewWithTag:100];
    [textfield resignFirstResponder];
    UITextField *textfield1 = (UITextField *) [view viewWithTag:101];
    [textfield1 resignFirstResponder];
    if(textfield.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    if(textfield1.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    NSLog(@"%@  ==== %@",textfield.text,textfield1.text);
    
    
    

    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"mobile":textfield.text,@"sms_token":textfield1.text,@"login_from":@"1"};
    [_download requestWithUrl:LOGIN_API dict:_dict view:self.view delegate:self finishedSEL:@selector(logDownLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
//    RootViewController *vc=[[RootViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 登陆成功
- (void)logDownLoadFinish:(id)string
{
    NSLog(@"登录后信息：%@",string);
    
    
    
    SIMPLEBaseClass *_base = [[SIMPLEBaseClass alloc]initWithDictionary:string];
    
    
    if (_base.status  == 0) {
        
        UITextField *textfield  = (UITextField *) [view viewWithTag:100];
        
        ISLoginManager *_logmanager = [ISLoginManager shareManager];
        _logmanager.isLogin = YES;
        NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
        [_default setObject:@"login" forKey:@"islogin"];
        NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
        [mydefaults setObject:[[string objectForKey:@"data"] objectForKey:@"id"] forKey:@"telephone"];
        [mydefaults synchronize];
        
        [self getUserInfo];
        //[self.navigationController popViewControllerAnimated:YES];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:textfield.text];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        NSString *app_id = [[string objectForKey:@"data"] objectForKey:@"app_id"];
        NSString *channel_id = [[string objectForKey:@"data"] objectForKey:@"channel_id"];
        NSString *app_user_id = [[string objectForKey:@"data"] objectForKey:@"app_user_id"];
        
        if ([app_id isEqualToString:@""] || [channel_id isEqualToString:@""] || [app_user_id isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NO_BAIDUBANGDING" object:nil];
        }
        
//        if ([leiMing isEqualToString:@"首页"]) {
//            [self pushToIM];
//        }

    }
    [self back];
    
}

- (void)DownFail:(id)string
{
    NSLog(@"erroe is %@",string);
}
- (void)getUserInfo
{
    ISLoginManager *logManager = [[ISLoginManager alloc]init];
    NSDictionary *mobelDic = [[NSDictionary alloc]initWithObjectsAndKeys:logManager.telephone,@"user_id", nil];
    DownloadManager *_download = [[DownloadManager alloc]init];
    //    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API] dict:mobelDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:)];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",USERINFO_API]  dict:mobelDic view:self.view delegate:self finishedSEL:@selector(getUserInfoSuccess:) isPost:NO failedSEL:@selector(getUserInfoFail:)];
    [self hideHud];
    
}
- (void)getUserInfoSuccess:(id)dic
{
    NSDictionary *dict = [dic objectForKey:@"data"];
//    if (wxID==1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MylogVcBack" object:nil];
//    }
    
    NSLog(@"这回会出来不？？%@",dict);
    int status = [dict[@"status"] intValue];
    NSLog(@"hahahhahahah__+++++_____+++++___%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TONG_ZHI" object:dict];
    if (status == 0) {
        
        //        UserData  = [[HuanxinBase alloc]initWithDictionary:dict];
        //        APPLIACTION.huanxinBase = UserData;
        //        NSLog(@"环信账号：%@环信密码：%@",UserData.imUsername,UserData.imUserPassword);
        self.hxUserName = [dict objectForKey:@"im_username"];
        self.hxPassword = [dict objectForKey:@"im_password"];
        NSLog(@"环信账号：%@环信密码：%@",self.hxUserName,self.hxPassword);
        
        self.imToUserID = [dict objectForKey:@"im_sec_username"];
        self.imToUserName = [dict objectForKey:@"im_sec_nickname"];
        self.ID =[dict objectForKey:@"id"];
        NSLog(@"%@",self.imToUserName);
        NSLog(@"%@",[dic objectForKey:@"im_sec_nickname"]);
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.imToUserID forKey:@"TOHXUSERID"];
        [userDefaults setObject:self.imToUserName forKey:@"TOHXUSERNAME"];
        [userDefaults synchronize];
        
        
#warning 1.8版本 首页主要改动
        ISLoginManager *logManager = [[ISLoginManager alloc]init];
        
        if (logManager.isLogin == YES) {
            

            AppDelegate *app = [[AppDelegate alloc]init];
            app.deletate = self;
            [app huanxin];
            

//            [self pushToIM];
        }
        
    }
    if(status){
        NSLog(@"1");
    }
}

- (void)LoginFailNavpush
{
    LoginViewController *log = [[LoginViewController alloc]init];
    //    log.userName = UserData.imUsername;
    //    log.password = UserData.imUserPassword;
    //    [self.navigationController pushViewController:log animated:YES];
    NSLog(@"%@",APPLIACTION.deviceToken);
    [log loginWithUsername:self.hxUserName password:self.hxPassword];
    
}
- (void)LoginSuccessNavPush
{
    //判断是否真人聊天
    //    NSString *imToUserID;
    //    imToUserID = self.imToUserID;
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.imToUserID isGroup:NO];
    chatVC.title = self.imToUserName;
    [chatVC.navigationController setNavigationBarHidden:NO];
    //[self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)getUserInfoFail:(id)error
{
    NSLog(@"%@",error);
}

#pragma mark 验证码请求
- (void)getYanzhengma
{
    
    //请求成功之后 开始倒计时
    UITextField *textfield  = (UITextField *) [view viewWithTag:100];
    
    NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
    [_default setObject:textfield.text forKey:@"telephone"];
    
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *param = @{@"mobile":textfield.text,@"sms_type":@"0"};
    
    [_download requestWithUrl:GET_YANZHENGMA dict:param view:self.view delegate:self finishedSEL:@selector(GetyanzhengmaFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
    [self numberDown];
}



#pragma mark 获得验证码成功
- (void)GetyanzhengmaFinish:(id)responobject
{
    NSLog(@"object is %@",responobject);
}


#pragma mark 开始倒计时
- (void)numberDown
{
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    btn.backgroundColor = [UIColor grayColor];
    btn.userInteractionEnabled = NO;
}
-(void)timeFireMethod{
    secondsDown--;
    
    [btn setTitle:[NSString stringWithFormat:@"重发验证码%lds",(long)secondsDown] forState:UIControlStateNormal];
    [noGetbtn setHidden:NO];
    if(secondsDown==0){
        [countDownTimer invalidate];
        [btn setBackgroundColor:HEX_TO_UICOLOR(0xE8374A, 1.0)];
        [btn setTitle:@"重发验证码" forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        secondsDown = 60;
        
        noGetbtn.userInteractionEnabled = YES;
    }
}
- (void)meishoudao:(UIButton *)sender{
    
    for (UIView *view1 in view.subviews) {
        if ([view1 isKindOfClass:[UITextField class]]) {
            if (view1.tag == 100) {
                [view1 resignFirstResponder];
                
            }
            else if (view1.tag == 101) {
                
                [view1 resignFirstResponder];
            }
        }
    }
    
    UIButton *tbtn =[[UIButton alloc]init];
    tbtn.frame = FRAME(14, SELF_VIEW_HEIGHT-180, 584/2, 100);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"私秘提示 \n请检查手机号是否正确，如无误超过60秒仍未收到短信，可能是短信被拦截或网络异常，请拨打客服电话400-169-1615获取验证码。"];
    [str setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(53 , 12)];
    
    [tbtn setAttributedTitle:str forState:UIControlStateNormal];
    tbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    tbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    tbtn.titleLabel.numberOfLines = 0;
    [tbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tbtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tbtn];
    
    UILabel *xiahuaxian = [[UILabel alloc]initWithFrame:FRAME(92, tbtn.bottom-20, 83, 0.5)];
    xiahuaxian.backgroundColor = [UIColor blueColor];
    [self.view addSubview:xiahuaxian];
    
}
- (void)call{
    
    for (UIView *view1 in view.subviews) {
        if ([view1 isKindOfClass:[UITextField class]]) {
            if (view1.tag == 100) {
                [view1 resignFirstResponder];
                
            }
            else if (view1.tag == 101) {
                
                [view1 resignFirstResponder];
            }
        }
    }
    
    
    NSString *phoneNum = @"";// 电话号码
    
    phoneNum = APPLIACTION.callNum;
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    UIWebView *phoneCallWebView;
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [self.view addSubview:phoneCallWebView];
}


//- (void)backAction
//{
//    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"RETURN" object:nil userInfo:nil];
//    
////    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
