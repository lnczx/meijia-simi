//
//  Header.h
//  simi
//
//  Created by 赵中杰 on 14/11/25.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#ifndef simi_Header_h
#define simi_Header_h


#import "SIMPLEBaseClass.h"
#import "PartnerConfig.h"


// 屏幕宽度
#define _WIDTH                             self.view.frame.size.width

// 屏幕高度
#define _HEIGHT                            self.view.frame.size.height

#define _CELL_WIDTH                        self.frame.size.width

//  字体
#define MYFONT(a)                          [UIFont systemFontOfSize:a]

//  粗体
#define MYBOLD(a)                          [UIFont boldSystemFontOfSize:a]

//  图片名字
#define IMAGE_NAMED(a)                     [UIImage imageNamed:a]


#define PRINTLOG //注释不打印 NSLog
#ifdef  PRINTLOG

#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#define CHOICE_BACK_VIEW_COLOR 0xDADADA


////////////////*************************************//////////////////
////////////////*************接口相关*****************//////////////////

#define SERVER_DRESS                     @"http://123.57.173.36/"                        //服务器地址
#define GET_YANZHENGMA                   @"simi/app/user/get_sms_token.json"              //获取验证码
#define LOGIN_API                        @"simi/app/user/login.json"                      //登录接口
#define Third_LOG                        @"simi/app/user/login-3rd.json"                  //第三方登陆
#define USER_INFO                        @"simi/app/user/get_userinfo.json"               //用户信息接口
#define USERINFO_EDIT                    @"simi/app/user/post_userinfo.json"              //用户信息修改

#define ORDER_LIST                       @"simi/app/order/get_list.json"                  //订单列表
#define ORDER_DETAIL                     @"simi/app/order/get_detail.json"                //订单详情
#define CANCEL_ORDER                     @"simi/app/order/post_order_cancel.json"         //取消订单
#define DISCUSS_ORDER                    @"simi/app/order/post_rate.json"                 //订单评价
#define ORDER_SURE                       @"simi/app/order/post_confirm.json"              //订单确认

#define BASE_API                         @"simi/app/dict/get_base_datas.json"             //首页基础数据
#define MY_JIFEN_MINGXI                  @"simi/app/user/get_score.json"                  //我的积分明细
#define DELETE_ADDRESS                   @"simi/app/user/post_del_addrs.json"             //地址删除接口
#define ADDRESS_ADDCHANGE                @"simi/app/user/post_addrs.json"                 //地址添加修改
                                         
#define MY_DRESSLIST                     @"simi/app/user/get_addrs.json"                  //常用地址
#define USERINFO_API                     @"simi/app/user/get_userinfo.json"               //账号信息
#define ORDER_PAY                        @"simi/app/order/post_pay.json"                  //订单支付
#define ORDER_TIJIAO                     @"simi/app/order/post_add.json"                  //提交订单
#define MY_DRESSLIST                     @"simi/app/user/get_addrs.json"                  //常用地址
#define JIFEN_MINGXI                     @"simi/app/user/get_score.json"                  //积分明晰
#define MY_DRESSLIST                     @"simi/app/user/get_addrs.json"                  //常用地址
#define JIFEN_MINGXI                     @"simi/app/user/get_score.json"                  //积分明晰
#define JIFEN_DUIHUAN                    @"simi/app/user/post_score_exchange.json"        //积分兑换

#define YIJIAN_FANKUI                    @"simi/app/user/post_feedback.json"             //意见反馈
#define REMIND_SAVE                      @"simi/app/user/post_user_remind.json"          //提醒记录保存
#define REMIND_LIST                      @"simi/app/user/get_user_remind.json"           //提醒记录列表
#define REMIND_DELETE                    @"simi/app/user/post_user_remind_del.json"      //提醒删除
#define MINEYOUHUIJUAN                   @"simi/app/user/get_coupons.json"               //我的优惠卷
#define YOUHUIJUAN_DUIHUAN               @"simi/app/user/post_coupon.json"               //优惠卷兑换
#define simi_GOUMAI                      @"simi/app/user/senior_buy.json"                //管家卡购买
#define VIP_CHONGZHI                     @"simi/app/user/card_buy.json"                  //会员充值
#define BUY_simiCARD                     @"simi/app/user/senior_buy.json"                //购买管家卡
#define VIP_LIST                         @"simi/app/dict/get_cards.json"                 //充值列表
#define VIPCHONGZHI_NOTYURL              @"simi/pay/notify_alipay_ordercard.jsp"         //会员充值notyurl
#define simi_NOTYURL                     @"simi/pay/notify_alipay_ordersenior.jsp"       //管家卡回调notyurl
#define ORDEL_NOTYURL                    @"simi/pay/notify_alipay_order.jsp"             //订单支付回调notyurl
#define ORDER_CANCLE                     @"simi/app/order/pre_order_cancel.json"         //订单预取消
#define baidu_bangding                   @"simi/app/user/post_baidu_bind.json"           //百度推送绑定
#define WXPAY_URL                        @"simi/app/order/wx_pre.json"                   //微信预支付接口
#define WXPAY_SUCCESS                    @"simi/app/order/wx_order_query.json"           //查询微信支付是否成功
#define UNREADMESSAGES                   @"simi/app/user/get_new_msg.json"               //查看有没有未读消息
#define CREATE_CARD                      @"simi/app/card/post_card.json"                 //创建卡片接口
#define CARD_LIST                        @"simi/app/card/get_list.json"                  //卡片列表接口
#define CITY_JK                          @"simi/app/city/get_list.json"                  //城市数据接口
#define CARD_DETAILS                     @"simi/app/card/get_detail.json"                //卡片详情接口
#define CARD_PL                          @"simi/app/card/post_comment.json"              //卡片评论接口
#define CARD_PLLB                        @"simi/app/card/get_comment_list.json"          //卡片评论列表接口
#define CARD_DZ                          @"simi/app/card/post_zan.json"                  //卡片点赞接口
#define USER_HYXX                        @"simi/app/user/get_im_last.json"               //好友消息列表接口
#define USER_HYLB                        @"simi/app/user/get_friends.json"               //好友列表接口
#define USER_TJHY                        @"simi/app/user/post_friend.json"               //添加好友接口
#define USER_GRZY                        @"simi/app/user/get_user_index.json"            //用户个人主页接口
#endif