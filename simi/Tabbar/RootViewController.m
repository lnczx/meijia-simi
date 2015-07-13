//
//  RootViewController.m
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "RootViewController.h"
#import "FirstViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
#import "MoreViewController.h"
#import "PayViewController.h"
#import "ISLoginManager.h"
#import "MyLogInViewController.h"
#import "SMBaseViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
@interface RootViewController ()
{
    UIView *mainView;
    UIViewController *currentViewController;
    UIImageView *barView;
    //    UIButton *button;
    ISLoginManager *_manager;
}
@end
#pragma mark - View lifecycle
SMBaseViewController * firstViewController;
MyLogInViewController *secondViewController;
MineViewController *thirdViewController;


//SMBaseViewController *baseVC;
//MyLogInViewController *logVC;
//MineViewController *mineVC;

//MoreViewController *fourViewController;
//LoginViewController *loginViewController;
@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    APPLIACTION.leiName = @"66";
    
    _manager = [ISLoginManager shareManager];
    
    
    //    manager = [ISLoginManager shareManager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginReturn:) name:@"LOGIN_SUCCESS" object:nil];
    
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT-78/2)];
    [self.view addSubview:mainView];
    
    /**
     对于那些当前暂时不需要显示的subview，
     只通过addChildViewController把subViewController加进去；
     需要显示时再调用transitionFromViewController方法。
     将其添加进入底层的ViewController中。
     **/
    
    
    firstViewController = [[SMBaseViewController alloc]init];
    [self addChildViewController:firstViewController];
    
    secondViewController = [[MyLogInViewController alloc]init];
    [self addChildViewController:secondViewController];
    
    
    thirdViewController = [[MineViewController alloc]init];
    [self addChildViewController:thirdViewController];
    
