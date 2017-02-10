//
//  MMSetUpTableViewOneCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/23.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMSetUpTableViewOneCell: MMBaseTableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
class MMSetUpTableViewCell: MMBaseTableViewCell {
    
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var isdefaultButton: UIButton!
    
    var indexPath:IndexPath?
    var model:ShopShareInfo?{
        didSet{
            if model?.isDefault == "1" {
                isdefaultButton.isSelected = true

            }else{
                isdefaultButton.isSelected = false
            }
            shopNameLabel.text = model?.shopName
        }
    }
    var event:((IndexPath,buttonClickEventType)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var type:buttonClickEventType?
    @IBAction func outButton(_ sender: AnyObject) {
        
        type = .out
        self.event!(indexPath!,type!)
    }
    @IBAction func editButton(_ sender: AnyObject) {
        
        type = .edit
        self.event!( indexPath!,type!)
    }
   
    @IBAction func defaultButton(_ sender: AnyObject) {
        
        type = .isDefault
        self.event!( indexPath!,type!)
    }
    
    
    
}
