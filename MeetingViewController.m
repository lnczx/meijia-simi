//
//  MeetingViewController.m
//  simi
//
//  Created by 白玉林 on 15/8/10.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "MeetingViewController.h"
#import <AddressBook/AddressBook.h>
#import "DCRoundSwitch.h"
#import "TimePicker.h"
#import "MeetingPickerView.h"
#import "THContact.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "MeetingViewController.h"

#import "ConTentViewController.h"
int heights;
int H = 0;
@interface MeetingViewController ()<timePickerDelegate,meetingPickerDelegate>
{
    UIView *backgroundView;
    
    UILabel *selectLabel;
    UILabel *numberLabel;
    UILabel *timeLabel;
    UILabel *placeLabel;
    UILabel *meetingLabel;
    UILabel *contentLabel;
    
    NSString *selectString;
    NSString *numberString;
    NSString *timeString;
    NSString *placeString;
    NSString *meetingString;
    NSString *remarksString;
    NSString *contentString;
    
    UIButton *timeButton;
    UIButton *placeButton;
    
    UIView *secretaryView;
    DCRoundSwitch *switchButton;
    DCRoundSwitch *switchBut;
    UITextView *remarksView;
    CGRect frame;
    TimePicker *picker;
    MeetingPickerView *meetingDatePicker;
    UIButton *barButton;
    NSMutableArray *nameArray;
    NSMutableArray *mobileArray;
    int theNumber;
    UITapGestureRecognizer *tapSelf;
    UIView *selfView;
    
    UIImageView *msImageView;
    UIImage *msImages;
    
    UIView *sendView;
    int card_type_ID;
    int txIndex;
    int mscl;
    int whether_to_send;
    
    ConTentViewController *viewController;
    
}
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@end
#define kKeyboardHeight 0.0
@implementation MeetingViewController
@synthesize textID,time;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CFErrorRef error;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    textID=0;
    time=0;
    theNumber=1;
    msImages=[UIImage imageNamed:@"CLGH_MS_TB_@2x"];
    selfView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:selfView];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    self.view.tag=1005;
    tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapSelf];
    switch (_vcID) {
        case 1001:
        {
            self.navlabel.text=@"会议安排";
            card_type_ID=1;
        }
            break;
        case 1002:
        {
            self.navlabel.text=@"事务提醒";
            card_type_ID=3;
        }
            break;
        case 1003:
        {
            self.navlabel.text=@"邀约通知";
            card_type_ID=4;
        }
            break;
        case 1004:
        {
            self.navlabel.text=@"秘书叫早";
            card_type_ID=2;
        }
            break;
            
        default:
            break;
    }
    selfView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    
    
    
    [self tableViewLayout];
    
    [self viewLayout];
    

    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    contentString=viewController.textString;
    [self contentLabelLayout];
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshContacts];
    });
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [remarksView resignFirstResponder];
    remarksView.frame=frame;
    remarksString=remarksView.text;
    [self labelLayout];
    [UIView commitAnimations];
}
-(void)viewDidAppear:(BOOL)animated
{
    picker = [[TimePicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    picker.delegate = self;
    [self.view addSubview:picker];
    
    meetingDatePicker=[[MeetingPickerView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 250)];
    meetingDatePicker.delegate=self;
    [self.view addSubview:meetingDatePicker];
}
#pragma mark 通讯录相关的初始化方法
-(void)tableViewLayout
{
    nameArray=[[NSMutableArray alloc]init];
    mobileArray=[[NSMutableArray alloc]init];
    self.contactPickerView=[[THContactPickerView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 100)];
    //self.contactPickerView.backgroundColor=[UIColor redColor];
    self.contactPickerView.delegate=self;
    [self.contactPickerView setPlaceholderString:@"联系人姓名"];
    self.contactPickerView.hidden=YES;
    [self.view addSubview:self.contactPickerView];
    
    barButton= [[UIButton alloc] initWithFrame:FRAME(WIDTH-70, 27, 60, 30)];
    barButton.enabled = FALSE;
    [barButton setTitle:@"确定" forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    barButton.hidden=YES;
    barButton.layer.cornerRadius=8;
    [self.view addSubview:barButton];
    
    self.mailTableview=[[UITableView alloc]initWithFrame:FRAME(0, self.contactPickerView.frame.size.height, WIDTH, HEIGHT - self.contactPickerView.frame.size.height - kKeyboardHeight)];
    self.mailTableview.dataSource=self;
    self.mailTableview.delegate=self;
    self.mailTableview.hidden=YES;
    [self.mailTableview registerNib:[UINib nibWithNibName:@"THContactPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    [self.view insertSubview:self.mailTableview belowSubview:self.contactPickerView];
    //[self.view addSubview:self.mailTableview];
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        }
    });

}
#pragma mark 确定按钮点击方法
-(void)barButtonAction:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    remarksView.frame=frame;
    remarksString=remarksView.text;
    [self labelLayout];
    [UIView commitAnimations];
    tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapSelf];
    
    self.mailTableview.hidden=YES;
    self.contactPickerView.hidden=YES;
    barButton.hidden=YES;
    selfView.hidden=NO;
    sendView.hidden=NO;
    NSLog(@"数组:%@",nameArray);
    [self ParticipationLabelLayout];
    
}
#pragma mark 通讯录的相关方法
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
        
        [self.mailTableview reloadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
}

