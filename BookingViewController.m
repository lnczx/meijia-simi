//
//  BookingViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/6.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "BookingViewController.h"
#import "DatePicker.h"
#import "TixingTimePicker.h"
#import "DCRoundSwitch.h"
#import "TimePicker.h"
#import "CityViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "ConTentViewController.h"
int y,x=0;

@interface BookingViewController ()<datePicDelegate,TixingTimePic,timePickerDelegate>
{
    UIButton *startingButton;
    UIButton *arriveButton;
    UIButton *dateButton;
    UIButton *timeButton;
    
    UILabel *startingLabel;
    UILabel *arriveLabel;
    UILabel *dateLabelView;
    UILabel *timeViewLabel;
    UILabel *remindLabel;
    UILabel *contentLabel;
    
    
    UIImageView *startingImage;
    UIImageView *arriveImage;
    UIImageView *msImageView;
    UIView *msView;
    
    TimePicker *picker;
    DatePicker *datePicker;
    TixingTimePicker *timePicker;
    UIView *headeView;
    NSString *dateString;
    NSString *timeString;
    NSString *startingStr;
    NSString *arriveStr;
    NSString *remindString;
    NSString *contentString;
    //出发与到达城市名称Label
    UILabel *setoutLabel;
    UILabel *destinationLabel;
    
    
    DCRoundSwitch *switchButton;
    DCRoundSwitch *switchBut;
    
    UIImage *startingImages;
    UIImage *arriveImages;
    UIImage *msImages;
    
    
    CityViewController *vc;
    ConTentViewController *viewController;
    NSInteger ctID;
    
    int card_type_ID;
    int set_now_send_ID;
    int mscl_int;
    
}
@end

