//
//  shoppingCartCell.swift
//  shareApp
//
//  Created by xiaomabao on 2017/3/6.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit

class shoppingCartCell: UITableViewCell {
    @IBOutlet weak var goodsImage: UIImageView!
    @IBOutlet weak var selectedBtn: UIButton!
   
    @IBOutlet weak var goodsNUm: UITextField!
    @IBOutlet weak var lessBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsSpace: UILabel!
    @IBOutlet weak var goodsName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func less_btn(_ sender: UIButton) {
    }
    
    
    @IBAction func more_btn(_ sender: UIButton) {
        
    }
    
    @IBAction func selected_btn(_ sender: UIButton) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
