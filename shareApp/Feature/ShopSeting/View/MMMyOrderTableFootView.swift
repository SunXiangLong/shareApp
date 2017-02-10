//
//  MMMyOrderTableFootView.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable

class MMMyOrderTableFootView: AnimatableView {

    var model:myOrderModel?
    var   detailsJump:((myOrderModel)-> Void)?
    override func awakeFromNib() {
        
    }
    @IBAction func detailsButton(_ sender: AnyObject) {
        self.detailsJump!(model!)
        
        
    }
}
