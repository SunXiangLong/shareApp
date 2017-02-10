//
//  MMShareViewTableViewCell.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/9/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMShareViewTableViewCell: UITableViewCell {

    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    var model:ShopShareInfo?{
        didSet{
          shopNameLabel.text = model?.shopName
            if  model?.isDefault == "1" {
                selectImageView.isHidden = false
            }
        
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
  
    
    
}
