//
//  FoundViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FoundViewController.h"
#import "ImgWebViewController.h"
@interface FoundViewController ()
{
    UIView *rootView;
    UIButton *tabBar;
    UIButton *tabBar1;
    UIButton *tabBar2;
    UIButton *tabBar3;
}
@end

@implementation FoundViewController
@synthesize scrollerView,lineImageView,vcID;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (vcID==1005) {
        self.backBtn.hidden=NO;
    }else
    {
        self.backBtn.hidden=YES;
    }
    
    self.navlabel.text=@"发现";
    
//    NSError *error;
//    NSURL *url=[NSURL URLWithString:@"http://91simi.com/webinapp/app-faxian-list.html"];
//    NSData *data=[NSData dataWithContentsOfURL:url];
//    NSLog( @"能否接收到数据？？%@",data);
//    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *str=[[NSString alloc]initWithData:data encoding:enc];
//    NSData *rootData=[str dataUsingEncoding:enc];
////    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:rootData options:NSJSONReadingMutableLeaves error:&error];
//    NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog( @"能否接收到数据？？%@",string);
    
    rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 49)];
    [self.view addSubview:rootView];
    lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 34, WIDTH/4, 1)];
    lineImageView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [rootView addSubview:lineImageView];
    
    NSArray *array=@[@"工商代办",@"会计财务",@"员工管理",@"其他服务"];
    for (int i=0; i<4; i++) {
        if (i==0) {
            _imgurl=@"http://123.57.173.36/html/simi-inapp/app-faxian-list.htm";
            [self webView];
            tabBar=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-240)/4/2, 10, 60, 20)];
            [tabBar setTitle:array[i] forState:UIControlStateNormal];
            [tabBar setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [tabBar addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
            [tabBar setTag:1000];
            tabBar.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
            [rootView addSubview:tabBar];
        }else if(i==1){
            tabBar1=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-240)/4/2+(60+(WIDTH-240)/4), 10, 60, 20)];
            [tabBar1 setTitle:array[i] forState:UIControlStateNormal];
            [tabBar1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar1 addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
            [tabBar1 setTag:1001];
            tabBar1.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
            [rootView addSubview:tabBar1];
        }else if (i==2){
            tabBar2=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-240)/4/2+(60+(WIDTH-240)/4)*2, 10, 60, 20)];
            [tabBar2 setTitle:array[i] forState:UIControlStateNormal];
            [tabBar2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar2 addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
            [tabBar2 setTag:1002];
            tabBar2.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
            [rootView addSubview:tabBar2];
        }else if (i==3){
            tabBar3=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-240)/4/2+(60+(WIDTH-240)/4)*3, 10, 60, 20)];
            [tabBar3 setTitle:array[i] forState:UIControlStateNormal];
            [tabBar3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar3 addTarget:self action:@selector(tabbarButton:) forControlEvents:UIControlEventTouchUpInside];
            [tabBar3 setTag:1003];
            tabBar3.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
            [rootView addSubview:tabBar3];

        }
    }  // Do any additional setup after loading the view.
}
-(void)webView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:FRAME(0, 113, WIDTH, HEIGHT-64)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgurl]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}
-(void)tabbarButton:(UIButton *)sender
{
    
//    NSString *urL=@"http://91simi.com/webinapp/app-faxian-list.html";
//    NSLog( @"URL%@",urL);
    switch (sender.tag) {
        case 1000:
    
            _imgurl=@"http://123.57.173.36/html/simi-inapp/app-faxian-list.htm";
            [self webView];
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:1];
            lineImageView.frame=CGRectMake(WIDTH/4*(sender.tag-1000), 34, WIDTH/4, 1);
            [tabBar setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [tabBar1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView commitAnimations];
            break;
            
        case 1001:
            _imgurl=@"http://123.57.173.36/html/simi-inapp/app-faxian-list.htm";
            [self webView];
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:1];
            lineImageView.frame=CGRectMake(WIDTH/4*(sender.tag-1000), 34, WIDTH/4, 1);
            [tabBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [tabBar2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView commitAnimations];
            break;
        case 1002:
            _imgurl=@"http://123.57.173.36/html/simi-inapp/app-faxian-list.htm";
            [self webView];
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:1];
            lineImageView.frame=CGRectMake(WIDTH/4*(sender.tag-1000), 34, WIDTH/4, 1);
            [tabBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [tabBar3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView commitAnimations];
            break;
        case 1003:
            _imgurl=@"http://123.57.173.36/html/simi-inapp/app-faxian-list.htm";
            [self webView];
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:1];
            lineImageView.frame=CGRectMake(WIDTH/4*(sender.tag-1000), 34, WIDTH/4, 1);
            [tabBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBar3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView commitAnimations];
            break;
            
        default:
            break;
    }
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
