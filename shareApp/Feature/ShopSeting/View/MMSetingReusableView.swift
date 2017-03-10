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
                
                shopNameLabel.text = MMUserInfo.UserInfo.shopShareModel?.shopName
                shopAvatarImageView.setImage(MMUserInfo.UserInfo.shopShareModel?.shopAvatar, image: #imageLiteral(resourceName: "mm_defaultAvatar"))
                shopBackgroundImageView.setImage(MMUserInfo.UserInfo.shopShareModel?.shopBackground, image: #imageLiteral(resourceName: "backgroupImage"))
                
            }else{
                profitTotallabel.text = "0.00"
                dayWaitProfitLabel.text = "0.00"
                dayOrdersCntLabel.text = "0"
                visitTotalLabel.text = "0"
                shopNameLabel.text = "请登录，当前状态未登录！"
                shopAvatarImageView.image = #imageLiteral(resourceName: "mm_defaultAvatar")
                shopBackgroundImageView.image = #imageLiteral(resourceName: "backgroupImage")
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        
        self.lingConstraint.constant = 0.5
        self.height.constant = screenW*70/124
        
        
        
    }
}