//    fourViewController = [[MoreViewController alloc]init];
//    [self addChildViewController:fourViewController];
    
    [mainView addSubview:firstViewController.view];
    currentViewController = firstViewController;
    
    [self makeTabbarView];
}
- (void)makeTabbarView
{
    
    NSArray *barArr = @[@"发现",@"",@"我的"];
    NSArray *imagesArray =@[@"tab-home",@"加号-512",@"tab-mine"];
    float _btnwidth = self.view.frame.size.width/3;
    
    
//    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT-49, SELF_VIEW_WIDTH, 49)];
//    img.backgroundColor = [UIColor blackColor];
//    img.image = [UIImage imageNamed:@"tab_back"];
//    img.userInteractionEnabled = YES;
//    [self.view addSubview:img];
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(0, SELF_VIEW_HEIGHT-50, SELF_VIEW_WIDTH, 1)];
    lable.backgroundColor = [UIColor grayColor];
    lable.tag = 777;
    lable.alpha = 0.3;

    [self.view addSubview:lable];

    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+_btnwidth*i, SELF_VIEW_HEIGHT-49, _btnwidth, 49);
        [button setTag:(100+i)];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(26, -60, 0, 0)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imagesArray[i]]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, (_btnwidth-19)/2, 20, (_btnwidth-19)/2)];
        [button setTitle:[barArr objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(SelectBarbtnWithtag:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:button];
        
        if (i == 1) {
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(-23, (_btnwidth-19), 5, (_btnwidth-19))];

        }
        if (i == 0) {
//            [button setImageEdgeInsets:UIEdgeInsetsMake(10, (_btnwidth-19)/2, 20, (_btnwidth-19)/2)];

            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -90, -25, 63)];

        }
    
    }
    
    
    
    
    
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[UIButton class]]) {
            if (view.tag == 100) {
                [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                [(UIButton *)view setImage:[UIImage imageNamed:@"tab-home-pressdown"] forState:UIControlStateNormal];
                
            }
            
            else if(view.tag == 102)
            {
                [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
                [(UIButton *)view setImage:[UIImage imageNamed:@"tab-mine"] forState:UIControlStateNormal];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFication:) name:@"RETURN" object:nil];
    
    
    
    if ([APPLIACTION.leiName isEqualToString:@"66"]) {
        
    }else{
        [self tabbarhidden];
    }
    
}
- (void)tabbarhidden
{
    UILabel *lable = (UILabel *)[self.view viewWithTag:777];
    lable.hidden = YES;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    btn.hidden = YES;
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    btn1.hidden = YES;
    
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    btn2.hidden = YES;


}
- (void)tabbarhiddenNO
{
    UILabel *lable = (UILabel *)[self.view viewWithTag:777];
    lable.hidden = NO;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    btn.hidden = NO;
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    btn1.hidden = NO;
    
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    btn2.hidden = NO;
    
    
}
- (void)AddFication:(NSNotification *)obj
{
    [self makeTabbarView];
    
}
- (void)SelectBarbtnWithtag:(UIButton *)sender
{
    
    if ((currentViewController==firstViewController&&[sender tag]==100)||(currentViewController==secondViewController&&[sender tag]==101) ||(currentViewController==thirdViewController&&[sender tag]==102) ) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    
    
    switch ([sender tag]) {
        case 100:
        {

            [self transitionFromViewController:currentViewController toViewController:firstViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
            
//                    [currentViewController removeFromParentViewController];

                    currentViewController=firstViewController;

//                    [mainView addSubview:currentViewController.view];
                    
                    for (UIView *view in self.view.subviews) {
                        if ([view isMemberOfClass:[UIButton class]]) {
                            if (view.tag == 100) {
                                [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                                [(UIButton *)view setImage:[UIImage imageNamed:@"tab-home-pressdown"] forState:UIControlStateNormal];
                                
                            }

                            else if(view.tag == 102)
                            {
                                [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
                                [(UIButton *)view setImage:[UIImage imageNamed:@"tab-mine"] forState:UIControlStateNormal];
                            }
                        }
                    }

                }else{
                    currentViewController=oldViewController;
                    
                    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
                    [btn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"tab-mine-pressdown"] forState:UIControlStateNormal];
                    UIButton *btn2 = (UIButton *)[self.view viewWithTag:100];
                    [btn2 setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
                    [btn2 setImage:[UIImage imageNamed:@"tab-home"] forState:UIControlStateNormal];


                }
            }];
            
            
        }
            break;
            
            
        case 101:
        {
            if (self.loginYesOrNo == YES) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHTOCHAT" object:nil];

                
            }
                [self transitionFromViewController:currentViewController toViewController:secondViewController duration:0.5 options:0 animations:^{
                    
                }  completion:^(BOOL finished) {
                    if (finished) {
            
//                        [currentViewController removeFromParentViewController];
//
                        currentViewController=secondViewController;
//
//                        [mainView addSubview:secondViewController.view];

                        
                        

                        
                    }else{
                        currentViewController=oldViewController;
                        
                    }
                }];

            
            
            
            
        }
            break;
            
        case 102:
        {
            [self transitionFromViewController:currentViewController toViewController:thirdViewController duration:0.5 options:0 animations:^{
                
            }  completion:^(BOOL finished) {
                if (finished) {


//                    [currentViewController removeFromParentViewController];
                    
                    currentViewController=thirdViewController;
                    
//                    [mainView addSubview:currentViewController.view];

                    
//                    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
//                    [btn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
//                    [btn setImage:[UIImage imageNamed:@"tab-mine-pressdown"] forState:UIControlStateNormal];
//                    UIButton *btn2 = (UIButton *)[self.view viewWithTag:100];
//                    [btn2 setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
//                    [btn2 setImage:[UIImage imageNamed:@"tab-home"] forState:UIControlStateNormal];
            
            for (UIView *view in self.view.subviews) {
                if ([view isMemberOfClass:[UIButton class]]) {
                    if (view.tag == 102) {
                        [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                        [(UIButton *)view setImage:[UIImage imageNamed:@"tab-mine-pressdown"] forState:UIControlStateNormal];
                        
                    }
                    else if(view.tag == 100)
                    {
                        [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
                        [(UIButton *)view setImage:[UIImage imageNamed:@"tab-home"] forState:UIControlStateNormal];
                    }
                }
            }

                }else{
                    currentViewController=oldViewController;

                    for (UIView *view in self.view.subviews) {
                        if ([view isMemberOfClass:[UIButton class]]) {
                            if (view.tag == 100) {
                                [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
                                [(UIButton *)view setImage:[UIImage imageNamed:@"tab-home"] forState:UIControlStateNormal];
                                
                            }
                            
                            else if(view.tag == 102)
                            {
                                [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                                [(UIButton *)view setImage:[UIImage imageNamed:@"tab-mine-pressdown"] forState:UIControlStateNormal];
                            }
                        }
                    }


                }
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)LoginReturn:(NSNotification *)noti
{
//    UIViewController *oldViewController=currentViewController;
//    [self transitionFromViewController:currentViewController toViewController:firstViewController duration:1 options:0 animations:^{
//    }  completion:^(BOOL finished) {
//        if (finished) {
            currentViewController=firstViewController;
           [mainView addSubview:firstViewController.view];
            for (UIView *view in self.view.subviews) {
                if ([view isMemberOfClass:[UIButton class]]) {
                    if (view.tag == 100) {
                        [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
                        [(UIButton *)view setImage:[UIImage imageNamed:@"tab-home-pressdown"] forState:UIControlStateNormal];
                        
                    }
                    
                    else if(view.tag == 102)
                    {
                        [(UIButton *)view setTitleColor:HEX_TO_UICOLOR(TAB_BAR_COLOR, 1.0) forState:UIControlStateNormal];
                        [(UIButton *)view setImage:[UIImage imageNamed:@"tab-mine"] forState:UIControlStateNormal];
                    }
                }
            }
//        }else{
//            currentViewController=oldViewController;
//        }
//    }];
    
}
//- (void)ZFBPaySuccess:(NSNotification *)notification
//{
//    
//    if (notification.object == nil) {
//        UIViewController *oldViewController=currentViewController;
//        [self transitionFromViewController:firstViewController toViewController:secondViewController duration:1 options:0 animations:^{
//            
//        }  completion:^(BOOL finished) {
//            if (finished) {
//                currentViewController=secondViewController;
//                
//            }else{
//                currentViewController=oldViewController;
//                
//            }
//        }];
//    }
//    
//}

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