#pragma mark 通讯录的相关方法
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
#pragma mark 通讯录的相关方法

#pragma mark 通讯录的相关方法
- (void) refreshContacts
{
    for (THContact* contact in self.contacts)
    {
        [self refreshContact: contact];
    }
    [self.mailTableview reloadData];
}
#pragma mark 通讯录的相关方法
- (void) refreshContact:(THContact*)contact
{
    
    ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, (ABRecordID)contact.recordId);
    contact.recordId = ABRecordGetRecordID(contactPerson);
    
    // Get first and last names
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
    
    // Set Contact properties
    contact.firstName = firstName;
    contact.lastName = lastName;
    
    // Get mobile number
    ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
    contact.phone = [self getMobilePhoneProperty:phonesRef];
    if(phonesRef) {
        CFRelease(phonesRef);
    }
    
    // Get image if it exists
    NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
    contact.image = [UIImage imageWithData:imgData];
    if (!contact.image) {
        contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
}
#pragma mark - UITableView Delegate and Datasource functions
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
}
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog( @"是多少?%lu",(unsigned long)self.filteredContacts.count);
    return self.filteredContacts.count;

}
#pragma mark 通讯录的相关方法的 表格tableView的代理与数据协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the desired contact from the filteredContacts array
    THContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *mobilePhoneNumberLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    
    // Assign values to to US elements
    contactNameLabel.text = [contact fullName];
    mobilePhoneNumberLabel.text = contact.phone;
    if(contact.image) {
        contactImage.image = contact.image;
    }
    contactImage.layer.masksToBounds = YES;
    contactImage.layer.cornerRadius = 25;
    
    // Set the checked state for the contact selection checkbox
    UIImage *image;
    if ([self.selectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
    } else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    }
    checkboxImageView.image = image;
    
    
    return cell;
}
#pragma mark 通讯录的相关方法的 表格tableView的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hide Keyboard
    
        [self.contactPickerView resignKeyboard];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // This uses the custom cellView
        // Set the custom imageView
        THContact *user = [self.filteredContacts objectAtIndex:indexPath.row];
        UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
        UIImage *image;
        if (theNumber<=10) {
        if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
            //cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedContacts removeObject:user];
            [self.contactPickerView removeContact:user];
            [nameArray removeObject:user.fullName];
            [mobileArray removeObject:user.phone];
            theNumber-=1;
            // Set checkbox to "unselected"
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
        } else {
            // Contact has not been selected, add it to THContactPickerView
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedContacts addObject:user];
            [self.contactPickerView addContact:user withName:user.fullName];
            // Set checkbox to "selected"
            NSLog(@"这是什么玩意:%@,%@",user.phone,user.fullName);
            [nameArray addObject:user.fullName];
            NSString *mobileString=[NSString stringWithFormat:@"%@",user.phone];
            NSString *strUrl = [mobileString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [mobileArray addObject:strUrl];
            image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
            theNumber++;
        }
        
        // Enable Done button if total selected contacts > 0
        if(self.selectedContacts.count > 0) {
            barButton.enabled = TRUE;
            barButton.backgroundColor=[UIColor blueColor];
        }
        else
        {
            barButton.enabled = FALSE;
            barButton.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
        }
        
        // Update window title
        self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
        selectString=[nameArray componentsJoinedByString:@","];
        numberString=[NSString stringWithFormat:@"%lu",(unsigned long)self.selectedContacts.count];
        
        // Set checkbox image
        checkboxImageView.image = image;
        // Reset the filtered contacts
        self.filteredContacts = self.contacts;
        // Refresh the tableview
        [self.mailTableview reloadData];
            
            
           
        
    }else{
//        THContact *users = [self.filteredContacts objectAtIndex:indexPath.row];
//        [nameArray removeObject:users.fullName];
//        [nameArray addObject:user.fullName];
        if ([self.selectedContacts containsObject:user]) {
            [self.selectedContacts removeObject:user];
            [self.contactPickerView removeContact:user];
            [nameArray removeObject:user.fullName];
            theNumber-=1;
            // Set checkbox to "unselected"
            image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
            [self.mailTableview reloadData];
        }else
        {
            //[self ParticipationLabelLayout];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                message:@"最多可选择10人！！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        
    }
 NSLog(@"个数::%d",theNumber);
    
}

