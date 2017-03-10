//
//  MMBaseTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/2.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMBaseTableViewController: UITableViewController {
     
    var backBtn:UIButton?
    var rightBtn:UIButton?
    var rightStr:String?{
        didSet{
            if rightStr != nil {
//                self.rightBtn!.setTitle(rightStr!, for: UIControlState())
                self.rightBtn?.setTitle(rightStr, for: .normal)
               log(rightBtn)
            }
            
            
        }
    }
    var rightImageStr:String?{
        didSet{
            if rightStr != nil {
                self.rightBtn!.setImage(UIImage.init(named: rightImageStr!), for: .normal)
               
            }
            
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(String.init(describing: type(of: self)))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(String.init(describing: type(of: self)))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let  option = TabPageOption()
        if self.navigationController != nil {
            self.navigationController!.navigationBar.setBackgroundImage(option.tabBackgroundImage, for: .default)
        }
        
        
        backBtn = UIButton.init(type: .custom)
        backBtn?.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        self.backBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
        self.backBtn?.addTarget(self, action: #selector(self.popViewControllerAnimated), for: .touchUpInside)
        self.backBtn?.setImage(UIImage.init(named: "back_arrow"), for: UIControlState());
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn!)
        
        
        rightBtn = UIButton.init(type: .custom)
        rightBtn?.frame = CGRect(x: screenW - 60, y: 0, width: 60, height: 44);
        rightBtn?.addTarget(self, action: #selector(self.rightBtnSelector), for: .touchUpInside)
        self.rightBtn?.titleLabel?.font = UIFont.init(name: NeueFont, size: 14)
//        self.rightBtn?.titleLabel?.textColor = "555555".color
        self.rightBtn?.setTitleColor("555555".color, for: .normal);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     右按钮相应方法
     */
    func rightBtnSelector() -> Void {
        
    }
    /**
     请求数据方法
     */
    func requestDta() -> Void {
        
    }
    func popViewControllerAnimated() -> Void {
        self.popViewController(animated: true)
       
    }

    
    deinit{
          log("\(String.init(describing: type(of: self))) ---> 被销毁 ")        
    }
}