@implementation BookingViewController
@synthesize setoutString,destinationString,fromID,toID;
-(void)viewWillAppear:(BOOL)animated
{
    contentString=viewController.textString;
    NSLog(@"%@",contentString);
    [self contentLayout];
    timePicker=[[TixingTimePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    timePicker.delegate=self;
    [self.view addSubview:timePicker];
    datePicker = [[DatePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 250)];
    datePicker.delegate = self;
    [self.view addSubview:datePicker];
    picker = [[TimePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    picker.delegate = self;
    [self.view addSubview:picker];
    

    if (ctID==20001) {
        setoutString=vc.setout;
        fromID=vc.fromCityID;
    }else if (ctID==20002)
    {
        toID=vc.toCityId;
        destinationString=vc.destination;
    }
    
    
    NSLog(@"%@,%@",fromID,toID);
    [self uibuttonLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    card_type_ID=5;
    self.navlabel.text=@"差旅规划";
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    startingStr=@"出发城市";
    arriveStr=@"到达城市";
    remindString=@"不提醒";
    msImages=[UIImage imageNamed:@"CLGH_MS_TB_@2x"];
    startingImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
    arriveImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
    [self viewLayout];
    [self LabelLayout];
    //[self pickerLayout];
    // Do any additional setup after loading the view.
}
-(void)viewLayout
{

    [headeView removeFromSuperview];
    
    headeView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 15/2)];
    headeView.userInteractionEnabled = YES;
    headeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headeView];
    //出发城市按钮 头像 label 控件初始化
    startingButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, 22/2, WIDTH-173/2, 33)];
    startingButton.tag=20001;
    [startingButton addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    [startingButton.layer setMasksToBounds:YES];
    [startingButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [startingButton.layer setBorderWidth:1.0];//边框宽度
    startingButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    startingButton.layer.cornerRadius=8.0f;
    startingButton.layer.masksToBounds=YES;
    startingButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    startingButton.layer.borderWidth= 1.0f;
    
    startingImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    
    startingLabel=[[UILabel alloc]initWithFrame:CGRectMake(startingImage.frame.origin.x+startingImage.frame.size.width+6, 15/2, startingLabel.frame.size.width, startingButton.frame.size.height-15)];
    //出发城市名称Label
    setoutLabel=[[UILabel alloc]initWithFrame:FRAME(startingLabel.frame.origin.x+startingLabel.frame.size.width, 15/2, startingButton.frame.size.width-15-(startingLabel.frame.origin.x+startingLabel.frame.size.width), startingButton.frame.size.height-15)];
    setoutLabel.textAlignment=NSTextAlignmentCenter;
    setoutLabel.textColor=[UIColor redColor];
    //setoutLabel.backgroundColor=[UIColor brownColor];
    [startingButton addSubview:setoutLabel];
    
    
    //到达城市安妮 头像 label初始化
    arriveButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, 55, WIDTH-173/2, 33)];
    arriveButton.tag=20002;
    [arriveButton addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    [arriveButton.layer setMasksToBounds:YES];
    [arriveButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [arriveButton.layer setBorderWidth:1.0];//边框宽度
    arriveButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    arriveButton.layer.cornerRadius=8.0f;
    arriveButton.layer.masksToBounds=YES;
    arriveButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    arriveButton.layer.borderWidth= 1.0f;
    
    arriveImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    //arriveImage.backgroundColor=[UIColor yellowColor];
    
    arriveLabel=[[UILabel alloc]initWithFrame:CGRectMake(arriveImage.frame.origin.x+arriveImage.frame.size.width+6, 15/2, arriveLabel.frame.size.width, arriveButton.frame.size.height-15)];
    //到达城市名称Label
    destinationLabel=[[UILabel alloc]initWithFrame:FRAME(arriveLabel.frame.origin.x+arriveLabel.frame.size.width, 15/2, arriveButton.frame.size.width-15-(arriveLabel.frame.origin.x+arriveLabel.frame.size.width), arriveButton.frame.size.height-15)];
    destinationLabel.textAlignment=NSTextAlignmentCenter;
    destinationLabel.textColor=[UIColor redColor];
    [arriveButton addSubview:destinationLabel];
    
    
    [self uibuttonLayout];

    
    //出发城市与到达城市转换按钮
    UIButton *exchangeButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-41, 44+11/2-10, 20, 20)];
    [exchangeButton setImage:[UIImage imageNamed:@"CLGH_ZH_TB_@2x"] forState:UIControlStateNormal];
    //exchangeButton.backgroundColor=[UIColor redColor];
    [exchangeButton addTarget:self action:@selector(exchangeButtonAN) forControlEvents:UIControlEventTouchUpInside];
    [headeView addSubview:exchangeButton];
    
    //出发日期设置
    dateButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, 99, WIDTH-35, 33)];
    [dateButton.layer setMasksToBounds:YES];
    [dateButton addTarget:self action:@selector(dateButtonPicKer) forControlEvents:UIControlEventTouchUpInside];
    [dateButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [dateButton.layer setBorderWidth:1.0];//边框宽度
    dateButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    dateButton.layer.cornerRadius=8.0f;
    dateButton.layer.masksToBounds=YES;
    dateButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    dateButton.layer.borderWidth= 1.0f;

    [headeView addSubview:dateButton];
    
    UIImageView *dateImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    dateImage.image=[UIImage imageNamed:@"CLGH_RQ_TB_@2x"];
    dateImage.layer.cornerRadius=dateImage.frame.size.width/2;
    [dateButton addSubview:dateImage];
    UILabel *dateLabel=[[UILabel alloc]init];
    dateLabel.frame=CGRectMake(dateImage.frame.origin.x+dateImage.frame.size.width+6, 15/2, dateLabel.frame.size.width, dateButton.frame.size.height-15);
    dateLabel.text=@"出发日期";
    dateLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [dateLabel setNumberOfLines:0];
    [dateLabel sizeToFit];
    [dateButton addSubview:dateLabel];
    
    dateLabelView=[[UILabel alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x+dateLabel.frame.size.width+8, 15/2, dateLabelView.frame.size.width, dateButton.frame.size.height-15)];
    
    //出发时间相关布局设置
    timeButton=[[UIButton alloc]initWithFrame:CGRectMake(35/2, dateButton.frame.origin.y+dateButton.frame.size.height+11, WIDTH-35, 33)];
    [timeButton addTarget:self action:@selector(timeButtonPicker) forControlEvents:UIControlEventTouchUpInside];
    [timeButton.layer setMasksToBounds:YES];
    [timeButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    [timeButton.layer setBorderWidth:1.0];//边框宽度
    timeButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
    timeButton.layer.cornerRadius=8.0f;
    timeButton.layer.masksToBounds=YES;
    timeButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    timeButton.layer.borderWidth= 1.0f;
    [headeView addSubview:timeButton];
    
    UIImageView *timeImage=[[UIImageView alloc]initWithFrame:CGRectMake(11/2, 15/2, startingButton.frame.size.height-15, startingButton.frame.size.height-15)];
    timeImage.image=[UIImage imageNamed:@"CLGH_SJ_TB_@2x"];
    //timeImage.backgroundColor=[UIColor brownColor];
    timeImage.layer.cornerRadius=timeImage.frame.size.width/2;
    [timeButton addSubview:timeImage];
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.frame=CGRectMake(timeImage.frame.origin.x+timeImage.frame.size.width+6, 15/2, timeLabel.frame.size.width, timeButton.frame.size.height-15);
    timeLabel.text=@"出发时间";
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:0];
    [timeLabel sizeToFit];
    [timeButton addSubview:timeLabel];
    
    timeViewLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width+8, 15/2, timeViewLabel.frame.size.width, timeButton.frame.size.height-15)];
    
    //备注信息、提醒设置、订机票相关布局
    NSArray *array=@[@"备注信息",@"提醒设置",@"订机票"];
    NSArray *imageArray=@[@"CLGH_NR_TB_@2x",@"CLGH_TX_TB_@2x",@"CLGH_JP_TB_@2x"];
    for (int i=0; i<3; i++) {
        int Y=timeButton.frame.origin.y+timeButton.frame.size.height+64/2+43*i;
        UIView *lineView=[[UIView alloc]init];
        lineView.frame=CGRectMake(35/2, Y, WIDTH-35, 1);
        lineView.backgroundColor=[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1];
        lineView.userInteractionEnabled = YES;
        [headeView addSubview:lineView];
        
        UIView *labelView=[[UIView alloc]initWithFrame:FRAME(0, Y+1, WIDTH, 84/2)];
        labelView.backgroundColor=[UIColor whiteColor];
        [headeView addSubview:labelView];
        
        UIImageView *headimageView=[[UIImageView alloc]init];
        if (i==1) {
            headimageView.frame=CGRectMake(39/2, 27/2, 32/2, 32/2);
        }else
        {
            headimageView.frame=CGRectMake(39/2, 27/2, 20, 32/2);
        }
        headimageView.image=[UIImage imageNamed:imageArray[i]];
        //headimageView.backgroundColor=[UIColor redColor];
        [labelView addSubview:headimageView];
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(headimageView.frame.origin.x+30, 23/2, label.frame.size.width, 32/2);
        label.text=array[i];
        label.lineBreakMode=NSLineBreakByTruncatingTail;
        [label sizeToFit];
        label.font=[UIFont fontWithName:@"Arial" size:16];
        //label.backgroundColor=[UIColor blueColor];
        [labelView addSubview:label];
        if (i==0) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTap:)];
            [labelView addGestureRecognizer:tap];
            contentLabel=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+label.frame.origin.x+5, 23/2, WIDTH-(label.frame.size.width+label.frame.origin.x+5)-10, labelView.frame.size.height-22)];
            contentLabel.font=[UIFont fontWithName:@"Arial" size:16];
            //contentLabel.backgroundColor=[UIColor brownColor];
           // [contentLabel sizeToFit];
            [self contentLayout];
            [labelView addSubview:contentLabel];
        }

        if (i==1)
        {
            labelView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
            [labelView addGestureRecognizer:tap];
            remindLabel=[[UILabel alloc]init];
           
            [self textLabelLayout];
        }
        if (i==2) {
            
            switchButton=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(WIDTH-50-35/2, 44/4, 50, 42/2)];
            //switchButton.backgroundColor=[UIColor redColor];
            switchButton.on=NO;
