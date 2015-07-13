//
//  XiyiThirdViewController.m
//  simi
//
//  Created by zrj on 14-12-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "XiyiThirdViewController.h"
#import "RemindView.h"
#import "ChoiceDefine.h"
#import "ChoiceView.h"
#import "PickerView.h"
#import "addressViewController.h"
#import "BeiZhuViewController.h"
#import "SERVICEDatas.h"
#import "MBProgressHUD+Add.h"
#import "PayViewController.h"
#import "DownloadManager.h"
#import "DatabaseManager.h"
#import "OrderModel.h"
#import "UsedDressViewController.h"
#import "ISLoginManager.h"
#import "MyLogInViewController.h"
#import "AppDelegate.h"
#import "BaiduMobStat.h"
#import "TimeManager.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "CUSTOMDRESSBaseClass.h"
#import "CUSTOMDRESSData.h"
@interface XiyiThirdViewController ()<ChoiceDelegate,picDelegate,BeiZhuDelegate,userDressDelegate,CallDelegate,appDelegate>
{
    ChoiceView *choiceView;
    
    RemindView *remindView;
    
    PickerView *pickerView;
    
    BOOL hid;
    
    UILabel *titleLab;
    
    NSString *picDate;
    NSString *pichours;
    NSString *picMinutes;
    UILabel *xiaoquLab;
    UILabel *beijing;
    UILabel * beizhulab;
    UILabel *beizhu;
    
    NSString *_time;
    
    DatabaseManager *dataMangger;
    SERVICEDatas *datas;
    ISLoginManager *logmanager;
}
@end

