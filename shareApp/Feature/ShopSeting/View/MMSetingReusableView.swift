//
//  MMSetingReusableView.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/20.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

import SwiftyJSON
class shopStatisticInfo {
    ///总订单
    var orders_total: String!
    //总访问
    var visit_total: String!
    ///今天收益
    var day_wait_profit: String!
    ///总收益
    var profit_total: String!
    ///今日订单
    var day_orders_cnt: String!
    init(json:JSON)  {
        orders_total = json["orders_total"].string
        visit_total = json["visit_total"].string
        day_wait_profit = json["day_wait_profit"].string
        profit_total = json["profit_total"].string
        day_orders_cnt = json["day_orders_cnt"].string
    }
    
}
struct ShopShareInfo{
    
    var id : String!
    var isDefault : String!
    var shopAvatar : URL!
    var shopBackground : URL!
    var shopDescription : String!
    var shopName : String!
    
    
    init(json:JSON){
        id = json["id"].string
        isDefault = json["is_default"].string
        shopAvatar = json["shop_avatar"].URL
        shopBackground = json["shop_background"].URL
        shopDescription = json["shop_description"].string
        shopName = json["shop_name"].string
    }
    
    
    
}
class shopInfo{
    ///店铺说明
    var shop_description: String!
    ///店铺名称
    var shop_name: String!
    ///店铺头像
    var shop_avatar: URL!
    ///店铺编码
    var shop_share_code: String!
    ///店铺top背景图片
    var shop_background: URL!
    /// 是否绑定银行卡
    var card_bind_status:Bool!
    /// 卡号
    var card_no:String!
    /// 开户人name
    var real_name:String!
    ///开户行支行
    var branch_bank:String!
    /// 开户行
    var deposit_bank :String!
    
    var shareInfo:[ShopShareInfo] = []
    
    
    init(json:JSON)  {
        shop_description = json["shop_description"].string
        shop_name = json["shop_name"].string
        shop_avatar = json["shop_avatar"].URL
        shop_share_code = json["shop_share_code"].string
        shop_background = json["shop_background"].URL
        
        card_bind_status = json["card_bind_status"].number == (1) ? true : false
        card_no = json["card_no"].string
        real_name = json["real_name"].string
        branch_bank = json["branch_bank"].string
        deposit_bank = json["deposit_bank"].string
        
        
        //        MMUserInfo.UserInfo.shop_avatar = shop_avatar
        //        MMUserInfo.UserInfo.shop_background = shop_background
        //        MMUserInfo.UserInfo.shop_name = shop_name
        //        MMUserInfo.UserInfo.shop_description = shop_description
        MMUserInfo.UserInfo.card_bind_status = card_bind_status
        MMUserInfo.UserInfo.card_no = card_no
        MMUserInfo.UserInfo.real_name = real_name
        MMUserInfo.UserInfo.branch_bank = branch_bank
        MMUserInfo.UserInfo.deposit_bank = deposit_bank
        
        if json["shop_share_info"] != nil {
            
            for model in json["shop_share_info"].array! {
                let shopShareInfoModel = ShopShareInfo.init(json: model)
                shareInfo.append(shopShareInfoModel)
                
                if model["is_default"] == "1" {
                    MMUserInfo.UserInfo.shopShareModel = shopShareInfoModel
                }
            }
        }
        MMUserInfo.UserInfo.shareInfo = shareInfo
    }
    
}


class MMSetingReusableView: UICollectionReusableView {
    @IBOutlet weak var shopAvatarImageView: AnimatableImageView!
    @IBOutlet weak var shopBackgroundImageView: AnimatableImageView!
    @IBOutlet weak var shopNameLabel: AnimatableLabel!
    @IBOutlet weak var profitTotallabel: CountingLabel!
    @IBOutlet weak var lingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayWaitProfitLabel: CountingLabel!
    @IBOutlet weak var dayOrdersCntLabel: CountingLabel!
    @IBOutlet weak var visitTotalLabel: CountingLabel!
    
    @IBOutlet weak var shopAvatarBackGroundImageView: UIImageView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    var statisticShopInfo:shopStatisticInfo!{
        didSet{
            if statisticShopInfo != nil {
                
                
                profitTotallabel.text = "0.00"
                profitTotallabel.format = "%.2f"
                profitTotallabel.countFrom(fromNum: 0.00, toNum: NSNumber.init(value: Double.init(statisticShopInfo.profit_total)! as Double), duration: 0.8)
                
                dayWaitProfitLabel.text = "0.00"
                dayWaitProfitLabel.format = "%.2f"
                dayWaitProfitLabel.countFrom(fromNum: 0.00, toNum: NSNumber.init(value: Double.init(statisticShopInfo.day_wait_profit)! as Double), duration: 0.8)
                
                
                dayOrdersCntLabel.text = "0"
                dayOrdersCntLabel.format = "%.0f"
                dayOrdersCntLabel.countFrom(fromNum: 0.00, toNum: NSNumber.init(value: NSInteger.init(statisticShopInfo.day_orders_cnt)! as Int), duration: 0.8)
                
                visitTotalLabel.text = "0"
                visitTotalLabel.format = "%.0f"
                visitTotalLabel.countFrom(fromNum: 0.00, toNum: NSNumber.init(value: NSInteger.init(statisticShopInfo.visit_total)! as Int), duration: 0.8)
                
            }
            
        }
    }
    var shopinfo:shopInfo!{
        didSet{
            
            if shopinfo != nil {
                shopNameLabel.text = MMUserInfo.UserInfo.shopShareModel?.shopName
                shopAvatarImageView.setImage(MMUserInfo.UserInfo.shopShareModel?.shopAvatar, image: #imageLiteral(resourceName: "mm_defaultAvatar"))
               shopBackgroundImageView.setImage(MMUserInfo.UserInfo.shopShareModel?.shopBackground, image: #imageLiteral(resourceName: "backgroupImage"))
                
            }
            
            
        }
    }
    override func awakeFromNib() {
        
        self.lingConstraint.constant = 0.5
        self.height.constant = screenW*70/124
        
        
        
    }
}
