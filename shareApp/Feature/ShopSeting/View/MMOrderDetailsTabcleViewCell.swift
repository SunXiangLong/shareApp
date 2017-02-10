//
//  MMOrderDetailsTabcleViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailsModel {
    var consignee: String!
    var pay_time: String!
    var order_sn: String!
    var goods_amount: String!
    var mobile: String!
    var shipping_status: String!
    var invoice_no: String!
    var address: String!
    var shipping_url: URL!
    var shipping_way: String!
    var order_goods:[myChlidOrderModel]? = []
    var order_amount: String!
    var shipping_fee: String!
    var add_time: String!
    init(json:JSON){
        consignee = json["consignee"].string
        pay_time = json["pay_time"].string
        order_sn = json["order_sn"].string
        goods_amount = json["goods_amount"].string
        mobile = json["mobile"].string
        shipping_status = json["shipping_status"].string
        shipping_url = json["shipping_url"].URL
        shipping_way = json["shipping_way"].string
        order_amount = json["order_amount"].string
        shipping_fee = json["shipping_fee"].string
        add_time = json["add_time"].string
        address =  json["address"].string
        for model in json["order_goods"].array! {
            let childModel = myChlidOrderModel.init(json: model)
            order_goods?.append(childModel)
           
            
        }
    }

}
class MMOrderDetailsTableViewOneCell: MMBaseTableViewCell {
    
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var mobilelabel: UILabel!
    @IBOutlet weak var consigneeLabel: UILabel!
    
    var model:OrderDetailsModel?{
        didSet{
            adressLabel.text = model?.address
            mobilelabel.text = model?.mobile
            consigneeLabel.text = model?.consignee
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}

class MMOrderDetailsTableViewTwoCell: MMBaseTableViewCell {
    
    @IBOutlet weak var orderSn: UILabel!
    @IBOutlet weak var addTimeLabel: UILabel!
    @IBOutlet weak var payTimelabel: UILabel!
    @IBOutlet weak var goodeSAmount: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var shippingFee: UILabel!
    var model:OrderDetailsModel?{
        didSet{
            orderSn.text = model?.order_sn
            addTimeLabel.text = model?.add_time
            payTimelabel.text = model?.pay_time
            goodeSAmount.text = model?.goods_amount
            orderAmountLabel.text = model?.order_amount
            shippingFee.text = model?.shipping_fee
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
typealias check = (OrderDetailsModel)-> Void
class MMOrderDetailsTableViewThreeCell: MMBaseTableViewCell {
    
    @IBOutlet weak var wayLabel: UILabel!
    @IBOutlet weak var orderOn: UILabel!
    
    var checkLogistic:check?
    
    @IBAction func checkLogistics(_ sender: AnyObject) {
        self.checkLogistic!(model!)
    }
    
    var model:OrderDetailsModel?{
        didSet{
           wayLabel.text = model?.shipping_way
          orderOn.text = model?.order_sn

        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