@implementation XiyiThirdViewController
@synthesize model,_price,title,tips,sourceArr;
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
 
}
- (void)getUSerDress
{
    if (logmanager.isLogin) {
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"mobile":logmanager.telephone};
        
        [_download requestWithUrl:MY_DRESSLIST dict:_dict view:self.view delegate:self finishedSEL:@selector(GetDressListSucess:) isPost:NO failedSEL:@selector(DownloadFail:)];
    }
    

}
#pragma mark 获得地址列表成功
- (void)GetDressListSucess:(id)responsobject
{
    
    NSLog(@"object is %@",responsobject);
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    CUSTOMDRESSBaseClass *_base = [[CUSTOMDRESSBaseClass alloc]initWithDictionary:responsobject];
    
    for (int i = 0; i < _base.data.count; i ++) {
        
        [dataArray addObject:[_base.data objectAtIndex:i]];
        
    }
    for (int i = 0; i < dataArray.count; i++) {
        CUSTOMDRESSData *mydata = (CUSTOMDRESSData *)[dataArray objectAtIndex:i];
        if (mydata.isDefault == 1) {
            NSLog(@"cellName: %@.cellID: %f.celladdr: %@",mydata.cellname,mydata.cellId,mydata.addr);
            [self GetDressCellname:mydata.cellname menapi:mydata.addr DressId:mydata.dataIdentifier cityID:mydata.cityId];
        }
    }
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"洗衣三", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"洗衣三", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navlabel.text = @"洗衣";
    
    datas = [model.datas objectAtIndex:0];
    service_hour = @"0";
    dataMangger = [[DatabaseManager alloc]init];
    logmanager = [[ISLoginManager alloc]init];
    NSArray *imagesArr = @[@"order-time",@"order-addr",@"order-other"];
    NSArray *lableTextArray = @[@"服务时间",@"服务地址",@""];
    
    choiceView = [[ChoiceView alloc]initWithFrame:FRAME(0, 25+296/2+74/2, SELF_VIEW_WIDTH, 106/2*3+0.5*4) imagesArray:imagesArr lableTextArray:nil];
    choiceView.delegate = self;
    [self.view addSubview:choiceView];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = FRAME(SELF_VIEW_WIDTH-36, (108/2-8)/2+(2*108/2)-6, 20, 20);
    [btnRight setBackgroundImage:[UIImage imageNamed:@"s-right-arrow"] forState:UIControlStateNormal];
    [choiceView addSubview:btnRight];
    
    remindView = [[RemindView alloc]initWithFrame:FRAME(0, NAV_HEIGHT, SELF_VIEW_WIDTH, (196+46)/2) labletext:tips];
    remindView.delegate = self;
    [self.view addSubview:remindView];
    
    for (int i = 0; i < 3; i ++) {
        
        titleLab = [[UILabel alloc]initWithFrame:FRAME(36+17, 20+(52*i), 100, 17)];
        titleLab.text = [lableTextArray objectAtIndex:i];
        titleLab.textAlignment = NSTextAlignmentLeft;
        //            titleLab.backgroundColor = [UIColor blackColor];
        titleLab.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
        titleLab.tag = +i;
        titleLab.font = [UIFont boldSystemFontOfSize:14];
        [choiceView addSubview:titleLab];
        if(i == 2){
            titleLab.frame = FRAME(36+17+30, 20+(52*i), 100, 17);
        }
    }
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(ROUND_COLOR, 1.0)];
    [bttn setTitle:@"提 交 订 单" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.view addSubview:bttn];
    
    beizhu = [[UILabel alloc]initWithFrame:FRAME(36+17, 106, 150+35+115-56, 108/2)];
    beizhu.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    beizhu.font = [UIFont boldSystemFontOfSize:13];
    beizhu.tag = 66;
    beizhu.text = [NSString stringWithFormat:@"备注"];
    [choiceView addSubview:beizhu];
    
    beijing = [[UILabel alloc]initWithFrame:FRAME(36+17, 108/2, 150+35, 108/2)];
    beijing.tag = 11;
    beijing.textAlignment = NSTextAlignmentLeft;
    beijing.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    beijing.font = [UIFont boldSystemFontOfSize:13];
    beijing.numberOfLines = 0;
    [choiceView addSubview:beijing];
    
    xiaoquLab = [[UILabel alloc]initWithFrame:FRAME(36+17+30, 108/2, 150+35, 108/2)];
    xiaoquLab.tag = 10;
    //    xiaoquLab.backgroundColor = [UIColor greenColor];
    xiaoquLab.textAlignment = NSTextAlignmentLeft;
    xiaoquLab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    xiaoquLab.font = [UIFont boldSystemFontOfSize:13];
    xiaoquLab.numberOfLines = 0;
    [choiceView addSubview:xiaoquLab];
    
    beizhulab = [[UILabel alloc]initWithFrame:FRAME(36+17+30, 106, 150+35+115-56-35, 108/2)];
    beizhulab.tag = 12;
    beizhulab.textAlignment = NSTextAlignmentLeft;
    beizhulab.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    beizhulab.font = [UIFont boldSystemFontOfSize:14];
    beizhulab.numberOfLines = 1;
    [choiceView addSubview:beizhulab];
    
    
    [self getUSerDress];
    
    pickerView = [[PickerView alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220)];
    pickerView.HidDelegate = self;
    // Do any additional setup after loading the view.
}
- (void)choiceDelegate:(NSInteger)btnTag
{
    if (btnTag == 30) {
        NSLog(@"1");
        if (hid == NO) {

            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            pickerView.frame = FRAME(0, SELF_VIEW_HEIGHT-220, SELF_VIEW_WIDTH, 220);
            [UIView commitAnimations];
            [self.view addSubview:pickerView];
            hid = YES;
        }else
        {
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            pickerView.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
            [UIView commitAnimations];
            hid = NO;
        }
        
    }
    if (btnTag == 31) {
        NSLog(@"2");
        
        if (logmanager.isLogin) {
            UsedDressViewController *dress = [[UsedDressViewController alloc]init];
            dress.Cname = @"服务项";
            dress.delegate = self;
            [self.navigationController pushViewController:dress animated:YES];
        }else{
            MyLogInViewController *log = [[MyLogInViewController alloc]init];
            [self.navigationController presentViewController:log animated:YES completion:nil];
        }
    }
    if (btnTag == 32) {
        NSLog(@"3");
        
        BeiZhuViewController *beizhuCon = [[BeiZhuViewController alloc]init];
        beizhuCon.delegate = self;
        beizhuCon.beizhu = beizhulab.text;
        [self.navigationController pushViewController:beizhuCon animated:YES];
    }
    
}
- (void)quxiao
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    hid = NO;
}
-(void)queding:(NSString *)date hours:(NSString *)hours minutes:(NSString *)minutes
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    hid = NO;
    
    picDate = date;
    pichours = hours;
    picMinutes = minutes;
    NSLog(@"date:%@hours:%@minutes:%@",picDate,pichours,picMinutes);
    
    for(UIView *view in choiceView.subviews ) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag == 0) {
                [(UILabel *)view setHidden:YES];
            }
        }
    }
    
    [self CreateLable];
}
- (void)CreateLable
{
    //判断星期几
    NSString *day = [picDate substringWithRange:NSMakeRange(6, 2)];
    NSString *month = [picDate substringWithRange:NSMakeRange(3, 2)];
    NSString *year = [picDate substringWithRange:NSMakeRange(0, 2)];
    NSLog(@"year: %@   day:%@    month:%@",year,day,month);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day intValue]];
    [_comps setMonth:[month intValue]];
    [_comps setYear:[[NSString stringWithFormat:@"20%@",year] intValue]];
    //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    NSLog(@"_weekday:%ld",(long)_weekday);
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)_weekday];
    str =[str stringByReplacingOccurrencesOfString:@"1" withString:@"日"];
    str =[str stringByReplacingOccurrencesOfString:@"2" withString:@"一"];
    str =[str stringByReplacingOccurrencesOfString:@"3" withString:@"二"];
    str =[str stringByReplacingOccurrencesOfString:@"4" withString:@"三"];
    str =[str stringByReplacingOccurrencesOfString:@"5" withString:@"四"];
    str =[str stringByReplacingOccurrencesOfString:@"6" withString:@"五"];
    str =[str stringByReplacingOccurrencesOfString:@"7" withString:@"六"];
    
    UILabel *lale = [[UILabel alloc]initWithFrame:FRAME(36+17, 8, 53, 40)];
    lale.text = [NSString stringWithFormat:@"周%@",str];
    lale.textColor = HEX_TO_UICOLOR(LABLE_COLOR, 1.0);
    lale.font = [UIFont systemFontOfSize:25];
    [choiceView addSubview:lale];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(36+17+50+5, 15, 60, 15)];
    lable.text = [NSString stringWithFormat:@"%@:%@",[pichours substringWithRange:NSMakeRange(0, 2)],[picMinutes substringWithRange:NSMakeRange(0, 2)]];
    lable.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [choiceView addSubview:lable];
    
    UILabel *lal = [[UILabel alloc]initWithFrame:FRAME(55+36+17, 28, 80, 15)];
    lal.text = [NSString stringWithFormat:@"20%@-%@-%@",year,month,day];
    lal.font = [UIFont systemFontOfSize: 11];
    lal.textColor = HEX_TO_UICOLOR(ROUND_TITLE_COLOR, 1.0);
    [choiceView addSubview:lal];
    
    _time = [NSString stringWithFormat:@"%@ %@ %@",lale.text,lal.text,lable.text];
    
    start_date = [NSString stringWithFormat:@"%@",lal.text];
    start_time = [NSString stringWithFormat:@"%@ %@",start_date,lable.text];
    NSLog(@"开始日期 %@  开始时间 %@",start_date,start_time);
    
}
- (void)GetDressCellname:(NSString *)cellname menapi:(NSString *)menpai DressId:(int)dressID cityID:(double)cityId
{
    for(UIView *view in choiceView.subviews ) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag == 1) {
                [(UILabel *)view setHidden:YES];
            }
        }
    }
    
    addr_id = [NSString stringWithFormat:@"%i",dressID];
    
    if (cityId == 2) {
        beijing.text = [NSString stringWithFormat:@"北京"];
    }else{
        beijing.text = [NSString stringWithFormat:@"天津"];
    }
    
    xiaoquLab.text = [NSString stringWithFormat:@"%@ %@",cellname,menpai];
}
- (void)BeiZhuDelegateLable:(NSString *)textViewtext
{
    NSLog(@"备注 textViewtext:%@",textViewtext);
    
    
    beizhulab.text = [NSString stringWithFormat:@"%@",textViewtext];
    
    for(UIView *view in choiceView.subviews ) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag == 2) {
                [(UILabel *)view setHidden:YES];
            }
        }
    }
}