//            [switchButton setOn:NO];
            [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
            switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
            switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
            [labelView addSubview:switchButton];
        }
        
        y=Y;
    }
    
    headeView.frame=CGRectMake(0, 64+15/2, WIDTH, y+43);
    
}
-(void)contentLayout
{
    contentLabel.text=contentString;
}
#pragma mark出发城市与到达城市的变化方法
-(void)uibuttonLayout
{
    [headeView addSubview:startingButton];
    
    //startingImage.backgroundColor=[UIColor redColor];
    startingImage.image=startingImages;
    startingImage.layer.cornerRadius=startingImage.frame.size.width/2;
    [startingButton addSubview:startingImage];
    
    startingLabel.text=startingStr;
    startingLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [startingLabel setNumberOfLines:0];
    [startingLabel sizeToFit];
    [startingButton addSubview:startingLabel];
    NSLog(@"城市名称%@",setoutString);
    setoutLabel.text=setoutString;
    setoutLabel.frame=FRAME(startingLabel.frame.origin.x+startingLabel.frame.size.width, 15/2, startingButton.frame.size.width-15-(startingLabel.frame.origin.x+startingLabel.frame.size.width), startingButton.frame.size.height-15);
    
    
    
    [headeView addSubview:arriveButton];
    arriveImage.image=arriveImages;
    arriveImage.layer.cornerRadius=arriveImage.frame.size.width/2;
    [arriveButton addSubview:arriveImage];
    arriveLabel.text=arriveStr;
    arriveLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [arriveLabel setNumberOfLines:0];
    [arriveLabel sizeToFit];
    [arriveButton addSubview:arriveLabel];
    destinationLabel.text=destinationString;
    destinationLabel.frame=FRAME(arriveLabel.frame.origin.x+arriveLabel.frame.size.width, 15/2, arriveButton.frame.size.width-15-(arriveLabel.frame.origin.x+arriveLabel.frame.size.width), arriveButton.frame.size.height-15);
}
#pragma mark出发日期与出发时间的label现实变化方法
-(void)textLabelLayout
{
    dateLabelView.text=dateString;
    dateLabelView.lineBreakMode=NSLineBreakByTruncatingTail;
    [dateLabelView setNumberOfLines:0];
    [dateLabelView sizeToFit];
    dateLabelView.textColor=[UIColor redColor];
    [dateButton addSubview:dateLabelView];
    
    timeViewLabel.text=timeString;
    timeViewLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeViewLabel setNumberOfLines:0];
    [timeViewLabel sizeToFit];
    timeViewLabel.textColor=[UIColor redColor];
    [timeButton addSubview:timeViewLabel];
    
    remindLabel.text=remindString;
     remindLabel.frame=FRAME(WIDTH-remindLabel.frame.size.width-68, timeButton.frame.origin.y+timeButton.frame.size.height+64/2+43+29/2, remindLabel.frame.size.width, 32/2);
    remindLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [remindLabel setNumberOfLines:1];
    [remindLabel sizeToFit];
    [headeView addSubview:remindLabel];
}
#pragma mark秘书处理与创建按钮布局方法
-(void)LabelLayout
{
    msView=[[UIView alloc]init];
    msView.frame=CGRectMake(0, y+107+36/2, WIDTH, 42);
    msView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:msView];
    
    msImageView=[[UIImageView alloc]init];
    msImageView.frame=CGRectMake(39/2, 29/2, 32/2, 32/2);
