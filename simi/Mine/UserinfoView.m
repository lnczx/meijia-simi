//
//  UserinfoView.m
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "UserinfoView.h"

@interface UserinfoView ()
{
    UITextField *_rightlabel;
}
@end
@implementation UserinfoView
@synthesize delegate = _delegate,headImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *_backlabel = [[UILabel alloc]initWithFrame:FRAME(0, 9, _CELL_WIDTH, 54*5+15)];
        _backlabel.backgroundColor = COLOR_VAULE(255.0);
        [self addSubview:_backlabel];
        
        NSArray *_nameArr = @[@"头像",@"昵称：",@"手机：",@"性别：",@"私秘卡："];
        
        for (int i = 0; i < 5; i ++) {
            
            UILabel *_leftlabel = [[UILabel alloc]initWithFrame:FRAME(18, 24+54*i, 60, 54)];
            _leftlabel.textColor = COLOR_VAULE(102.0);
            _leftlabel.font = MYFONT(13.5);
            _leftlabel.text = [_nameArr objectAtIndex:i];
            [self addSubview:_leftlabel];
            
            _rightlabel = [[UITextField alloc]initWithFrame:FRAME(70, 24+54*i, _CELL_WIDTH-70-25, 54)];
            _rightlabel.textColor = [self getColor:@"E8374A"];
            _rightlabel.delegate = self;
            _rightlabel.textAlignment = NSTextAlignmentRight;
            _rightlabel.returnKeyType = UIReturnKeyDone;
            _rightlabel.font = MYFONT(13.5);
            [_rightlabel setTag:(1000+i)];
            [self addSubview:_rightlabel];
            if (i == 0 || i == 3||i ==4) {
                _rightlabel.userInteractionEnabled = NO;
            }
            
            UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:FRAME(self_Width-24.5-10, 0, 24.5, 24.5)];
            rightImgView.top = i == 0? (69-24.5)/2+10 : 40+54*i;
            rightImgView.hidden = i == 2? YES : NO;
            rightImgView.image = [UIImage imageNamed:@"s-right-arrow@2x"];
            rightImgView.hidden = YES;
            [self addSubview:rightImgView];
            
            
            UIButton *btn = [[UIButton alloc]initWithFrame:FRAME(0, 0, self_Width, 54)];
            btn.top = i == 0? 19 : 69+54*(i-1);
//            btn.backgroundColor = [UIColor redColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        
        for (int i = 0; i < 6; i ++) {
            UIImageView *_lineview = [[UIImageView alloc]initWithFrame:FRAME(0, 24+54*i, _CELL_WIDTH, 0.5)];
            _lineview.backgroundColor = COLOR_VAULE(211.0);
            _lineview.hidden = i == 0? YES : NO;
            [self addSubview:_lineview];
        }
        
        //头像
        UIImage *image = [GetPhoto getPhotoFromName:@"image.png"];
        
        headImg = [[UIImageView alloc]init];

        [headImg.layer setCornerRadius:45/2];
        headImg.layer.masksToBounds = YES;
        
        if (image) {
            headImg.image = image;
        }else{
            headImg.image = [UIImage imageNamed:@"chatListCellHead@2x"];
        }
        
        headImg.frame = FRAME(self_Width-34.5-45, 22, 45, 45);
        
        [self addSubview:headImg];
        
    }
    
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (int i = 0; i < 5; i++) {
        UITextField *_label = (UITextField *)[self viewWithTag:(1000+i)];

        switch (i) {
            case 0:
                [_label resignFirstResponder];
                break;
            case 1:
                [_label resignFirstResponder];
                break;
            case 2:
                [_label resignFirstResponder];
                break;
            case 3:
                [_label resignFirstResponder];
                break;
            case 4:
                [_label resignFirstResponder];
                break;
                
            default:
                break;
        }
    }
    return YES;
}

- (void)BtnAction:(UIButton *)sender
{
    [self.delegate selectBrnPressedWithTag:sender.tag];
    UITextField *textfield = (UITextField *)[self viewWithTag:(1000+sender.tag)];
    [textfield becomeFirstResponder];
}

- (void)setMydata:(USERINFOData *)mydata
{
    for (int i = 0; i < 5; i ++) {
        UITextField *_label = (UITextField *)[self viewWithTag:(1000+i)];
        switch (i) {
            case 0:
//                _label.text = mydata.mobile;
                break;
                
            case 1:
//                _label.text = [NSString stringWithFormat:@"%0.1f元",mydata.restMoney];
                _label.text = mydata.userName;
                break;

            case 2:
                _label.text = [NSString stringWithFormat:@"%@",mydata.mobile];
                break;

            case 3:
                _label.text = [NSString stringWithFormat:@"%@",mydata.gender];
                break;
                
            case 4:
                if (mydata.seniorRange.length) {
                    _label.text = mydata.seniorRange;
                }else{
                    _label.text = @"您还没有购买私秘服务哦!";
                    
                }
                
                break;

            default:
                break;
        }
    }
}

- (USERINFOData *)mydata
{
    return _mydata;
}


@end
