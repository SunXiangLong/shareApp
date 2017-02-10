//
//  MMWithdrawalRecordTableViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/27.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyJSON


class profitWithdrawRecord {
    var status:NSNumber?
    //总提现金额
    var total:String?
    var data:[withdrawalRecordModel] = []
    init(json:JSON){
        status = json["json"].number
        total = json["total"].string
        for dic in json["data"].array! {
            let model = withdrawalRecordModel.init(json: dic)
            data.append(model)
        }
    
    }
    
    
    
}
class withdrawalRecordModel {
    var apply_time:String?
    var apply_money:String?
    var withdraw_status_code:String?
    var withdraw_status_desc:String?
    init(json:JSON){
        apply_time = json["apply_time"].string
        apply_money = json["apply_money"].string
        withdraw_status_code = json["withdraw_status_code"].string
        withdraw_status_desc = json["withdraw_status_desc"].string
    }
    
}
class MMWithdrawalRecordTableViewCellOne: MMBaseTableViewCell {
    @IBOutlet weak var totallabel: UILabel!
    
    var model:profitWithdrawRecord?{
        didSet{
        totallabel.text = "总提现金额：" + (model?.total)!   
        
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
class MMWithdrawalRecordTableViewCellTwo: MMBaseTableViewCell {
    @IBOutlet weak var applyTimelabel: UILabel!
    @IBOutlet weak var applyMoneyLabel: UILabel!
    
    @IBOutlet weak var withdrawStatusDescLabel: UILabel!
    var model:withdrawalRecordModel?{
        didSet{
            applyTimelabel.text = model?.apply_time
            applyMoneyLabel.text = model?.apply_money
            withdrawStatusDescLabel.text = model?.withdraw_status_desc
            if withdrawStatusDescLabel.text == "未结算" {
                withdrawStatusDescLabel.textColor = "ee5b61".color
            }
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
