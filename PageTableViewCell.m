//
//  PageTableViewCell.m
//  simi
//
//  Created by 白玉林 on 15/7/30.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "PageTableViewCell.h"

@implementation PageTableViewCell
@synthesize sjLabel,moneyLabel,address;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _view=[[UIView alloc]init];
        _view.backgroundColor=[UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
        [self.contentView addSubview:_view];
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 8, WIDTH, 55)];
        headView.backgroundColor=[UIColor whiteColor];
        [_view addSubview:headView];
        
        _heideImage=[[UIImageView alloc]initWithFrame:CGRectMake(18, headView.frame.size.height-42, 30, 30)];
        //_heideImage.image=@"";
        //_heideImage.backgroundColor=[UIColor redColor];
        _heideImage.layer.cornerRadius=_heideImage.frame.size.width/2;
        [headView addSubview:_heideImage];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(58, headView.frame.size.height-42, (WIDTH-58)*0.66, 15)];
       // _titleLabel.backgroundColor=[UIColor redColor];
        [_titleLabel setNumberOfLines:0];
        _titleLabel.lineBreakMode =NSLineBreakByTruncatingTail ;
        _titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
        [headView addSubview:_titleLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+8, (WIDTH-58)*0.5, 12)];
        _timeLabel.font=[UIFont fontWithName:@"Arial" size:11];
        [_timeLabel setNumberOfLines:0];
        [headView addSubview:_timeLabel];
        
        _promptlabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-_promptlabel.frame.size.width-5,14,_promptlabel.frame.size.width,headView.frame.size.height-26)];//后面还会重新设置其size。
        [_promptlabel setNumberOfLines:0];
        _promptlabel.textAlignment = NSTextAlignmentRight;
        [headView addSubview:_promptlabel];
        
        UIView *layoutView=[[UIView alloc]init];
        layoutView.backgroundColor=[UIColor whiteColor];
        [_view addSubview:layoutView];
        
        UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(18, 0, WIDTH-36, 1)];
        lineImageView.backgroundColor=[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
        [layoutView addSubview:lineImageView];
        
        _descriptionView=[[UIImageView alloc]initWithFrame:CGRectMake(18, 11, 98, 80)];
        _descriptionView.image=[UIImage imageNamed:@"TX"];
        [layoutView addSubview:_descriptionView];
        
        sjLabel=[[UILabel alloc]initWithFrame:CGRectMake(129, 13, sjLabel.frame.size.width, 14)];
        sjLabel.text=@"时间:";
        sjLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        sjLabel.font=[UIFont fontWithName:@"Arial" size:13];
        [layoutView addSubview:sjLabel];
        
        _inTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(sjLabel.frame.size.width+sjLabel.frame.origin.x, 16, WIDTH-148-sjLabel.frame.size.width, 14)];
        [_inTimeLabel setNumberOfLines:1];
        [_inTimeLabel sizeToFit];
        _inTimeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        _inTimeLabel.font=[UIFont fontWithName:@"Arial" size:13];
        _inTimeLabel.text=@"2015年8月5日 11:54";
        _inTimeLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [layoutView addSubview:_inTimeLabel];
        
        moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(129, 36, moneyLabel.frame.size.width, 14)];
        moneyLabel.text=@"费用:";
        moneyLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        moneyLabel.font=[UIFont fontWithName:@"Arial" size:13];
        [layoutView addSubview:moneyLabel];
        
        _costLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.size.width+moneyLabel.frame.origin.x, 36, WIDTH-148-moneyLabel.frame.size.width, 14)];
        _costLabel.font=[UIFont fontWithName:@"Arial" size:13];
        _costLabel.text=@"以支付200元团购";
        _costLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        [layoutView addSubview:_costLabel];
        
        address=[[UILabel alloc]init];
        address.text=@"地址:";
        address.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        address.font=[UIFont fontWithName:@"Arial" size:13];
        address.frame=CGRectMake(129, 59, address.frame.size.width, 14);
        [layoutView addSubview:address];
        
        _addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(address.frame.size.width+address.frame.origin.x, 59, WIDTH-148-address.frame.size.width, 14)];
        //[_addressLabel setNumberOfLines:0];
        _addressLabel.text=@"案发啊会计法解放军卡规范啊发放噶咖啡馆哈军工分";
        _addressLabel.font=[UIFont fontWithName:@"Arial" size:13];
        _addressLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        //_addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _addressLabel.numberOfLines = 2;
        CGSize size = [_addressLabel sizeThatFits:CGSizeMake(_addressLabel.frame.size.width, MAXFLOAT)];
        _addressLabel.frame =CGRectMake(160, 59, WIDTH-178, size.height);
        [layoutView addSubview:_addressLabel];
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(18, 21+_descriptionView.frame.origin.y+_descriptionView.frame.size.height, WIDTH-36, 14)];
        _contentLabel.text=@"哈高发发觉国际考古界啊航空股份回家啊风格咖啡感觉啊个风格啊可是鼓风机哈根噶款设计风格啊就算分开";
        _contentLabel.font=[UIFont fontWithName:@"Arial" size:13];
        _contentLabel.textColor=[UIColor colorWithRed:138/255.0f green:137/255.0f blue:137/255.0f alpha:1];
        _contentLabel.numberOfLines=2;
        CGSize siZe=[_contentLabel sizeThatFits:CGSizeMake(_contentLabel.frame.size.width, MAXFLOAT)];
        _contentLabel.frame=CGRectMake(18, 21+_descriptionView.frame.origin.y+_descriptionView.frame.size.height, WIDTH-36, siZe.height);
        [layoutView addSubview:_contentLabel];
        
        UIImageView *lineimageView=[[UIImageView alloc]initWithFrame:CGRectMake(18, 20+_contentLabel.frame.origin.y+_contentLabel.frame.size.height, WIDTH-26, 1)];
        lineimageView.backgroundColor=[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
        [layoutView addSubview:lineimageView];
        NSArray *array=@[@"common_icon_like_c@2x",@"common_icon_review@2x",@"common_icon_share@2x"];
        NSArray *arratText=@[@"100",@"50",@"20"];
        for (int i=0; i<array.count; i++) {
            if (i==2) {
                _fxButton=[[UIButton alloc]initWithFrame:CGRectMake(34+WIDTH/3*i, lineimageView.frame.origin.y+15, 22, 22)];
                [_fxButton setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
                [_fxButton setTag:(1000+i)];
                [layoutView addSubview:_fxButton];
                
                //button.frame=CGRectMake(34+WIDTH/3*i, lineimageView.frame.origin.y+15, 22, 22);
            }
            if (i==0) {
                _zaButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*i, lineimageView.frame.origin.y+15, 22, 22)];
                [_zaButton setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
                [_zaButton setTag:(1000+i)];
                [layoutView addSubview:_zaButton];
                
                _praiseLabel=[[UILabel alloc]initWithFrame:CGRectMake(_zaButton.frame.origin.x+_zaButton.frame.size.width, lineimageView.frame.origin.y+15, (WIDTH-42-66)/3, 22)];
                //label.backgroundColor=[UIColor brownColor];
                _praiseLabel.text=arratText[i];
                _praiseLabel.textAlignment=NSTextAlignmentLeft;
                _praiseLabel.lineBreakMode=NSLineBreakByTruncatingTail;
                [_praiseLabel setNumberOfLines:1];
                [_praiseLabel sizeToFit];
                [layoutView addSubview:_praiseLabel];

            }else if(i==1)
            {
                _plButton=[[UIButton alloc]initWithFrame:CGRectMake(42+WIDTH/3*i, lineimageView.frame.origin.y+15, 22, 22)];
                [_plButton setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
                [_plButton setTag:(1000+i)];
                [layoutView addSubview:_plButton];
                
                _commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(_plButton.frame.origin.x+_plButton.frame.size.width, lineimageView.frame.origin.y+15, (WIDTH-42-66)/3, 22)];
                //label.backgroundColor=[UIColor brownColor];
                _commentLabel.textAlignment=NSTextAlignmentLeft;
                _commentLabel.text=arratText[i];
                _commentLabel.lineBreakMode=NSLineBreakByTruncatingTail;
                [_commentLabel setNumberOfLines:1];
                [_commentLabel sizeToFit];
                [layoutView addSubview:_commentLabel];
            }
            
        }
        
        layoutView.frame=CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, WIDTH, lineimageView.frame.origin.y+lineimageView.frame.size.height+50);
        
        _view.frame=CGRectMake(0, 0, WIDTH, layoutView.frame.origin.y+layoutView.frame.size.height);
    }
    return self;
}
-(void)buttonan:(UIButton *)tag
{
    NSLog(@"点击");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