- (void)next
{
    
 
    if (_time == nil) {
        [MBProgressHUD showError:@"请选择服务时间" toView:self.view];
        return;
    }
    if (xiaoquLab.text == nil) {
        [MBProgressHUD showError:@"请选择服务地址" toView:self.view];
        return;
    }
    if(_time != nil && xiaoquLab.text != nil) {
        
        
        //获取时间
        
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YY.MM.dd"];
        
        NSString *today=[dateformatter stringFromDate:senddate];
        
        NSLog(@"今天:%@",today);
        
        NSString *day = [picDate substringWithRange:NSMakeRange(6, 2)];
        NSString *month = [picDate substringWithRange:NSMakeRange(3, 2)];
        NSString *year = [picDate substringWithRange:NSMakeRange(0, 2)];
        
        if ([today isEqualToString:[NSString stringWithFormat:@"%@.%@.%@",year,month,day]]) {
            //表示选择的是今天的日期
            TimeManager *manager = [[TimeManager alloc]init];
            [manager TimeOutWith:[NSString stringWithFormat:@"%@:%@:00",[pichours substringWithRange:NSMakeRange(0, 2)],[picMinutes substringWithRange:NSMakeRange(0, 2)]]];
            if (manager.KtimeOut == YES) {
                [MBProgressHUD showError:@"服务来不及了" toView:self.view];
                return;
            }
        }
        
        
        
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSLog(@"sourceArr %@",sourceArr);
        for (int i = 0; i < sourceArr.count; i++) {
            NSMutableDictionary *dic2 = [sourceArr objectAtIndex:i];
            
            [dic setValue:[dic2 objectForKey:@"select_type"] forKey:@"type"];
            [dic setValue:[dic2 objectForKey:@"count"] forKey:@"value"];
            NSDictionary *dic3=[NSDictionary dictionaryWithDictionary:dic];
            [arr addObject:dic3];
        }
        
        NSLog(@"arr %@",arr);

        NSData * data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString :%@",jsonString);
        
        //时间戳
        NSString *timeChu = [dataMangger getTimeWithstring:start_time Format:@"yyy.MM.dd HH:mm"];
        NSString *dateChuo = [dataMangger getTimeWithstring:start_date Format:@"yyy.MM.dd"];
        
        //
        NSString *nowTime = [dataMangger gettimeForNow];
        
        if(beizhulab.text == nil){
            NSString *str = @"";
            beizhulab.text = str;
        }
        
        NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
        [sourceDic setObject:logmanager.telephone  forKey:@"mobile"];
//        [sourceDic setObject:@"2"  forKey:@"city_id"];
        [sourceDic setObject:@"2" forKey:@"service_type"];
        [sourceDic setObject:jsonString  forKey:@"send_datas"];
        [sourceDic setObject:dateChuo  forKey:@"service_date"];
        [sourceDic setObject:timeChu  forKey:@"start_time"];
        [sourceDic setObject:service_hour  forKey:@"service_hour"];
        [sourceDic setObject:addr_id  forKey:@"addr_id"];
        [sourceDic setObject:beizhulab.text  forKey:@"remarks"];
        [sourceDic setObject:nowTime  forKey:@"add_time"];
        [sourceDic setObject:@"0" forKey:@"order_from"];
        NSLog(@"请求dic = %@",sourceDic);
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",ORDER_TIJIAO] dict:sourceDic view:self.view delegate:self finishedSEL:@selector(DownlLoadFinish:) isPost:YES failedSEL:@selector(DownloadFail:)];
        
    }
    
}
- (void)DownlLoadFinish:(id)dict
{
    NSLog(@"dict: %@",dict);
    NSString *msg = [dict objectForKey:@"msg"];
    int status = [[dict objectForKey:@"status"] intValue];
    NSLog(@"msg = %@",msg);
    
    NSDictionary *dict2 = [dict objectForKey:@"data"];
    OrderModel *orderModel = [[OrderModel alloc]initWithDictionary:dict2];
    NSLog(@"model.mobile : %@",orderModel.mobile);
    if (status == 0) {
        PayViewController *pay = [[PayViewController alloc]init];
        pay.price = [NSString stringWithFormat:@"%0.1f",orderModel.order_money];
        pay.time = _time;
        pay.orderID = [NSString stringWithFormat:@"%i",orderModel.order_id];
        pay.orderNum = orderModel.order_no;
        pay.juanLX = @"2";
        [self.navigationController pushViewController:pay animated:YES];
    }
}

