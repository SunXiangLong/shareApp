//
//  MMGoodsTableViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/23.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyJSON
class MMGoodsModel {
    
    var goods_number: String!;
    var weidian_goods_price: String!
    var goods_sale_status: String!
    var weidian_goods_profit: String!
    var goods_thumb: URL!
    var share_url: URL!
    var preview_url: URL!
    var goods_name: String!
    var goods_id: String!
    var buy_url:URL?
    init(json:JSON){
        goods_id = json["goods_id"].string
        goods_number = json["goods_number"].string
        weidian_goods_price = json["weidian_goods_price"].string
        goods_sale_status = json["goods_sale_status"].string
        weidian_goods_profit = json["weidian_goods_profit"].string
        goods_thumb = json["goods_thumb"].URL
        share_url = json["share_url"].URL
        preview_url = json["preview_url"].URL
        goods_name = json["goods_name"].string
        buy_url = json["buy_url"].URL
    }

}
class MMBrandModel :AnyObject {
    var banner: URL?
    var title: String?
    var share_url: URL?
    var share_vip_url: URL?
    var topic_id:String?
    var share_desc:String?
    var url:URL?
    
    
    var type:String?
    init(json:JSON){
        
        banner = json["banner"].URL
        share_url = json["share_url"].URL
        share_vip_url = json["share_vip_url"].URL
        url = json["url"].URL
       
        title = json["title"].string
        share_desc = json["share_desc"].string
        topic_id = json["topic_id"].string
        type = json["type"].string


        
    }
    
}
class MMGoodsTableViewTwoCell: MMBaseTableViewCell {
    @IBOutlet weak var brandImageView: UIImageView!
    var brandModel:MMBrandModel?{
        
        didSet{
            brandImageView.setImage(brandModel!.banner, type: .two)
            
            
        }
    }
    
    
    
}
///定义闭包类型特定的函数类型
typealias buttonClickType = (MMGoodsModel,IndexPath,buttonClickEventType) -> Void
class MMGoodsTableViewCell: MMBaseTableViewCell {
    
    
    @IBOutlet weak var goodsThumbImageView: UIImageView!
    @IBOutlet weak var goodsNumberLabel: UILabel!
    @IBOutlet weak var weidianGoodsProfitLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var weidianGoodsPricelabel: UILabel!
    
    @IBOutlet weak var shelvesButton: UIButton!
    
    var buttonEventType:buttonClickType?
    var indexPath:IndexPath?
    
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageheightConstraint: NSLayoutConstraint!
    var goodsModel:MMGoodsModel?{
        didSet{
            goodsThumbImageView.setImage(goodsModel?.goods_thumb, type: .one)
            goodsNumberLabel.text = "库存：" + (goodsModel?.goods_number)!
            goodsNameLabel.text = goodsModel?.goods_name
            weidianGoodsPricelabel.text  = goodsModel?.weidian_goods_price
            weidianGoodsProfitLabel.text = goodsModel?.weidian_goods_profit
            if goodsModel?.goods_sale_status == "1" {
                shelvesButton.isSelected = true
            }else{
                shelvesButton.isSelected = false
            }
            
        }
    
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        imageWidthConstraint.constant = 0.5
        imageheightConstraint.constant = 0.5
    }
    
    
    @IBAction func share(_ sender: UIButton) {
        
        if goodsModel != nil {
            self.buttonEventType!(goodsModel!,indexPath!,.share)
        }
    }
    @IBAction func shelves(_ sender: UIButton) {
        if goodsModel != nil {
            self.buttonEventType!(goodsModel!,indexPath!,.shelves)
        }
    }
}