#pragma mark - THContactPickerTextViewDelegate
#pragma mark 通讯录的相关方法的
- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"firstName", textViewText, @"lastName", textViewText];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
    [self.mailTableview reloadData];
}
#pragma mark 通讯录的相关方法的
- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
    [self adjustTableViewFrame:YES];
}
#pragma mark 通讯录的相关方法的
- (void)contactPickerDidRemoveContact:(id)contact {
    [self.selectedContacts removeObject:contact];
    [nameArray removeObject:contact];
    theNumber-=1;
    NSUInteger index = [self.contacts indexOfObject:contact];
    UITableViewCell *cell = [self.mailTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Set unchecked image
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    checkboxImageView.image = image;
    
    // Update window title
    self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
}
#pragma mark 通讯录的相关方法的
- (void)removeAllContacts:(id)sender
{
    [self.contactPickerView removeAllContacts];
    [self.selectedContacts removeAllObjects];
    self.filteredContacts = self.contacts;
    [self.mailTableview reloadData];
}
#pragma mark ABPersonViewControllerDelegate
#pragma mark 通讯录的相关方法的
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}
#pragma mark 通讯录的相关方法的
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topOffset = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]){
        topOffset = 64;
    }
    CGRect frames = self.contactPickerView.frame;
    frames.origin.y = topOffset;
    self.contactPickerView.frame = frames;
    [self adjustTableViewFrame:NO];
}
#pragma mark 通讯录的相关方法的
- (void)adjustTableViewFrame:(BOOL)animated {
    CGRect frames = self.mailTableview.frame;
    // This places the table view right under the text field
    frames.origin.y = self.contactPickerView.frame.size.height+64;
    // Calculate the remaining distance
    frames.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
    
    if(animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.mailTableview.frame = frames;
        
        [UIView commitAnimations];
    }
    else{
        self.mailTableview.frame = frames;
    }
}

