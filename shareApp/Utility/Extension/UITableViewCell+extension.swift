//
//  UITableViewCell+extension.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/25.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

public extension UITableViewCell{
    /// 让cell地下的边线挨着左边界
    func uiedgeInsetsZero() -> Void {
        
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins  = false
    }
    /**
     *  移除cell最下的线
     */
    func removeUIEdgeInsetsZero() -> Void {
        self.separatorInset = UIEdgeInsetsMake(0, 100000, 0, 0)
        self.layoutMargins = UIEdgeInsetsMake(0, 100000, 0, 0)
        
    }

}
