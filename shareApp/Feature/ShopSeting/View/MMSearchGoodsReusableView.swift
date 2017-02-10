//
//  MMSearchGoodsReusableView.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/8.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMSearchGoodsReusableView: UICollectionReusableView {
    
    var deleteAll:(()-> Void)?
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var title: UILabel!
    
    @IBAction func deleteall(_ sender: AnyObject) {
        self.deleteAll!()

    }
    
}

