//
//  MMsetingCollectionViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/20.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
class optionCellModel{
    ///分类图片
    var optionImage: UIImage?
    ///分类说明
    var optionsText: String?
    
    init(optionimage:UIImage?,optionsStr:String?)  {
        optionImage = optionimage
        optionsText = optionsStr
    }
    
}

class MMsetingCollectionViewCell: MMBaseCollectionViewCell {

    
    @IBOutlet weak var optionImageView: UIImageView!
    
    @IBOutlet weak var optionsLabel: UILabel!
    
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var cellModel:optionCellModel?{
        didSet{
        
            optionsLabel.text = cellModel?.optionsText
            optionImageView.image = cellModel?.optionImage
        
        }
    
    }
    
    
    var indexPath:IndexPath!{
        didSet{
    
            if (indexPath != nil) {
   
                if indexPath.row>2 {
                    self.topConstraint.constant = 0
                }else{
                    self.topConstraint.constant = 0.5
                    
                }
            }
            
        }
    
    }
    
    override func awakeFromNib() {
        
        self.topConstraint.constant = 0.5
        self.rightConstraint.constant = 0.5
        self.bottomConstraint.constant = 0.5
        
        
    }

}
