//
//  MMMyOrderTabPageViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMMyOrderTabPageViewController: TabPageViewController {

    @IBOutlet weak var searchTextField: AnimatableTextField!
    /// 搜索关键字数组
    var keywordArray:[String]? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.frame = CGRect(x: 60, y: 7, width: screenW - 120, height: 30)
        self.navigationController?.navigationBar.isTranslucent = false
        self.childView = {[unowned self]  (page) in
            
            self.searchTextField.text = self.keywordArray![page]
            self.searchTextField.resignFirstResponder()
        }
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.navigationBar.isTranslucent = true
        self.searchTextField.resignFirstResponder()
        self.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.searchTextField.resignFirstResponder()
        keywordArray![self.currentIndex!] = searchTextField.text!
        let vc =  self.tabItems[self.currentIndex!].0 as!MMMyOrderTableViewController
        vc.page = 1
        vc.order_sn = keywordArray![self.currentIndex!];
        vc.orderModeArray?.removeAll()
        vc.tableView.mj_footer.resetNoMoreData()
        vc.tableView.reloadData()
        vc.requestDta()
        return true
    }

}
