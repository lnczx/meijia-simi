//
//  DetailsViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/5.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "DetailsViewController.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "DetailsTableViewCell.h"
int height;
@interface DetailsViewController ()
{
    UITableView *_tableView;
    UIView *liNeView;
    UITextView *textView;
    UIView *underView;
    NSDictionary *_dict;
    
    DownloadManager *_pllb;
    NSDictionary *dic;
    NSArray *plArray;
    NSString *plString;
    //点赞个数label
    UILabel *zambiaLabel;
    UIButton *zambiaButton;
    int cellNum;
    NSString *personnel;
    
}
@end

@implementation DetailsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGesture];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    self.view.backgroundColor=[UIColor whiteColor];
    self.lineLable.hidden=YES;
    //self.view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [self.view endEditing:YES];
    underView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    [UIView commitAnimations];
    
}

-(void)logDowLoadFinish:(id)sender
{
    dic=[sender objectForKey:@"data"];
    NSLog(@"登录后信息：%@",sender);
    
    [self viewLayout];
    [self zamLayout];
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}

-(void)viewLayout
{
    self.navlabel.text=[dic objectForKey:@"card_type_name"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 6)];
    view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [self.view addSubview:view];
    NSArray *headImageArray=@[@"HYXQ_HEAD",@"MSJZ_HEAD",@"SWTX_HEAD",@"YYTZ_HEAD",@"CLGH_HEAD"];
    NSArray *headImgArray=@[@"HY",@"ZJ",@"SW",@"YY",@"CL"];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(35/2, 70+25/2, 30, 30)];
    NSString *card=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type"]];
    int card_type=[card intValue];
    if (card_type==1) {
        headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==2){
         headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==3){
         headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==4){
         headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }else if (card_type==5){
        headImage.image=[UIImage imageNamed:headImgArray[card_type-1]];
    }
    
    if (card_type!=5) {
        NSArray *nameArray=[dic objectForKey:@"attends"];
        NSMutableArray *nameArr=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
            NSString *nameString=[NSString stringWithFormat:@"%@",[nameArray[i] objectForKey:@"name"]];
            [nameArr addObject:nameString];
        }
       personnel =[nameArr componentsJoinedByString:@","];
    }
    headImage.layer.cornerRadius=headImage.frame.size.width/2;
    [self.view addSubview:headImage];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.frame=CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, 70+32/2, timeLabel.frame.size.width, 15);
    double inTime=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    
    timeLabel.text=inTimeString;
    timeLabel.font=[UIFont fontWithName:@"Arial" size:14];
    timeLabel.lineBreakMode =NSLineBreakByTruncatingTail ;
    [timeLabel setNumberOfLines:0];
    [timeLabel sizeToFit];
    [self.view addSubview:timeLabel];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    textLabel.text=@"秘书处理中";
    textLabel.font=[UIFont fontWithName:@"Arial" size:14];
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    textLabel.frame=CGRectMake(WIDTH-textLabel.frame.size.width-5/2, 70+29/2, textLabel.frame.size.width, 56/2);
    [self.view addSubview:textLabel];
    
    
    
    UIImageView *weatherImage=[[UIImageView alloc]initWithFrame:CGRectMake(19, textLabel.frame.origin.y+textLabel.frame.size.height+29/2,100, 100)];
       //weatherImage.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:weatherImage];
    
    UILabel *addressLabel=[[UILabel alloc]init];
    NSString *fromCityString=[dic objectForKey:@"ticket_from_city_name"];
    NSString *toCityString=[dic objectForKey:@"ticket_to_city_name"];
    NSString *textString=[NSString stringWithFormat:@"从 %@ 到 %@",fromCityString,toCityString];
    [self.view addSubview:addressLabel];
    
