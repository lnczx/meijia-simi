//
//  ViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "ViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "PageTableViewCell.h"
#import "DetailsViewController.h"
#import "ShareFriendViewController.h"
@interface ViewController (){
    NSMutableDictionary *eventsByDate;
    UILabel *timeLabel;
    NSString *timeString;
    DownloadManager *_download;
    NSDictionary *_dict;
    UIView *viewMR;
    NSArray *numberArray;
}

@end
CGFloat newHeight = 300;
@implementation ViewController
float lastContentOffset;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self createRandomEvents];
    
    [self.calendar reloadData];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeString=locationString;
    //[dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
}
-(void)viewDidAppear:(BOOL)animated
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    _download = [[DownloadManager alloc]init];
    
    _dict =@{@"service_date":timeString,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableView delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    
    NSLog(@"登录后信息：%@",sender);
    NSString *senderString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    //if([tmpStr1 isEqualToString:tmpStr2])
    if([senderString isEqualToString:@""])
    {
        [self.tableView removeFromSuperview];
        [viewMR removeFromSuperview];
        viewMR=[[UIView alloc]initWithFrame:CGRectMake(0.0f, newHeight+70, WIDTH,HEIGHT-newHeight-119)];
        //view.backgroundColor=[UIColor brownColor];
        UILabel *la=[[UILabel alloc]initWithFrame:FRAME(20, 30, WIDTH-40, 20)];
        la.text=@"欢迎使用私密";
        la.textColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
        [viewMR addSubview:la];
        [self.view addSubview:viewMR];
    }else
    {
        [self.tableView removeFromSuperview];
        numberArray=[sender objectForKey:@"data"];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, newHeight+70, WIDTH,HEIGHT-newHeight-119)];
        //self.tableview.hidden=YES;
        self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.view addSubview:self.tableView];
        NSLog(@"数组个数%lu",(unsigned long)numberArray.count);
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (lastContentOffset <scrollView.contentOffset.y) {
        NSLog(@"向上滚动");
        [self didChangeModeTouch];
    }else{
        NSLog(@"向下滚动");
        [self didChangeModeTouch];
        
    }
    
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

#pragma mark - Buttons callback

- (void)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (void)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    NSArray *events = eventsByDate[key];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    timeString=locationString;
    NSLog(@"Date: %@ events", locationString);
    ISLoginManager *_manager = [ISLoginManager shareManager];
    _dict = @{@"service_date":timeString,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableView delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }else
    {
        newHeight = 300;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
    self.tableView.frame=CGRectMake(0.0f, newHeight+70, WIDTH,HEIGHT-newHeight-119);
}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
             
        [eventsByDate[key] addObject:randomDate];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    return numberArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=numberArray[indexPath.row];
    static NSString *identifier = @"cell";
    
    PageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        //        [cell setImageVIew:[UIImage imageNamed:@"SYCELL_HEAD_CY_@2x"] setLabel:@"18:00和刘总晚餐" label:@"刚刚" promptLabel:@"麻辣诱惑"];
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
    
    int card_type_Id=[[dic objectForKey:@"card_type"]intValue];
    NSArray *headImageArray=@[@"HYXQ_HEAD",@"MSJZ_HEAD",@"SWTX_HEAD",@"YYTZ_HEAD",@"CLGH_HEAD"];
    NSArray *headArray=@[@"HY",@"ZJ",@"SW",@"YY",@"CL"];
    cell.heideImage.image=[UIImage imageNamed:@"SYCELL_HEAD_CY_@2x"];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"card_type_name"]];
    [cell.titleLabel setNumberOfLines:1];
    [cell.titleLabel sizeToFit];
    
    //    double timeS=[[dic objectForKey:@"add_time_str"] doubleValue];
    //    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    //    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"HH:mm"];
    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeS];
    //    NSString* dateString = [formatter stringFromDate:date];
    
    cell.timeLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time_str"]];
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
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
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
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
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
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
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
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
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
        
        double inTime=[[dic objectForKey:@"service_time"] doubleValue];
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
        NSLog(@"%@",inTimeString);
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
    NSArray *array=@[@"common_icon_like_c@2x",@"common_icon_review@2x",@"common_icon_share@2x"];
    UIButton *zaButton=[[UIButton alloc]initWithFrame:CGRectMake(42, cell.view.frame.size.height-36, 22, 22)];
    [zaButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
    [zaButton setTag:indexPath.row];
    [zaButton addTarget:self action:@selector(zaButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:zaButton];
    UIButton *plButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*1, cell.view.frame.size.height-36, 22, 22)];
    [plButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateNormal];
    [plButton setTag:indexPath.row];
    [plButton addTarget:self action:@selector(plButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:plButton];
    UIButton *fxButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*2, cell.view.frame.size.height-36, 22, 22)];
    [fxButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateNormal];
    [fxButton setTag:indexPath.row];
    [fxButton addTarget:self action:@selector(fxButtonan:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:fxButton];
    
    
    //    [cell.plButton addTarget:self action:@selector(buttonan:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.fxButton addTarget:self action:@selector(buttonan:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PageTableViewCell *cell =[[PageTableViewCell alloc]init];
    return cell.view.frame.size.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *card_ID=[numberArray[indexPath.row]objectForKey:@"card_id"];
    NSLog(@"card_id%@",card_ID);
    DetailsViewController *vc=[[DetailsViewController alloc]init];
    //vc.pathId=(int)indexPath.row;
    vc.card_ID=[card_ID intValue];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)zaButtonan:(UIButton *)sender
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *card_Id=[numberArray[sender.tag]objectForKey:@"card_id"];
    NSLog(@"ID%@",card_Id);
    _dict = @{@"card_id":card_Id,@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_DZ dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadDA:) isPost:YES failedSEL:@selector(DZDownFail:)];
    
}
-(void)logDowLoadDA:(id)sender
{
    NSLog(@"点赞成功");
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    //service_date_str=morelocationString;
    _download = [[DownloadManager alloc]init];
    
    _dict = @{@"service_date":morelocationString,@"user_id":_manager.telephone,@"card_from":@"0",@"page":@"1"};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:CARD_LIST dict:_dict view:self.tableView delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
    
}
-(void)DZDownFail:(id)sender
{
    NSLog(@"点赞失败");
}

-(void)plButtonan:(UIButton *)sender
{
    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
    NSLog(@"card_id%@",card_ID);
    DetailsViewController *vc=[[DetailsViewController alloc]init];
    //vc.pathId=(int)indexPath.row;
    vc.card_ID=[card_ID intValue];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fxButtonan:(UIButton *)sender
{
    //    NSString *card_ID=[numberArray[sender.tag]objectForKey:@"card_id"];
    //    NSLog(@"card_id%@",card_ID);
    //    DetailsViewController *vc=[[DetailsViewController alloc]init];
    //    //vc.pathId=(int)indexPath.row;
    //    vc.card_ID=[card_ID intValue];
    //    [self.navigationController pushViewController:vc animated:YES];
    ShareFriendViewController *_controller = [[ShareFriendViewController alloc]init];
    [self.navigationController pushViewController:_controller animated:YES];
    
    
}


@end
