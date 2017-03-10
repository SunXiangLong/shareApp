//
//  SXLNavigationController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/15.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        self.interactivePopGestureRecognizer!.delegate = self
        self.navigationBar.tintColor =   "333333".color
//        UINavigationBar.appearance().backgroundColor = UIColor.white
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName: "333333".color,NSFontAttributeName:UIFont.init(name:NeueFont , size: 17.0)!]
       
    }
    
}

extension MMNavigationController :UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
}
