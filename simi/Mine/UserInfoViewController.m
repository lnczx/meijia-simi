//
//  UserInfoViewController.m
//  simi
//
//  Created by zrj on 14-11-13.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserinfoView.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "USERINFOBaseClass.h"
#import "BaiduMobStat.h"
#import "ISLoginManager.h"
#import "SettingsViewController.h"
#import "MyAccountController.h"
#import "MineViewController.h"
@interface UserInfoViewController ()<userInfoDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UserinfoView *_userview;
    NSString *filePath;//图片的沙盒路径
}

@end

@implementation UserInfoViewController
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"账号信息", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"账号信息", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navlabel.text = @"账号信息";
    
    _userview = [[UserinfoView alloc]initWithFrame:FRAME(0, 64, _WIDTH, 54*5+10)];
    _userview.delegate = self;
    _userview.userInteractionEnabled = NO;
    [self.view addSubview:_userview];
    
    UIButton *bttn = [UIButton buttonWithType:UIButtonTypeCustom];
    bttn.frame = FRAME(14, SELF_VIEW_HEIGHT-14-108/2, 584/2, 108/2);
    [bttn setBackgroundColor:HEX_TO_UICOLOR(NAV_COLOR, 1.0)];
    [bttn setTitle:@"退出登录" forState:UIControlStateNormal];
    [bttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bttn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [bttn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [bttn addTarget:self action:@selector(takeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bttn];
    
    UIButton *disBtn = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-50, 20, 50, 44)];
    [disBtn setTitle:@" " forState:UIControlStateNormal];
    [disBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [disBtn setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
    [disBtn setTitleColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0) forState:UIControlStateNormal];
    [disBtn setBackgroundColor:[UIColor clearColor]];
    disBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [disBtn addTarget:self action:@selector(UserInfoEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disBtn];

    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict = @{@"user_id":_manager.telephone};
    [_download requestWithUrl:USER_INFO dict:_dict view:self.view delegate:self finishedSEL:@selector(DownloadFinish2:) isPost:NO failedSEL:@selector(FailDownload:)];
}
- (void)UserInfoEdit:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@" "]) {
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        _userview.userInteractionEnabled = YES;
    }else{
        
        [btn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];

        NSString *name;
        NSString *phone;
        NSString *sex;
        for (int i = 0; i < 5; i++) {
            UITextField *textfield = (UITextField *)[_userview viewWithTag:1000+i];
            
            switch (i) {
                case 0:
                    
                    break;
                case 1:
                    name = textfield.text;
                    break;
                case 2:
                    phone = textfield.text;
                    break;
                case 3:
                    sex = textfield.text;
                    break;
                case 4:
                    
                    break;
                    
                    
                default:
                    break;
            }
        }
        
        NSLog(@"name:%@  phone:%@   sex:%@",name,phone,sex);
        
        if ([phone isEqualToString:@""]) {
            [self showHint:@"手机号不能为空哦"];
            return;
        }
        
        NSData *imgData = [GetPhoto getPhotoDataFromName:@"image.png"];
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"name":name,@"mobile":phone,@"sex":sex};
        [_download requestWithUrl:USERINFO_EDIT dict:_dict view:self.view delegate:self finishedSEL:@selector(EditFinish:) isPost:YES failedSEL:@selector(FailDownload:)];

    }

    
}
- (void)EditFinish:(id)dict
{
    int status = [[dict objectForKey:@"status"] intValue];
    if (status ==0){
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }

}
#pragma mark 下载成功
- (void)DownloadFinish2:(id)responsobject
{
    USERINFOBaseClass *_base = [[USERINFOBaseClass alloc]initWithDictionary:responsobject];
    
    if (_base.status == 0) {
        _userview.mydata = _base.data;
    }
}

#pragma mark 下载失败
- (void)FailDownload:(id)error
{
    [self showAlertViewWithTitle:@"修改失败" message:nil];
}

- (void)takeout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];

    SettingsViewController *set = [[SettingsViewController alloc]init];
    [set logoutAction];
    NSUserDefaults *_default = [NSUserDefaults standardUserDefaults];
    [_default removeObjectForKey:@"telephone"];
    [_default removeObjectForKey:@"islogin"];
    [_default synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
//
//    ISLoginManager *manager = [ISLoginManager shareManager];
//    manager.isLogin = NO;
    
}
- (void)selectBrnPressedWithTag:(NSInteger)btntag
{
    switch (btntag) {
        case 0:
        {
            NSLog(@"头像");
//            MyAccountController *account = [[MyAccountController alloc]init];
//            [self.navigationController pushViewController:account animated:YES];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"拍照",@"我的相册", nil];
            sheet.tag = 1;
            [sheet showInView:self.view];
            break;
        }

        case 1:
            NSLog(@"昵称");

            break;

        case 3:
            NSLog(@"性别");
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"男",@"女", nil];
            sheet.tag = 2;
            [sheet showInView:self.view];

            break;
        }
        case 4:
            NSLog(@"私秘卡");

            break;

            
        default:
            break;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"拍照");
                [self takePhoto];
                break;
            case 1:
                NSLog(@"我的相册");
                [self LocalPhoto];
                break;
                
                
            default:
                break;
        }

    }
    else if (actionSheet.tag == 2)
    {
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"男");
                UITextField *textField = (UITextField *)[_userview viewWithTag:1003];
                textField.text = @"男";
            }
                break;
            case 1:
            {
                NSLog(@"女");
                UITextField *textField = (UITextField *)[_userview viewWithTag:1003];
                textField.text = @"女";
            }
                break;
                
                
            default:
                break;
        }

    }
}
#pragma mark - 从相机获取
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing =YES;
        picker.sourceType =UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"无法拍照" message:@"此设备拍照功能不可用" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alerView show];
    }
}
#pragma mark - 本地照片库
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;  //类型
    picker.delegate = self;  //协议
    picker.allowsEditing =YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - UIImagePickerCont≥rollerDelegate
/*当选择一张图片后进入*/
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        

        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];

        NSLog(@"filePath:%@",filePath);
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        UIImageView *smallimage = [[UIImageView alloc] init];
        smallimage.frame = _userview.headImg.frame;
        smallimage.top  = smallimage.top +64;
        smallimage.image = [GetPhoto fixOrientation:image];
//        smallimage.image = [GetPhoto thumbnailWithImageWithoutScale:image size:CGSizeMake(40, 40)];
        
        //加在视图中
        [self.view addSubview:smallimage];
        
    } 
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)uploadUserHeadPicture:(UIImage *)image
{
    
}
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
