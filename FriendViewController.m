//
//  FriendViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/29.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FriendViewController.h"
#import "NewsViewController.h"
#import "SecretFriendsViewController.h"
@interface FriendViewController ()
{
    UIView *tabBarView;
    UIView *mainView;
    UIView *lineView;
    UIViewController *currentViewController;
    UIButton *newsButton;
    UIButton *secetFriendsButton;
    
}

@end
NewsViewController *newsViewController;
SecretFriendsViewController *secAccessController;
@implementation FriendViewController
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden=YES;
    self.navlabel.text=@"秘友";
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-100)];
    mainView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:mainView];
    newsViewController=[[NewsViewController alloc]init];
    [self addChildViewController:newsViewController];
    
    secAccessController=[[SecretFriendsViewController alloc]init];
    [self addChildViewController:secAccessController];
    
    [mainView addSubview:newsViewController.view];
    currentViewController = newsViewController;
    
    
    tabBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 26)];
    tabBarView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [self.view addSubview:tabBarView];
    lineView=[[UIView alloc]initWithFrame:FRAME((WIDTH/2-WIDTH/4)/2, 89, WIDTH/4, 1)];
    lineView.backgroundColor=[UIColor redColor];
    [self.view addSubview:lineView];
    NSArray *nameArray=@[@"消息",@"秘友"];
    for (int i=0; i<nameArray.count; i++) {
        if (i==0) {
            newsButton=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-120)/2/2+(60+(WIDTH-120)/2)*i, 0, 60, 25)];
            [newsButton setTitle:nameArray[i] forState:UIControlStateNormal];
            [newsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            newsButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
            [newsButton addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
            [newsButton setTag:(1000+i)];
            [tabBarView addSubview:newsButton];
        }else
        {
            secetFriendsButton=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-120)/2/2+(60+(WIDTH-120)/2)*i, 0, 60, 25)];
            [secetFriendsButton setTitle:nameArray[i] forState:UIControlStateNormal];
            [secetFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            secetFriendsButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
            [secetFriendsButton addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
            [secetFriendsButton setTag:(1000+i)];
            [tabBarView addSubview:secetFriendsButton];
        }
        
    }
    
    // Do any additional setup after loading the view.
}
-(void)tabBarButton:(UIButton *)sender
{
    if ((currentViewController==newsViewController&&[sender tag]==1000)||(currentViewController==secAccessController&&[sender tag]==1001)) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    
    switch (sender.tag) {
        case 1000:
        {
            [self transitionFromViewController:currentViewController toViewController:newsViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    lineView.frame=FRAME((WIDTH/2-WIDTH/4)/2, 89, WIDTH/4, 1);
                    [newsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [secetFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    currentViewController=newsViewController;
                    
                }else{
                    currentViewController=oldViewController;
                   
                }
                
            }];
        }
            break;
        case 1001:
        {
            [self transitionFromViewController:currentViewController toViewController:secAccessController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    lineView.frame=FRAME(WIDTH/2+(WIDTH/2-WIDTH/4)/2, 89, WIDTH/4, 1);
                    [newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [secetFriendsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    currentViewController=secAccessController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
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
