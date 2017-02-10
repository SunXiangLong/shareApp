//
//  MMHorizontalFlowLayout.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/9.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMHorizontalFlowLayout: UICollectionViewFlowLayout {
  
    override func awakeFromNib() {
        self.minimumLineSpacing = 15
        self.minimumInteritemSpacing = 15
        self.sectionInset = UIEdgeInsetsMake(15, 17, 15, 17)
        self.headerReferenceSize = CGSize(width: screenW, height: 30)
    }
    
    var maximumSpacing:CGFloat = 15
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var  attributes = super.layoutAttributesForElements(in: rect)

        for (index, currentLayoutAttributes) in attributes!.enumerated() {
            //每行的第一个cell的frame 就不用计算位置，他后面的根据他的位置和间距来计算位置
            if currentLayoutAttributes.frame.origin.x == 17 {
                continue
            }
            if index == 0   {
                continue
            }
           let  prevLayoutAttributes = attributes![index - 1]
            
           let origin = prevLayoutAttributes.frame.maxX

            //计算当前的下一个cell的位置是不是超过当前屏幕的宽度是的话换行
            if origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width {
                var fram = currentLayoutAttributes.frame
                fram.origin.x = origin + maximumSpacing
                currentLayoutAttributes.frame = fram
            }            
            
        }
       return attributes
    }
}
