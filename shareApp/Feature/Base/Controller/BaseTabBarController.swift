//
//  BaseTabBarController.swift
//  shareApp
//
//  Created by xiaomabao on 2017/3/6.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startPage(self.view)
        let normal = UIFont.init(name: "Helvetica", size: 9);
        let selected = UIFont.init(name: "Helvetica", size: 9)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:"999999".color,NSFontAttributeName:normal!], for: .normal);
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:"333333".color,NSFontAttributeName:selected!], for: .selected);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
