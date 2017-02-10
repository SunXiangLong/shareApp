//
//  MMGoodsHeadCollectionViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/25.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMGoodsHeadCollectionViewCell: MMBaseCollectionViewCell {

   
    @IBOutlet weak var goodsImageView: UIImageView!
    var  model:MMGoodsCategoryChildModel?{
        didSet{
            goodsImageView.setImage(model?.icon, type: .three)
            
    
    
    }
    
    
    }

}