#pragma mark 页面布局的方法
-(void)viewLayout
{
    backgroundView=[[UIView alloc]init];
    backgroundView.backgroundColor=[UIColor whiteColor];
    [selfView addSubview:backgroundView];
    [self LineViewLayout];
    [self labelViewLayout];
    
    secretaryView=[[UIView alloc]initWithFrame:FRAME(0, backgroundView.frame.origin.y+backgroundView.frame.size.height+8, WIDTH, 84/2)];
    secretaryView.backgroundColor=[UIColor whiteColor];
    [selfView addSubview:secretaryView];
    
    msImageView=[[UIImageView alloc]init];
    msImageView.frame=CGRectMake(39/2, 29/2, 32/2, 32/2);
    [self msImageViewLayout];
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(msImageView.frame.origin.x+msImageView.frame.size.width+10, 25/2, label.frame.size.width, 32/2);
    label.text=@"需要秘书处理";
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    [secretaryView addSubview:label];
    
    switchBut=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(WIDTH-50-35/2, 44/4, 50, 42/2)];
    //switchButton.backgroundColor=[UIColor redColor];
    switchButton.on=NO;
    //            [switchButton setOn:NO];
    [switchBut addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switchBut.onText = @"YES"; //NSLocalizedString(@"YES", @"");
    switchBut.offText = @"NO";//NSLocalizedString(@"NO", @"");
    [secretaryView addSubview:switchBut];
    
    remarksView=[[UITextView alloc]initWithFrame:FRAME(0, secretaryView.frame.origin.y+secretaryView.frame.size.height+1, WIDTH, 84/2)];
    remarksView.backgroundColor=[UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1];
    remarksView.delegate=self;
//    CGSize size = [remarksView sizeThatFits:CGSizeMake(remarksView.frame.size.width, MAXFLOAT)];
//    remarksView.frame =FRAME(0, secretaryView.frame.origin.y+secretaryView.frame.size.height+1, WIDTH, size.height);
    //remarksString=@"您可以给秘书捎句话                      最多可输入100字";
    [self labelLayout];
    [selfView addSubview:remarksView];
    frame=remarksView.frame;
    
    sendView=[[UIView alloc]initWithFrame:FRAME(0, HEIGHT-50, WIDTH, 50)];
    sendView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sendView];
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
    [sendView addSubview:lineView];
    UIButton *sendButton=[[UIButton alloc]initWithFrame:FRAME((WIDTH-576/2)/2, 20/2, 576/2, 31)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.backgroundColor=[UIColor redColor];
    sendButton.layer.cornerRadius=10;
    switch (_vcID) {
        case 1001:
        {
            [sendButton setTitle:@"发起会议" forState:UIControlStateNormal];
        }
            break;
        case 1002:
        {
            [sendButton setTitle:@"发起事务" forState:UIControlStateNormal];
        }
            break;
        case 1003:
        {
            [sendButton setTitle:@"发起邀约" forState:UIControlStateNormal];
        }
            break;
        case 1004:
        {
            [sendButton setTitle:@"发起叫早" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [sendView addSubview:sendButton];
    
}

-(void)msImageViewLayout
{
    msImageView.image=msImages;
    [secretaryView addSubview:msImageView];
}
#pragma mark 灰色线的位置方法
-(void)LineViewLayout
{
    int a=1;
    
    for (int i=0; i<4; i++) {
        UIView *lineView=[[UIView alloc]init];
        lineView.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
        if (i==0) {
            lineView.frame=FRAME(35/2, 58, WIDTH-35, 1);
        }else if (i==1)
        {
            switch (_vcID) {
                case 1001:
                {
                    H=165;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                case 1002:
                {
                    H=117;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                case 1003:
                {
                    H=117;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                case 1004:
                {
                    H=117;
                    lineView.frame=FRAME(35/2, H, WIDTH-35, 1);
                }
                    break;
                    
                default:
                    break;
            }
            //lineView.frame=FRAME(35/2, 165, WIDTH-35, 1);
        }else
        {
            lineView.frame=FRAME(35/2, H+84/2*a, WIDTH-35, 1);
            a++;
        }
        [backgroundView addSubview:lineView];
        backgroundView.frame=FRAME(0, 15/2, WIDTH,lineView.frame.origin.y+86/2);
    }
   
    
}

#pragma mark 页面显示view的相关布局
-(void)labelViewLayout
{
    int a=0;
    NSArray *array=[[NSArray alloc]init];
    switch (_vcID) {
        case 1001:
        {
            array=@[@"会议内容",@"提醒设置",@"立即给相关人员消息"];
        }
            break;
        case 1002:
        {
            array=@[@"提醒内容",@"提醒设置",@"立即给相关人员消息"];
        }
            break;
        case 1003:
        {
            array=@[@"邀约内容",@"提醒设置",@"立即给相关人员消息"];
        }
            break;
        case 1004:
        {
            array=@[@"叫早内容",@"提醒设置",@"立即给相关人员消息"];
        }
            break;
            
        default:
            break;
    }

    NSArray *imageArray=@[@"",@"",@"HYAP_TX_TB_@2x",@"CLGH_TX_TB_@2x",@"HYAP_XG_TB_@2x"];
    for (int i=0; i<5; i++) {
        UIView *labelView=[[UIView alloc]init];
        labelView.tag=1000+i;
        if (i==0) {
            labelView.frame=FRAME(35/2, 0, WIDTH-35, 58);
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapParticipationAction)];
            [labelView addGestureRecognizer:tap];
            
            
            UILabel *titleLabel=[[UILabel alloc]init];
            switch (_vcID) {
                case 1001:
                {
                   titleLabel.text=@"参会人员";
                }
                    break;
                case 1002:
                {
                    titleLabel.text=@"提醒人员";
                }
                    break;
                case 1003:
                {
                    titleLabel.text=@"邀约人员";
                }
                    break;
                case 1004:
                {
                    titleLabel.text=@"叫早人员";
                }
                    break;
                    
                default:
                    break;
            }

            
            titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [titleLabel setNumberOfLines:0];
            [titleLabel sizeToFit];
            titleLabel.frame=FRAME(6/2, 20, titleLabel.frame.size.width, 14);
            titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
            [labelView addSubview:titleLabel];
            UILabel *chooseLabel=[[UILabel alloc]init];
            chooseLabel.frame=FRAME(6/2,34+17/2, 40, 11);
            chooseLabel.text=@"以选择:";
            chooseLabel.font=[UIFont fontWithName:@"Arial" size:11];
            chooseLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
            [labelView addSubview:chooseLabel];
            selectLabel=[[UILabel alloc]init];
            numberLabel=[[UILabel alloc]init];
            [self ParticipationLabelLayout];
            
        }else if (i==1)
        {
            
            switch (_vcID) {
                case 1001:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 106);
                }
                    break;
                case 1002:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 58);
                }
                    break;
                case 1003:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 58);
                }
                    break;
                case 1004:
                {
                    labelView.frame=FRAME(35/2, 59, WIDTH-35, 58);
                }
                    break;
                    
                default:
                    break;
            }

            timeButton=[[UIButton alloc]initWithFrame:FRAME(0, 10, WIDTH-35, 33)];
            [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [timeButton.layer setCornerRadius:8.0]; //设置矩圆角半径
            [timeButton.layer setBorderWidth:1.0];//边框宽度
            timeButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
            timeButton.layer.cornerRadius=8.0f;
            timeButton.layer.masksToBounds=YES;
            timeButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
            timeButton.layer.borderWidth= 1.0f;
            [labelView addSubview:timeButton];
            timeLabel=[[UILabel alloc]init];
            UILabel *inTimeLabel=[[UILabel alloc]init];
            switch (_vcID) {
                case 1001:
                {
                    inTimeLabel.text=@"会议时间";
                }
                    break;
                case 1002:
                {
                    inTimeLabel.text=@"提醒时间";
                }
                    break;
                case 1003:
                {
                    inTimeLabel.text=@"邀约时间";                }
                    break;
                case 1004:
                {
                    inTimeLabel.text=@"叫早时间";
                }
                    break;
                    
                default:
                    break;
            }

            
            inTimeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [inTimeLabel setNumberOfLines:0];
            [inTimeLabel sizeToFit];
            inTimeLabel.font=[UIFont fontWithName:@"Arial" size:13];
            inTimeLabel.frame=FRAME(10, 10, inTimeLabel.frame.size.width, timeButton.frame.size.height-20);
            [timeButton addSubview:inTimeLabel];
            
            placeButton=[[UIButton alloc]initWithFrame:FRAME(0, 53, WIDTH-35, 33)];
            switch (_vcID) {
                case 1001:
                {
                    placeButton.hidden=NO;
                }
                    break;
                case 1002:
                {
                    placeButton.hidden=YES;
                }
                    break;
                case 1003:
                {
                    placeButton.hidden=YES;                }
                    break;
                case 1004:
                {
                    placeButton.hidden=YES;
                }
                    break;
                    
                default:
                    break;
            }
            [placeButton.layer setCornerRadius:8.0]; //设置矩圆角半径
            [placeButton.layer setBorderWidth:1.0];//边框宽度
            placeButton.layer.backgroundColor=[[UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1] CGColor];
            placeButton.layer.cornerRadius=8.0f;
            placeButton.layer.masksToBounds=YES;
            placeButton.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
            placeButton.layer.borderWidth= 1.0f;
            [labelView addSubview:placeButton];
            placeLabel=[[UILabel alloc]init];
            UILabel *plaLabel=[[UILabel alloc]init];
            plaLabel.text=@"会议地点";
            plaLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            [plaLabel setNumberOfLines:0];
            [plaLabel sizeToFit];
            plaLabel.frame=FRAME(10, 10, plaLabel.frame.size.width, placeButton.frame.size.height-20);
            plaLabel.font=[UIFont fontWithName:@"Arial" size:13];
            [placeButton addSubview:plaLabel];
            [self timeLabelLayout];
            [self addressLabelLayout];
            
            
        }else
        {
            labelView.frame=FRAME(35/2, H+1+86/2*a, WIDTH-35, 84/2);
            UIImageView *headimageView=[[UIImageView alloc]init];
            if (i==3) {
                headimageView.frame=CGRectMake(2, 25/2, 32/2, 32/2);
            }else{
                headimageView.frame=CGRectMake(2, 25/2, 20, 32/2);
            }
            
            headimageView.image=[UIImage imageNamed:imageArray[i]];
            //headimageView.backgroundColor=[UIColor redColor];
            [labelView addSubview:headimageView];
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(headimageView.frame.origin.x+30, 23/2, label.frame.size.width, 32/2);
            label.text=array[a];
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            [label sizeToFit];
            label.font=[UIFont fontWithName:@"Arial" size:16];
            [labelView addSubview:label];
            if (i==2) {
                contentLabel=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+label.frame.origin.x+5,23/2, labelView.frame.size.width-(label.frame.size.width+label.frame.origin.x+5), labelView.frame.size.height-22)];
                //contentLabel.backgroundColor=[UIColor brownColor];
                
                [labelView addSubview:contentLabel];
                [self contentLabelLayout];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentAction)];
                [labelView addGestureRecognizer:tap];
                
            }
            if (i==3) {
                meetingLabel=[[UILabel alloc]init];
                [self labelLayout];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemindAction)];
                [labelView addGestureRecognizer:tap];
                meetingString=@"不提醒";
                [self remindLabelLayout];
                
            }
            if (i==4)
            {
                switchButton=[[DCRoundSwitch alloc]initWithFrame:CGRectMake(labelView.frame.size.width-50, 44/4, 50, 42/2)];
                switchButton.on=NO;
                [switchButton addTarget:self action:@selector(switchButAction:) forControlEvents:UIControlEventValueChanged];
                switchButton.onText = @"YES"; //NSLocalizedString(@"YES", @"");
                switchButton.offText = @"NO";//NSLocalizedString(@"NO", @"");
                [labelView addSubview:switchButton];
            }
            a++;
        }
        //labelView.backgroundColor=[UIColor redColor];
        [backgroundView addSubview:labelView];
    }
}
#pragma mark参会人员及个数label显示
-(void)ParticipationLabelLayout
{
    //selectString=@"白 ,马";
    selectLabel.text=selectString;
    selectLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [selectLabel setNumberOfLines:1];
    [selectLabel sizeToFit];
    selectLabel.frame=FRAME(41/2+40,34+17/2,selectLabel.frame.size.width,11);
    selectLabel.font=[UIFont fontWithName:@"Arial" size:11];
    selectLabel.textColor=[UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    [backgroundView addSubview:selectLabel];
    
    //numberString=@"3位";
    numberLabel.text=numberString;
    numberLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [numberLabel setNumberOfLines:0];
    [numberLabel sizeToFit];
    numberLabel.font=[UIFont fontWithName:@"Arial" size:14];
    numberLabel.textColor=[UIColor redColor];
    numberLabel.frame=FRAME(WIDTH-59/2-numberLabel.frame.size.width, 20, numberLabel.frame.size.width, 14);
    [backgroundView addSubview:numberLabel];
}
#pragma mark会议时间label显示
-(void)timeLabelLayout
{
    //timeString=@"2015/08/11  16:16";
    timeLabel.text=timeString;
    timeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [timeLabel setNumberOfLines:1];
    [timeLabel sizeToFit];
    timeLabel.font=[UIFont fontWithName:@"Arial" size:14];
    timeLabel.textColor=[UIColor redColor];
    timeLabel.frame=FRAME(65, 10, timeLabel.frame.size.width, 14);
    timeLabel.font=[UIFont fontWithName:@"Arial" size:13];
    [timeButton addSubview:timeLabel];
}
#pragma mark会议地点文本显示
-(void)addressLabelLayout
{
    placeString=@"宇飞大厦";
    placeLabel.text=placeString;
    placeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [placeLabel setNumberOfLines:0];
    [placeLabel sizeToFit];
    placeLabel.font=[UIFont fontWithName:@"Arial" size:14];
    placeLabel.textColor=[UIColor redColor];
    placeLabel.frame=FRAME(65, 10, placeLabel.frame.size.width, 14);
    placeLabel.font=[UIFont fontWithName:@"Arial" size:13];
    [placeButton addSubview:placeLabel];

}
#pragma mark会议内容文本显示
-(void)contentLabelLayout
{
    
    contentLabel.text=contentString;
    contentLabel.font=[UIFont fontWithName:@"Arial" size:14];
    
}
#pragma mark提醒设置label显示
-(void)remindLabelLayout
{
    meetingLabel.text=meetingString;
    meetingLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [meetingLabel setNumberOfLines:1];
    [meetingLabel sizeToFit];
    //meetingLabel.backgroundColor=[UIColor redColor];
    meetingLabel.frame=FRAME(WIDTH-35/2-meetingLabel.frame.size.width, H+84/2+23/2, meetingLabel.frame.size.width, 32/2);
    meetingLabel.font=[UIFont fontWithName:@"Arial" size:13];
    [backgroundView addSubview:meetingLabel];
}

#pragma mark textView的自适应
-(void)labelLayout
{
    
    if ([remarksString isEqual:@""]||remarksString==NULL) {
        textID=0;
    }else
    {
        textID=1;
    }
    //NSLog(@"日了 %@",remarksString);
    //NSString *desContent=remarksString;
    if (textID==1) {
        CGRect orgRect=remarksView.frame;//获取原始UITextView的frame
        CGSize  size = [remarksString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:0];
        orgRect.size.height=size.height+10;//获取自适应文本内容高度
        remarksView.frame=orgRect;//重设UITextView的frame
    }
    //remarksView.text=remarksString;
    
}

#pragma mark 开关按钮switchButton的点击相应事件方法
-(void)switchAction:(id)sender
{
    
    UISwitch *switchBuT=(UISwitch *)sender;
    if (switchBuT.isOn) {
        msImages=[UIImage imageNamed:@"CLGH_MS_GTB_@2x"];
        whether_to_send=1;
    }else
    {
        msImages=[UIImage imageNamed:@"CLGH_MS_TB_@2x"];
        whether_to_send=0;
    }
    [self msImageViewLayout];
    
}
#pragma mark 开关按钮switchBut的相应事件方法
-(void)switchButAction:(id)sender
{
    
    UISwitch *switchBuT=(UISwitch *)sender;
    if (switchBuT.isOn) {
        mscl=1;
    }else
    {
        mscl=0;
    }
    
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
        //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    heights = keyboardRect.size.height;
    remarksView.frame=CGRectMake(0, HEIGHT-heights-84/2-49-24, WIDTH, 49);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"超过最大字数不能输入了"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.view endEditing:YES];
        return  NO;
            }
    else
    {
        return YES;
    }
}
#pragma mark点击空白隐藏键盘方法
-(void)tapAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    [remarksView resignFirstResponder];
    remarksView.frame=frame;
    remarksString=remarksView.text;
        [self labelLayout];
    [UIView commitAnimations];
}

