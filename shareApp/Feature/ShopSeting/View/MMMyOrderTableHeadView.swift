//
//  MMMyOrderTableHeadView.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMMyOrderTableHeadView: UIView {

    @IBOutlet weak var timelabel: UILabel!
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    var model:myOrderModel?{
        didSet{
            timelabel.text = model?.add_time
            orderStatusLabel.text = model?.order_status
        
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
