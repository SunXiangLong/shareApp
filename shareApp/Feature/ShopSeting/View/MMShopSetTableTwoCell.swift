//
//  MMShopSetTableTwoCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMShopSetTableTwoCell: MMBaseTableViewCell {

    @IBOutlet weak var shopInformationTypeLabel: UILabel!
    @IBOutlet weak var imageVieWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopInfoImageView: UIImageView!
    
    var model:ShopShareInfo?
    
    var indexPath:IndexPath?{
        didSet{
            
            switch indexPath!.row {
            case 0:
                shopInformationTypeLabel.text = "头像"
                if model != nil {
                   shopInfoImageView.setImage(model?.shopAvatar!, image: #imageLiteral(resourceName: "mm_defaultAvatar"))
                    
                }
                
            case 1:
                shopInformationTypeLabel.text = "背景"
                imageVieWidthConstraint.constant = CGFloat(45*124/70)
                if model != nil {
                    shopInfoImageView.setImage(model?.shopBackground!, image: #imageLiteral(resourceName: "backgroupImage"))
                    
                }else{
                    shopInfoImageView.image = UIImage.init(named: "backgroupImage")
                }
                
                
            default:break
                
            }

        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopInfoImageView.layer.cornerRadius = 5;
    }
}
