//
//  MMVIPGoodsListTableViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/25.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMVIPGoodsListTableViewCell: MMBaseTableViewCell {

    
    @IBOutlet weak var goodsThumbImageView: UIImageView!
    @IBOutlet weak var goodsNumberLabel: UILabel!
    @IBOutlet weak var weidianGoodsProfitLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var weidianGoodsPricelabel: UILabel!
    var buttonEventType:buttonClickType?
    var indexPath:IndexPath?
    @IBOutlet weak var imageheightConstraint: NSLayoutConstraint!
    var goodsModel:MMGoodsModel?{
        didSet{
            goodsThumbImageView.setImage(goodsModel?.goods_thumb, type: .one)
            goodsNumberLabel.text = "库存：" + (goodsModel?.goods_number)!
            goodsNameLabel.text = goodsModel?.goods_name
            weidianGoodsPricelabel.text  = goodsModel?.weidian_goods_price
            weidianGoodsProfitLabel.text = goodsModel?.weidian_goods_profit
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageheightConstraint.constant = 0.5
    }
    
    
    @IBAction func share(_ sender: UIButton) {
        
        if goodsModel != nil {
            self.buttonEventType!(goodsModel!,indexPath!,.share)
        }
    }
   
    
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