//    double inTime1=[[dic objectForKey:@"service_time"] doubleValue];
    NSDateFormatter* inTimeformatter1 =[[NSDateFormatter alloc] init];
    inTimeformatter1.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter1 setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter1 setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter1 setDateFormat:@"时间：YYYY年MM月dd日 HH:mm:ss"];
    NSDate* inTimedate1 = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString1 = [inTimeformatter1 stringFromDate:inTimedate1];
    UILabel *shijianLabel=[[UILabel alloc]init];
    [self.view addSubview:shijianLabel];
    
    UILabel *cityLabel=[[UILabel alloc]init];
    cityLabel.hidden=YES;
    [self.view addSubview:cityLabel];
    
    UILabel *promptLabel=[[UILabel alloc]init];
    promptLabel.frame=CGRectMake(38/2, weatherImage.frame.origin.y+weatherImage.frame.size.height+21/2, promptLabel.frame.size.width, 14);
    promptLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_content"]];
    promptLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [promptLabel setNumberOfLines:0];
    [promptLabel sizeToFit];
    promptLabel.font=[UIFont fontWithName:@"Arial" size:14];
    [self.view addSubview:promptLabel];
    
    UILabel *inTimeLabel=[[UILabel alloc]init];
    inTimeLabel.frame=CGRectMake(38/2, promptLabel.frame.origin.y+promptLabel.frame.size.height+20/2, inTimeLabel.frame.size.width, 10);
    inTimeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
    inTimeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [inTimeLabel setNumberOfLines:0];
    [inTimeLabel sizeToFit];
    inTimeLabel.font=[UIFont fontWithName:@"Arial" size:10];
    [self.view addSubview:inTimeLabel];
    
    if (card_type==1)
    {
        cityLabel.hidden=NO;
        NSString *cityString=[NSString stringWithFormat:@"提醒人:%@",personnel];
        
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Arial" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=[NSString stringWithFormat:@"会议地点:%@",[dic objectForKey:@"service_addr"]];
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        cityLabel.text=cityString;
        cityLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [cityLabel setNumberOfLines:0];
        [cityLabel sizeToFit];
        cityLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cityLabel.frame=FRAME(addressLabel.frame.origin.x, shijianLabel.frame.origin.y+shijianLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
    }else if (card_type==2)
    {
        cityLabel.hidden=YES;
        NSString *cityString=[NSString stringWithFormat:@"提醒人:%@",personnel];
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Arial" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=cityString;
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        
        
    }else if (card_type==3)
    {
        
        cityLabel.hidden=YES;
        NSString *cityString=[NSString stringWithFormat:@"提醒人:%@",personnel];
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Arial" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=cityString;
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        
        
    }else if (card_type==4)
    {
        cityLabel.hidden=YES;
        NSString *cityString=[NSString stringWithFormat:@"邀约人:%@",personnel];
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=inTimeString1;
        addressLabel.font=[UIFont fontWithName:@"Arial" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=cityString;
//        shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
    }else if (card_type==5)
    {
        cityLabel.hidden=NO;
        weatherImage.image=[UIImage imageNamed:headImageArray[card_type-1]];
        
        addressLabel.text=textString;
        addressLabel.font=[UIFont fontWithName:@"Arial" size:11];
        addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [addressLabel setNumberOfLines:0];
        [addressLabel sizeToFit];
        addressLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        addressLabel.frame=CGRectMake(weatherImage.frame.origin.x+weatherImage.frame.size.width+10, weatherImage.frame.origin.y+10, WIDTH-(weatherImage.frame.origin.x+weatherImage.frame.size.width+20), 12);
        
        shijianLabel.text=inTimeString1;
        //shijianLabel.backgroundColor=[UIColor redColor];
        shijianLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [shijianLabel setNumberOfLines:0];
        [shijianLabel sizeToFit];
        shijianLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        shijianLabel.frame=FRAME(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
        cityLabel.text=@"航班:";
        cityLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [cityLabel setNumberOfLines:0];
        [cityLabel sizeToFit];
        cityLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cityLabel.frame=FRAME(addressLabel.frame.origin.x, shijianLabel.frame.origin.y+shijianLabel.frame.size.height+10, addressLabel.frame.size.width, 13);
        
    }

    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(19, inTimeLabel.frame.origin.y+inTimeLabel.frame.size.height+5, WIDTH-38, 1);
    lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [self.view addSubview:lineView];
    
    zambiaButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-112, lineView.frame.origin.y-27, 22, 22)];
    [zambiaButton setImage:[UIImage imageNamed:@"common_icon_like_c@2x"] forState:UIControlStateNormal];
    [zambiaButton addTarget:self action:@selector(zmaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zambiaButton];
    
    //zambiaLabel=[[UILabel alloc]init];
    [self zamLayout];
    
    
    
    UIButton *shareButton=[[UIButton alloc]init];
    shareButton.frame=CGRectMake(WIDTH-41, lineView.frame.origin.y-27, 22, 22);
    [shareButton setImage:[UIImage imageNamed:@"common_icon_share@2x"] forState:UIControlStateNormal];
    [self.view addSubview:shareButton];
    
    NSArray *headArray=[dic objectForKey:@"zan_top_10"];//@[@"MS",@"MS",@"MS",@"MS"];
    for (int i=0; i<headArray.count; i++) {
        UIImageView *headeView=[[UIImageView alloc]init];
        headeView.frame=CGRectMake(38+40*i, lineView.frame.origin.y+10, 30, 30);
        //headeView.backgroundColor=[UIColor brownColor];
        headeView.image=[UIImage imageNamed:headArray[i]];
        headeView.layer.cornerRadius=headeView.frame.size.width/2;
        [self.view addSubview:headeView];
    }
    
    liNeView=[[UIView alloc]init];
    liNeView.frame=CGRectMake(0, lineView.frame.origin.y+49, WIDTH, 1);
    liNeView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [self.view addSubview:liNeView];
    [self commwntLayout];
    [self PLJKLayout];
}
-(void)zmaAction:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DZ dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
}
-(void)logDowLoadDA:(id)sender
{
    NSLog(@"点赞成功");
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DETAILS dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
}
-(void)DZDownFail:(id)sender
{
     NSLog(@"点赞失败");
}
-(void)zamLayout
{
    [zambiaLabel removeFromSuperview];
    zambiaLabel=[[UILabel alloc]init];
    zambiaLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"total_zan"]];
    zambiaLabel.font=[UIFont fontWithName:@"Arial" size:20];
    [zambiaLabel setNumberOfLines:1];
    [zambiaLabel sizeToFit];
    zambiaLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    zambiaLabel.frame=FRAME(zambiaButton.frame.origin.x+zambiaButton.frame.size.width+5, zambiaButton.frame.origin.y, WIDTH-(zambiaButton.frame.origin.x+zambiaButton.frame.size.width+5)-41, 22);
    [self.view addSubview:zambiaLabel];
}
-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    DownloadManager *_download = [[DownloadManager alloc]init];
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone,@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_PLLB dict:_dict view:_tableView delegate:self finishedSEL:@selector(logDowLoadPLLB:) isPost:NO failedSEL:@selector(PLLBbDownFail:)];
}
-(void)logDowLoadPLLB:(id)sender
{
    NSLog(@"返回数据 %@",sender);
    plString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    NSLog(@"string的值%@",plString);
    if ([plString isEqualToString:@""]) {
        cellNum=0;
    }else
    {
        plArray=[sender objectForKey:@"data"];
        cellNum=plArray.count;
    }
    
    [self tableViewLayout];
}
-(void)PLLBbDownFail:(id)sender
{
    
}

