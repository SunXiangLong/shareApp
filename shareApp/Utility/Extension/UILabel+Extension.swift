//
//  UILabel+Extension.swift
//  ShareApp
//
//  Created by xiaomabao on 16/9/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
import IBAnimatable
public extension UILabel{

    func rowSpace(_ rowSpace:CGFloat) -> Void {
       
        self.numberOfLines = 0
        let attributedString = NSMutableAttributedString.init(attributedString: self.attributedText!)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = rowSpace
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.baseWritingDirection = .leftToRight
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, (self.text?.characters.count)!))
        self.attributedText = attributedString;
    }

}
extension UITextView{

    /// 注:必须要在addSubview之后调用，否则不起作用
    func autoHeight(){
        let contentSize = self.sizeThatFits(self.bounds.size)
        self.frame.size.height = contentSize.height
    }
    func placeholder(_ placeholder:String){
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = placeholder
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        placeHolderLabel.textColor = "c7c7cd".color
        placeHolderLabel.sizeToFit()
        self.addSubview(placeHolderLabel)
        self.setValue(placeHolderLabel, forKey: "_placeholderLabel")
    
    
    }

}

extension String{


    
    func stringWithSize(_ size:CGSize,font:UIFont) -> CGSize {
        let str = self as NSString
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
    }
}