- (void)DownloadFail:(id)errorstr
{
    NSLog(@"errsor   :   %@",errorstr);
    
}
#pragma mark 打电话
#pragma mark 打电话
- (void)CallAction
{
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        [self CallTelephone];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20;
        [alert show];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 20) {
        MyLogInViewController *log = [[MyLogInViewController alloc]init];
        [self.navigationController presentViewController:log animated:YES completion:nil];
    }
}
- (void)CallTelephone
{
    
    
    BOOL login = [self loginYesOrNo];
    if (login == YES) {
        AppDelegate *app = [[AppDelegate alloc]init];
        app.deletate = self;
        [app huanxin];
    }
    else{
        //        [self showAlertViewWithTitle:@"提示" message:@"请先登陆"];
        UIAlertView *LogalertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        LogalertView.tag = 10;
        [LogalertView show];
    }
    
    
}
- (void)LoginFailNavpush
{
//    LoginViewController *log = [[LoginViewController alloc]init];
//    log.userName = APPLIACTION.huanxinBase.imUsername;;
//    log.password = APPLIACTION.huanxinBase.imUserPassword;
//    [self.navigationController pushViewController:log animated:YES];
//    [log loginWithUsername:APPLIACTION.huanxinBase.imUsername password:APPLIACTION.huanxinBase.imUserPassword];
    
}
- (void)LoginSuccessNavPush
{
    
    
    //判断是否真人聊天
    int senior = APPLIACTION.huanxinBase.is_senior;
    
    NSString *imToUserID;
    NSString *imToUsreName;
    
    if (senior == 1) {
        imToUserID = APPLIACTION.huanxinBase.im_senior_username;
        imToUsreName = APPLIACTION.huanxinBase.im_senior_nickname;
    }else{
        imToUserID = APPLIACTION.huanxinBase.im_robot_username;
        imToUsreName = APPLIACTION.huanxinBase.im_robot_nickname;
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:imToUserID isGroup:NO];
    chatVC.title = imToUsreName;
    chatVC._baojie = APPLIACTION._baseSource.data.serviceTypes.baojie;
    chatVC._zuofan = APPLIACTION._baseSource.data.serviceTypes.zuofan;
    chatVC._xiyi = APPLIACTION._baseSource.data.serviceTypes.xiyi;
    chatVC._jiadian = APPLIACTION._baseSource.data.serviceTypes.jiadian;
    chatVC._caboli = APPLIACTION._baseSource.data.serviceTypes.caboli;
    chatVC._guandao = APPLIACTION._baseSource.data.serviceTypes.guandao;
    chatVC._xinju = APPLIACTION._baseSource.data.serviceTypes.xinju;
    chatVC.baseData = APPLIACTION.huanxinBase;
    [chatVC.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