-(void)tableViewLayout
{
    NSLog(@"能不能成功");
    [_tableView removeFromSuperview];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, liNeView.frame.origin.y+1, WIDTH, HEIGHT-liNeView.frame.origin.y-50)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //tableView.backgroundColor=[UIColor yellowColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)commwntLayout
{
    underView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    underView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:underView];
    textView=[[UITextView alloc]initWithFrame:CGRectMake(17/2,9, WIDTH-86, 31)];
    textView.delegate=self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    textView.layer.borderWidth = 0.6f;
    textView.layer.cornerRadius = 6.0f;
    [underView addSubview:textView];
    
    UIButton *commentButton=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60-15/2, 9, 60, 31)];
    commentButton.backgroundColor=[UIColor redColor];
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    commentButton.titleLabel.textColor=[UIColor whiteColor];
    commentButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
    commentButton.layer.cornerRadius=7;
    [commentButton addTarget:self action:@selector(commentButtonAN) forControlEvents:UIControlEventTouchUpInside];
    [underView addSubview:commentButton];
}
-(void)commentButtonAN
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [self.view endEditing:YES];
    underView.frame=CGRectMake(0, HEIGHT-49, WIDTH, 49);
    [UIView commitAnimations];
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[NSString stringWithFormat:@"%d",_card_ID];
    NSLog(@"ID%@  %d",card_Id, _card_ID);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone,@"comment":textView.text};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_PL dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadPingLun:) isPost:YES failedSEL:@selector(PingLubDownFail:)];
    [textView setText:@""];
    
    NSLog(@"text%@",textView.text);
}
-(void)logDowLoadPingLun:(id)sender
{
    [self PLJKLayout];
    NSLog(@"评论成功");
}
-(void)PingLubDownFail:(id)sender
{
    NSLog(@"评论失败");
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldBeginEditing");
    
    return YES;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
    underView.frame=CGRectMake(0, HEIGHT-height-49, WIDTH, 49);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 29;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"评论";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return cellNum;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=plArray[indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[plDic objectForKey:@"name"]];
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:13];
    
    cell.textLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[plDic objectForKey:@"comment"]];
    [cell.detailTextLabel setNumberOfLines:0];
    cell.detailTextLabel.font=[UIFont fontWithName:@"Arial" size:14];
    
    double inTime=[[plDic objectForKey:@"add_time"] doubleValue];
    NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
    inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
    [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
    [inTimeformatter setDateFormat:@"HH:mm"];
    NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
    NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.text=inTimeString;
    timeLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
    timeLabel.font=[UIFont fontWithName:@"Arial" size:13];
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.frame=FRAME(WIDTH-20-timeLabel.frame.size.width, 10, timeLabel.frame.size.width, 13);
    [cell addSubview:timeLabel];
    
    [cell.layer setMasksToBounds:YES];
    cell.layer.cornerRadius=10;
    cell.layer.borderColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1].CGColor;
    cell.layer.borderWidth=1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *plDic=plArray[indexPath.row];
    NSString *inforStr = [NSString stringWithFormat:@"%@",[plDic objectForKey:@"comment"]];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(300,2000);
    CGSize labelsize = [inforStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelsize.height+30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
