//
//  SecretFriendsViewController.m
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "SecretFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import "THContact.h"
#import "ISLoginManager.h"
#import "DownloadManager.h"
#import "ListViewController.h"
#import "MyselfViewController.h"

@interface SecretFriendsViewController ()
{
    NSArray *secretArray;
    NSArray *recommendArray;
    NSArray *secretaryArray;
    NSArray *titleArray;
    NSMutableArray *sectionArray;
    NSMutableArray *cellArray;
    NSString *user_ID;
}
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@end

@implementation SecretFriendsViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden=YES;
    self.navlabel.text=@"秘友";
    titleArray=@[@"",@"我的好友"];
    cellArray=[[NSMutableArray alloc]init];
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        }
    });
    // Do any additional setup after loading the view.
}
-(void)getContactsFromAddressBook
{
    CFErrorRef error=NULL;
    self.contacts=[[NSMutableArray alloc]init];
    ABAddressBookRef addressBOok=ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBOok) {
        NSArray *allContacts=(__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBOok);
        NSMutableArray *mutableContacts=[NSMutableArray arrayWithCapacity:allContacts.count];
        NSUInteger i=0;
        for (i=0; i<allContacts.count; i++) {
            THContact *contact=[[THContact alloc]init];
            ABRecordRef contactPerson=(__bridge ABRecordRef)allContacts[i];
            contact.recordId=ABRecordGetRecordID(contactPerson);
            NSString *firstName=(__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            contact.firstName=firstName;
            contact.lastName=lastName;
            ABMultiValueRef phonesRef=ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone=[self getMobilePhoneProperty:phonesRef];
            if (phonesRef) {
                CFRelease(phonesRef);
            }
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
            }            [mutableContacts addObject:contact];
            
        }
        
        if(addressBOok) {
            CFRelease(addressBOok);
        }
        
        self.contacts = [NSArray arrayWithArray:mutableContacts];
        self.selectedContacts = [NSMutableArray array];
        self.filteredContacts = self.contacts;
        for (int i=0; i<self.filteredContacts.count; i++) {
            THContact *contact = [self.filteredContacts objectAtIndex:i];
            UIImage *headImage=contact.image;
            NSString *nameString=[NSString stringWithFormat:@"%@",contact.fullName];
            NSString *string=[NSString stringWithFormat:@"%@",contact.phone];
            NSString *phoneString=[string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSLog(@"通讯录数据%@,%@",nameString,phoneString);
            NSDictionary *dic=@{@"name":nameString,@"phone":phoneString,@"image":headImage};
            [cellArray addObject:dic];
        }
        
        NSString *jsonString=[cellArray componentsJoinedByString:@","];
        NSLog(@"%@",jsonString);
    }
    else
    {
        NSLog(@"Error");
        
    }
}
- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self dataLayout];
}
-(void)dataLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    user_ID=_manager.telephone;
    NSDictionary *_dict = @{@"user_id":user_ID};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_HYLB dict:_dict view:self.view delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    [_tableView removeFromSuperview];
    [secretArray reverseObjectEnumerator];
    [secretaryArray reverseObjectEnumerator];
    [recommendArray reverseObjectEnumerator];
    [sectionArray reverseObjectEnumerator];
    secretArray=[sender objectForKey:@"data"];
    //secretaryArray=@[@"1"];
    recommendArray=@[@"添加通讯录好友"];
    sectionArray=[[NSMutableArray alloc]initWithObjects:recommendArray,secretArray, nil];
    _tableView=[[UITableView alloc]initWithFrame:FRAME(0, 90, WIDTH, HEIGHT-139)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    NSLog(@"好友列表数据%@",sender);
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
//制定个性标题，这里通过UIview来设计标题，功能上丰富，变化多。
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    [view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1]];//改变标题的颜色，也可用图片
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH, 20)];
    
    //label.textColor = [UIColor redColor];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = [titleArray objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
    
}

//指定标题的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 30;
    }
}
//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [titleArray count];
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count;
    //上面的方法也是可行的，大家参考比较下
    NSLog(@"数组内容%@",[sectionArray objectAtIndex:1]);
    if (section==1) {
        NSArray *array=[sectionArray objectAtIndex:1];
        //NSString *array=[[sectionArray objectAtIndex:section]componentsJoinedByString:@","];
         NSLog(@"数组内容%@",array);
       // NSLog(@"%@",array.length);
       
        if ([array isEqual:@""]) {
            count=0;
        }else
        {
            count=[[sectionArray objectAtIndex:section] count];
        }
    }else{
         count=[[sectionArray objectAtIndex:section] count];  //取dataArray中的元素，并根据每个元素（数组）来判断分区中的行数。
    }
   
    
    
    return count;
    
    
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    NSString *string=[array objectAtIndex:indexPath.row];
    UIImageView *headImage=[[UIImageView alloc]init];
    UILabel *textLabel=[[UILabel alloc]init];
    NSString *identifier = [NSString stringWithFormat:@"（%ld,%ld)",(long)indexPath.row,(long)indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        headImage.frame=FRAME(10, 5, 40, 40);
        //headImage.backgroundColor=[UIColor blackColor];
        headImage.layer.cornerRadius=headImage.frame.size.width/2;
        headImage.clipsToBounds = YES;
        [cell addSubview:headImage];
        textLabel.frame=FRAME(60, 15, WIDTH-80, 20);
        textLabel.font=[UIFont fontWithName:@"Arial" size:17];
        [cell addSubview:textLabel];
    }
    if (indexPath.section==1) {
        NSArray *array=[sectionArray objectAtIndex:indexPath.section];
        NSDictionary *dic=[array objectAtIndex:indexPath.row];
        [textLabel setText:[dic objectForKey:@"name"]];
        NSString *imageString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"head_img"]];
        NSLog(@"1%@2",imageString);
        if ([imageString length]==0||[imageString length]==1) {
            headImage.image=[UIImage imageNamed:@"家-我_默认头像"];
        }else
        {
            headImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]]]];
        }
    }else{
         NSArray *array=[sectionArray objectAtIndex:indexPath.section];
        [textLabel setText:[array objectAtIndex:indexPath.row]];
        headImage.image=[UIImage imageNamed:@"家-我_默认头像"];
    }
    

        return cell;
}
//改变行的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array=[sectionArray objectAtIndex:1];
    NSString *arrayString=[NSString stringWithFormat:@"%@",array];
   
    if (indexPath.section==0) {
        
        ListViewController *vc=[[ListViewController alloc]init];
        vc.dataArray=cellArray;
        vc.hyArray=array;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
         NSDictionary *dic=array[indexPath.row];
        NSString *view_userid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"friend_id"]];
        MyselfViewController *vc=[[MyselfViewController alloc]init];
        vc.userID=user_ID;
        vc.rootId=1;
        vc.view_userID=view_userid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)DownFail:(id)sender
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
