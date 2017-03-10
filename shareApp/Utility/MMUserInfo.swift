//
//  MMUserInfo.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
class  MMUserInfo {
    /// 店铺id
    var shop_id:String?
    ///  分享的code
    var shop_share_code:String?
    /// 用户id
    var user_id:String?
    /// 店主登录name(暂时为手机号)
    var username:String?
    /// 店家名字
    var shop_name:String?
    /// 店家头像url
    var shop_avatar:URL?
    /// 店家背景图片url
    var shop_background:URL?
    /// 默认选择的分享店铺
    var shopShareModel:ShopShareInfo?
    /// 店家描述
    var shop_description:String?
    /// 用户token 标示用户唯一状态的
    var token:String?
    /// VIP商店分享的url
    var shop_share_vip_url: URL!
    /// 邀请好友的url
    var shop_invite_url: URL!
    /// 预览店铺界面的Url
    var shop_preview_url: URL!
    /// 商店分享的url
    var shop_share_url: URL!
    /// vip商店分享的二维码图片url
    var shop_share_vip_qr: URL!
    /// 一键分享的URL
    var shop_share_normal_url : URL!
    /// 邀请好友的二维码图片url
    var shop_invite_qr: URL!
     /// 商店分享的二维码图片url
    var shop_share_qr: URL!
    /// 我的购物车url
    var cart_url: URL!
    /// 个人中心url
    var ucenter_url: URL!
    /// 是否绑定银行卡
    var card_bind_status:Bool!
    /// 卡号
    var card_no:String!
    /// 开户人name
    var real_name:String!
    ///开户行支行
    var branch_bank:String!
    /// 开户行
    var deposit_bank:String!
    /// 可提现余额
    var available_balance: String!
    /// 用户购买的开店码（购买成功存在，否则为nil）
    var code:String!
   

    
    /// 店铺对象数组
    var shareInfo:[ShopShareInfo] = []
    /// 创建一个请求的单例
    static let UserInfo = MMUserInfo()
    /// 创建一个私有的初始化方法覆盖公共的初始化方法。
    fileprivate  init() {}
    
     func initUserInfo(_ model:MMBaseModel?) -> Void {
//        log(model?.data)
        self.shop_id = model?.data!["shop_id"].string;
        self.shop_share_code = model?.data!["shop_share_code"].string
        self.user_id = model?.data!["user_id"].string
        self.username =  model?.data!["username"].string
        self.shop_name =  model?.data!["shop_name"].string
        self.shop_avatar   =  model?.data!["shop_avatar"].URL
        self.shop_background =  model?.data!["shop_background"].URL
        self.shop_description =  model?.data!["shop_description"].string
        self.token =  model?.data!["token"].string
        
        self.shop_share_normal_url = model?.data!["shop_share_normal_url"].URL
        self.shop_invite_url = model?.data!["shop_invite_url"].URL
        self.shop_share_vip_url = model?.data!["shop_share_vip_url"].URL
        self.shop_share_url = model?.data!["shop_share_url"].URL
        self.shop_preview_url = model?.data!["shop_preview_url"].URL
        self.shop_invite_qr = model?.data!["shop_invite_qr"].URL
        ucenter_url = model?.data!["ucenter_url"].URL
        cart_url = model?.data!["cart_url"].URL
        card_bind_status = model?.data!["card_bind_status"].number == (1) ? true : false
        card_no = model?.data!["card_no"].string
        real_name = model?.data!["real_name"].string
        branch_bank = model?.data!["branch_bank"].string
        deposit_bank = model?.data!["deposit_bank"].string
        
        
        if model?.data!["shop_share_info"] != nil {
            
            for model in model!.data!["shop_share_info"].array! {
                let shopShareInfoModel = ShopShareInfo.init(json: model)
                shareInfo.append(shopShareInfoModel)
                
                if model["is_default"] == "1" {
                    shopShareModel = shopShareInfoModel
                }
            }
        }

       ///保存用户信息到本地
        UserDefaults.standard.set(model?.data?.dictionaryObject, forKey: "userinfo")
        
        UserDefaults.standard.synchronize()
    }
    
     func clearUserInfo() -> Void {
        
        shop_id = nil
        shop_share_code = nil
        user_id  = nil
        username = nil
        shop_name = nil
        shop_avatar = nil
        shop_background = nil
        shop_description = nil
        token = nil
        shop_share_vip_url = nil
        shop_share_url = nil
        shop_invite_url = nil
        shop_share_qr = nil
        shop_invite_qr = nil
        shop_share_vip_qr = nil
        shop_share_normal_url = nil
        shop_preview_url = nil
        cart_url = nil
        ucenter_url = nil
        card_bind_status = nil
        card_no = nil
        real_name = nil
        branch_bank = nil
        deposit_bank = nil
        
        shopShareModel = nil
        shareInfo = []
        available_balance = nil
        code = nil
        
        
    }
    
    
}
