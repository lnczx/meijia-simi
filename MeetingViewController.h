//
//  MeetingViewController.h
//  simi
//
//  Created by 白玉林 on 15/8/10.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "THContactPickerView.h"
#import "THContactPickerTableViewCell.h"
@interface MeetingViewController : FatherViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ABPersonViewControllerDelegate,THContactPickerDelegate>
@property (nonatomic ,assign)int textID;
@property (nonatomic ,assign)int time;
@property (nonatomic ,assign)NSInteger vcID;

@property (nonatomic ,strong)UITableView *mailTableview;
@property (nonatomic ,strong)THContactPickerView *contactPickerView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@end