#pragma mark TimePicker提醒设置代理方法
- (void)suanle
{
    sendView.hidden=YES;
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
}

- (void)hours:(NSString *)hours //minutes:(NSString *)minutes
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    meetingString=[NSString stringWithFormat:@"%@",hours];
    [self remindLabelLayout];
    [self labelLayout];
}
#pragma mark点击会议参与人员的响应方法
-(void)tapParticipationAction
{
    
    for (UISwipeGestureRecognizer *recognizer in [[self view] gestureRecognizers]) {
        [[self view] removeGestureRecognizer:recognizer];
        [UIView beginAnimations:nil context:nil];
        //设置动画时长
        [UIView setAnimationDuration:0.5];
        [selfView endEditing:YES];
        remarksView.frame=frame;
        remarksString=remarksView.text;
        [self labelLayout];
        [UIView commitAnimations];
    }
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
    [UIView commitAnimations];
    
    self.mailTableview.hidden=NO;
    self.contactPickerView.hidden=NO;
    barButton.hidden=NO;
    sendView.hidden=YES;
    self.view.userInteractionEnabled=YES;
    selfView.userInteractionEnabled=YES;
    sendView.userInteractionEnabled=YES;
//    backgroundView.hidden=YES;
//    remarksView.hidden=YES;
//    secretaryView.hidden=YES;

    selfView.hidden=YES;
}

