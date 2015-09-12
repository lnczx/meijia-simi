//
//  NewsViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "NewsViewController.h"
#import "ChatViewController.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "MeetingViewController.h"
@interface NewsViewController ()
{
    UITableView *_tableView;
    NSDictionary *dict;
    NSArray *array;
    ISLoginManager *_manager;
    MeetingViewController *vc;
    
}
@end

@implementation NewsViewController
@synthesize shujuArray;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.backBtn.hidden=YES;
    self.navlabel.text=@"消息";
    self.navigationController.navigationBarHidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self dataLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog( @"通讯录的数据信息%@",shujuArray);
   _manager = [ISLoginManager shareManager];
    
}

-(void)dataLayout
{
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSString *user_ID=_manager.telephone;
    NSDictionary *_dict = @{@"user_id":user_ID};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_HYXX dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    NSLog(@"好友消息列表数据%@",sender);
    array=[sender objectForKey:@"data"];
    NSLog(@"数组个数%lu",(unsigned long)array.count);
    [_tableView removeFromSuperview];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, HEIGHT-139)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
}
-(void)DownFail:(id)sender
{
    NSLog(@"获取好友消息失败");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=array[indexPath.row];
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        NSString *headString=[NSString stringWithFormat:@"%@",[dic objectForKeyedSubscript:@"head_img"]];
        NSLog( @"123%@",headString);
        if (headString == nil||headString == NULL||[headString isEqualToString:@"<null>"] ) {
            headImage.image =[UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
           headImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
        }
        
        headImage.layer.cornerRadius=headImage.frame.size.width/2;
        headImage.clipsToBounds = YES;
        [cell addSubview:headImage];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, WIDTH-130, 20)];
        nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        nameLabel.font=[UIFont fontWithName:@"Arial" size:19];
        [cell addSubview:nameLabel];
        
        double inTime=[[dic objectForKey:@"add_time"] doubleValue];
        NSDateFormatter* inTimeformatter =[[NSDateFormatter alloc] init];
        inTimeformatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [inTimeformatter setDateStyle:NSDateFormatterMediumStyle];
        [inTimeformatter setTimeStyle:NSDateFormatterShortStyle];
        [inTimeformatter setDateFormat:@"HH:mm"];
        NSDate* inTimedate = [NSDate dateWithTimeIntervalSince1970:inTime];
        NSString* inTimeString = [inTimeformatter stringFromDate:inTimedate];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-50, 15, 40, 10)];
        timeLabel.text=[NSString stringWithFormat:@"%@",inTimeString];
        timeLabel.font=[UIFont fontWithName:@"Arial" size:10];
        [cell addSubview:timeLabel];
        
        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, cell.frame.size.height, WIDTH-90, 15)];
        textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"im_content"]];
        textLabel.font=[UIFont fontWithName:@"Arial" size:15];
        [cell addSubview:textLabel];

    }    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=array[indexPath.row];
    ChatViewController *vcr=[[ChatViewController alloc]initWithChatter:[dic objectForKey:@"to_im_user_name"] isGroup:NO];
    vcr.title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [vcr.navigationController setNavigationBarHidden:NO];
    NSLog(@"%@,,,%@",[dict objectForKey:@"im_sec_nickname"],[dict objectForKey:@"im_sec_username"]);
    [self.navigationController pushViewController:vcr animated:YES];
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
