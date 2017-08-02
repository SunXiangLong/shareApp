//
//  API.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/19.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
public struct API {


    /// 线上地址
 fileprivate    static let URL = "https://vapi.xiaomabao.com/"
     /// 测试地址
// fileprivate static let URL = "http://192.168.10.230"

/******************************用户搜索商品**************************************/
    //判断是否需要更新推荐搜索关键字
    static let download = API.URL+"download/check_searchlib_version"
    //获取更新推荐搜索关键字
    static let downloadSearchlib = API.URL+"download/searchlib"
    //获取热门推荐
    static let searchIndex = API.URL+"search/index"
    //搜索接口
    static let searchGoods = API.URL+"search/goods"
    
/******************************用户注册登录部分**************************************/
    //MARK: 用户注册登录部分
   /// 用户登录(注册手机（用户名）＋密码)
    static let login = API.URL+"user/login"
    /// 用户登录(注册手机号＋短信验证码)
    static let loginCode = API.URL+"user/login_by_code"
    /// 用户注册(开店注册)
    static let register = API.URL+"user/register"
    /// 获取短信验证码（用于注册）
    static let sendCode = API.URL+"user/send_code"
    /// 用户注册(开店注册-不需要开店码)
    static let newRegister = API.URL+"/user/register_without_shopcode"
    /// 获取短信验证码（用于登录和找回密码）
    static let sendLoginCode = API.URL+"user/send_login_code"
    /// 检查验证码是否匹配）
    static let validCode = API.URL+"user/valid_code"
    /// 重置密码
    static let resetPassword = API.URL+"user/reset_password"
    /// 刷新token请求时间
    static let refreshToken = API.URL+"user/refresh_token"
    /// 获取开店码
    static let getShopCode = API.URL+"user/get_shop_code"
    /// 申请开店码
    static let applyShopCode = API.URL+"user/apply_shop_code"
/******************************用户店铺设置**************************************/
    //MARK: 用户店铺
    /// 获取店铺基本信息
    static let shopBaseInfo = API.URL+"shop/base_info"
    /// 获取店铺统计信息
    static let statisticInfo = API.URL+"shop/statistics_info"
    ///删除店铺分享信息
    static let shopDeleteShare = API.URL+"shop/delete_share"
    /// 修改店铺分享信息
    static let shopUpdateShare = API.URL+"shop/update_share"
    /// 添加店铺分享信息
    static let shopAddShare = API.URL+"/shop/add_share"
    /// 设置店铺为默认分享店铺
    static let shopSetDefault = API.URL+"/shop/set_default"
    /// 修改店铺头像
//    static let shopUpdateAvatar = API.URL+"shop/update_avatar"
    /// 修改店铺背景
//    static let shopUpdateBackground = API.URL+"shop/update_background"
    /// 是否通过审核
//     static let commonJudge = API.URL+"common/judge"

/******************************商品相关**************************************/
     //MARK: 商品相关
    ///商品类目（v1）--（v2）
    static let goodsCategoryList = API.URL+"goods/category_list"
//    static let goodsCategoryList2 = API.URL+"goods/category_list_v2"
    ///商品分类
    static let goodsGoodsList = API.URL+"goods/goods_list"
    static let goodsGoodsList_2 = API.URL+"goods/goods_list2"
    
    static let goodsGoodsList2 = API.URL+"goods/goods_list_v2"
    static let goodsGoodsList2_2 = API.URL+"goods/goods_list_vv2"
    ///商品列表(VIP)
    static let goodsVipGoodsList = API.URL+"goods/vip_goods_list"
      static let goodsVipGoodsList_2 = API.URL+"goods/vip_goods_list2"
    ///商品列表（我的店铺）
    static let goodsShopGoods = API.URL+"goods/shop_goods"
    ///商品上架
    static let goodsOnSale = API.URL+"goods/on_sale"
    /// brand列表
//    static let brandBrandList = API.URL+"brand/brand_list"
    static let brandBrandList2 = API.URL+"brand/brand_list_v2"
    /// brand下的商品列表
    static let brandGoodList = API.URL+"brand/goods_list"
    
    ///商品下架
    static let goodsOffSale = API.URL+"goods/off_sale"
/******************************收益相关**************************************/
     //MARK: 收益相关
    ///我的收益
    static let shopProfitInfo = API.URL+"shop/profit_info"
    ///绑定银行卡
    static let profitBind_card = API.URL+"profit/bind_card"
    static let profitBind_card_update = API.URL+"profit/bind_card_update"
  
    ///申请提现
    static let profitApplyWithdraw = API.URL+"profit/apply_withdraw"
    ///提现记录
    static let profitWithdrawRecord = API.URL+"profit/withdraw_record"
/******************************订单分类**************************************/
    //MARK: 订单分类
    ///订单分类
    static let orderOrderType = API.URL+"order/order_type"
    ///店铺订单
    static let orderOrderList = API.URL+"order/order_list"
    ///订单详情
    static let orderDetail = API.URL+"order/order_detail"
/******************************提示更新**************************************/
    static let commonUpdate = API.URL+"common/update"
/******************************我的麻豆**************************************/
    //获取麻包豆使用详情
    static let beanInfo = API.URL+"bean/info"
    //赠送麻包豆
    static let beanSend = API.URL+"bean/send"
   
    //麻包使用协议
    static let commonBean = API.URL+"common/bean_agreement"
    
    
     static let cartUrl = "http://weidian.xiaomabao.com/"+"cart/"

   
}

public struct Key {

    /// 友盟appKey
    static let umengAppKey = "57a03c9667e58eb9d00013e9"
    /// 应用的appid
    static let ShareAppAppId = "1135323453"
    /// 极光推送appKey
    static let jiguangAppKey = "65fa4f894a2286e476d29326"
    /// 极光推送 Master Secret
    static let Secret = "4ea8ea96bf1e24670c449e57"
    ///  渠道
    static let Channel = "App Store"
    /// 版本号
    static let Version =  Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    /// 开店大礼包图片
    static let imageUrl = "http://weidian.xiaomabao.com/static/images/kaidianm.png?v="
    
    /// 商品支付成功跳转网页
    static let payGoods = "http://weidian.xiaomabao.com/flow/pay_success/"
   
    /// 二维码图片地址 +token+share_id+type (type 0表示普通 1表示vip 2表示邀请码)
    static let shopQrCode = "http://vapi.xiaomabao.com/common/show_qrcode/"
}