#pragma mark点击会议内容的响应方法
-(void)tapContentAction
{
    viewController=[[ConTentViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark点击提醒设置的响应方法
-(void)tapRemindAction
{
    
    //        datePicker.backgroundColor = [UIColor grayColor];
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
    meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
    [UIView commitAnimations];
}
#pragma mark会议时间点击方法
-(void)timeButtonAction:(id)sender
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    meetingDatePicker.frame=FRAME(0, HEIGHT-250, WIDTH, 250);
    picker.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
}
#pragma mark 会议时间选择器代理方法
-(void)meetingDateQuxiao
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
    [UIView commitAnimations];
}
-(void)meetingDateQueding:(NSString *)date
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    meetingDatePicker.frame=FRAME(0, HEIGHT, WIDTH, 250);
    timeString=date;
    [self timeLabelLayout];
    [UIView commitAnimations];
}

#pragma mark 发起任务请求按钮点击方法
-(void)sendAction:(UIButton *)sender
{
    if (selectString==nil||selectString==NULL) {
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择参会人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (timeString==nil||timeString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择会议时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (placeString==nil||placeString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请选择会议地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else if (contentString==nil||contentString==NULL){
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请填写会议内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];
        
    }else{
        //获取当前时间
        //获取当前时间
        NSString *str=[NSString stringWithFormat:@"%@",timeString];
        NSLog(@"时间%@",str);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate* dat = [formatter dateFromString:str];
        int a=[dat timeIntervalSince1970];
        NSString *timestring = [NSString stringWithFormat:@"%d", a];
        NSLog( @"当前时间戳%@",timestring);
        
        ISLoginManager *_manager = [ISLoginManager shareManager];
        NSLog(@"有值么%@",_manager.telephone);
        
        NSString *type_ID=[NSString stringWithFormat:@"%d",card_type_ID];
        NSString *txROW=[NSString stringWithFormat:@"%ld",(long)picker.txRow];
        NSString *whether=[NSString stringWithFormat:@"%d",whether_to_send];
        NSString *msclString=[NSString stringWithFormat:@"%d",mscl];
        
        NSMutableArray *dicArray=[[NSMutableArray alloc]init];
        for (int i=0; i<nameArray.count; i++) {
        NSDictionary *dic=@{@"mobile":mobileArray[i],@"name":nameArray[i]};
            [dicArray addObject:dic];
        }
        NSArray *infor=[NSArray arrayWithArray:dicArray];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infor options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DownloadManager *_download = [[DownloadManager alloc]init];
         NSLog(@"有没有成功%@",jsonString);
        
        NSDictionary *_dict = @{@"card_id":@"0",@"card_type":type_ID,@"create_user_id":_manager.telephone,@"user_id":_manager.telephone,@"attends":jsonString,@"service_time":timestring,@"service_addr":placeString,@"service_content":contentString,@"set_remind":txROW,@"set_now_send":whether,@"set_sec_do":msclString,@"set_sec_remarks":remarksString};
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