//    msImageView.backgroundColor=[UIColor redColor];
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(msImageView.frame.origin.x+msImageView.frame.size.width+10, 25/2, label.frame.size.width, 32/2);
    label.text=@"需要秘书处理";
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:0];
    [label sizeToFit];
    [self msImageViewLayout];
    [msView addSubview:label];
    
    switchBut=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(WIDTH-50-35/2, 44/4, 50, 42/2)];
    //switchButton.backgroundColor=[UIColor redColor];
    switchButton.on=NO;
    //            [switchButton setOn:NO];
    [switchBut addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switchBut.onText = @"YES"; //NSLocalizedString(@"YES", @"");
    switchBut.offText = @"NO";//NSLocalizedString(@"NO", @"");
    [msView addSubview:switchBut];
    
    //创建按钮的相关布局
    UIView *tabBarView=[[UIView alloc]init];
    tabBarView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    tabBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabBarView];
    
    UIButton *button=[[UIButton alloc]init];
    button.frame=CGRectMake(87/2, 9, WIDTH-87, tabBarView.frame.size.height-18);
    [button setTitle:@"创建" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius=8;
    [button addTarget:self action:@selector(establish:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:button];
}
-(void)msImageViewLayout
{
    msImageView.image=msImages;
    [msView addSubview:msImageView];
}
#pragma mark datePicker初始化以及出发日期按钮的点击方法
-(void)dateButtonPicKer
{
       //        datePicker.backgroundColor = [UIColor grayColor];
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = CGRectMake(0, HEIGHT-250, WIDTH, 250);
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}
#pragma mark timePicker初始化以及出发时间按钮的点击方法
-(void)timeButtonPicker
{
    
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timePicker.frame=FRAME(0, HEIGHT-220, WIDTH, 220);
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}
#pragma mark datePicker代理方法
- (void)dateQuxiao
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    [UIView commitAnimations];
    
}
-(void)dateQueding:(NSString *)date
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    [UIView commitAnimations];
    
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    dateString=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSLog(@"jshah%@",dateString);
    [self textLabelLayout];
}
#pragma mark TimePicker代理方法
- (void)timepicCanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}
- (void)TimePicSure:(NSString *)timeStr
{
    NSLog(@"time %@",timeStr);
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
//    NSString *hour = [timeStr substringWithRange:NSMakeRange(0, 4)];
//    NSString *minute = [timeStr substringWithRange:NSMakeRange(8, 2)];
//    NSString *second = [timeStr substringWithRange:NSMakeRange(5, 2)];
    timeString=[NSString stringWithFormat:@"%@",timeStr];
    [self textLabelLayout];
}

- (void)suanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}

