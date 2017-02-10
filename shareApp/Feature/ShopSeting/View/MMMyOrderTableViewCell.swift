//
//  MMMyOrderTableViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyJSON
class myOrderModel{
    var add_time: String!
    var order_sn: String!
    var order_status: String!
    var order_goods:[myChlidOrderModel]! = []
    init(json:JSON){
     add_time = json["add_time"].string
     order_sn = json["order_sn"].string
     order_status = json["order_status"].string
        for model in json["order_goods"].array! {
            let childModel = myChlidOrderModel.init(json: model)
            order_goods.append(childModel)
            
        }
    }
}
class myChlidOrderModel{
    var goods_thumb: URL?
    var goods_id: String?
    var goods_number: String?
    var goods_price: String?
    var goods_name: String?
    init(json:JSON){
        goods_thumb = json["goods_thumb"].URL
        goods_id = json["goods_id"].string
        goods_number = json["goods_number"].string
        goods_price = json["goods_price"].string
        goods_name = json["goods_name"].string
        
     
    }
    
}
class MMMyOrderTableViewCell: MMBaseTableViewCell {

    @IBOutlet weak var goodsThumbImageView: UIImageView!
    @IBOutlet weak var goodsLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    var model:myChlidOrderModel?{
        didSet{
            goodsThumbImageView.setImage(model?.goods_thumb, type: .one)
            
            goodsNameLabel.text = model?.goods_name
            goodsLabel.text = (model?.goods_price)! + "x" + (model?.goods_number)!
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