- (void)hours:(NSString *)hours //minutes:(NSString *)minutes
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    remindString=[NSString stringWithFormat:@"%@",hours];
    [self textLabelLayout];
}
#pragma mark目的地与始发地转换按钮方法
-(void)exchangeButtonAN
{
//    startingImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
//    arriveImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
    if (x%2==0) {
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        
        startingButton.frame=CGRectMake(35/2, 55, WIDTH-173/2, 33);
        startingImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
        startingStr=@"到达城市";
        
        arriveButton.frame=CGRectMake(35/2, 22/2, WIDTH-173/2, 33);
        arriveImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
        arriveStr=@"出发城市";
        [UIView commitAnimations];
        fromID=vc.fromCityID;
        toID=vc.toCityId;
        
    }else{
        [UIView beginAnimations:@"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        startingButton.frame=CGRectMake(35/2, 22/2, WIDTH-173/2, 33);
        startingImages=[UIImage imageNamed:@"CLGH_CFCS_TB_@2x"];
        startingStr=@"出发城市";
        
        arriveButton.frame=CGRectMake(35/2, 55, WIDTH-173/2, 33);
        arriveImages=[UIImage imageNamed:@"CLGH_FHCS_TB@2x"];
        arriveStr=@"到达城市";
        [UIView commitAnimations];
        fromID=vc.toCityId;
        toID=vc.fromCityID;
    }
    [self uibuttonLayout];
    x+=1;
}

#pragma mark 开关按钮switchButton的点击相应事件方法
-(void)switchAction:(id)sender
{
    
    UISwitch *switchBuT=(UISwitch *)sender;
    if (switchBuT.isOn) {
        msImages=[UIImage imageNamed:@"CLGH_MS_GTB_@2x"];
        mscl_int=1;
    }else
    {
        msImages=[UIImage imageNamed:@"CLGH_MS_TB_@2x"];
        mscl_int=0;
    }
    [self msImageViewLayout];
    
}
#pragma mark 开关按钮switchBut的相应事件方法
-(void)switchButAction:(id)sender
{
    
    UISwitch *switchBuT=(UISwitch *)sender;
    if (switchBuT.isOn)
    {
        set_now_send_ID=1;
    }else
    {
        set_now_send_ID=0;
    }
}
-(void)contentTap:(id)sender
{
    viewController=[[ConTentViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)labelTap:(id)sender
{
    
    //        datePicker.backgroundColor = [UIColor grayColor];
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
    datePicker.frame = FRAME(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 250);
    timePicker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}

-(void)establish:(id)sender
{
    
    NSLog(@"创建");
    if (setoutString==nil||setoutString==NULL) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (destinationString==nil||destinationString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (dateString==nil||dateString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择出发日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (timeString==nil||timeString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择出发时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (contentString==nil||contentString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写备注信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else{
        //获取当前时间
        //获取当前时间
        NSString *str=[NSString stringWithFormat:@"%@ %@",dateString,timeString];
        NSLog(@"时间%@",str);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate* dat = [formatter dateFromString:str]; //------------将字符串按formatter转成nsdate
        NSLog(@"%@",dat);
        NSDate *datenow = [NSDate date];
        //NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        int a=[dat timeIntervalSince1970];
        NSString *timestring = [NSString stringWithFormat:@"%d", a];
        NSLog( @"当前时间戳%@",timestring);
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        
        NSString *type_ID=[NSString stringWithFormat:@"%d",card_type_ID];
        NSString *txROW=[NSString stringWithFormat:@"%ld",(long)picker.txRow];
        NSString *sendString=[NSString stringWithFormat:@"%d",set_now_send_ID];
        NSString *msclString=[NSString stringWithFormat:@"%d",mscl_int];
        NSString *fromString=[NSString stringWithFormat:@"%@",fromID];
        NSString *toString=[NSString stringWithFormat:@"%@",toID];
        DownloadManager *_download = [[DownloadManager alloc]init];
        
        NSDictionary *_dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":_manager.telephone,@"user_id":_manager.telephone,@"service_time":timestring,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":sendString,@"set_sec_do":msclString,@"ticket_type":sendString,@"ticket_from_city_id":fromString,@"ticket_to_city_id":toString};
        NSLog(@"字典数据%@",_dict);
        [_download requestWithUrl:CREATE_CARD dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:YES failedSEL:@selector(DownFail:)];
    }

    
}
-(void)logDowLoadFinish:(id)sender
{
    [self backAction];
    NSLog(@"登录后信息：%@",sender);
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}
-(void)cityAction:(UIButton *)sender
{
    vc=[[CityViewController alloc]init];
   // ctID=sender.tag;
    switch (sender.tag) {
        case 20001:
        {
            ctID=sender.tag;
            vc.cityID=sender.tag;
        }
            break;
        case 20002:
        {
            ctID=sender.tag;
            vc.cityID=sender.tag;
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
