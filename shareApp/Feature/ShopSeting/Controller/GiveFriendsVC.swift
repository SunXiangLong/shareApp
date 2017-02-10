//
//  GiveFriendsVC.swift
//  shareApp
//
//  Created by xiaomabao on 2016/12/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class GiveFriendsVC: MMBaseViewController {
    
    @IBOutlet weak var sendNUmber: AnimatableTextField!
    @IBOutlet weak var otherAccount: AnimatableTextField!
    @IBOutlet weak var isGiveBeanNumber: UILabel!
    var number :String?
    var reloadData:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "赠送好友"
        isGiveBeanNumber.text = number!
        
    }
    
    
    @IBAction func ConfirmPresent(_ sender: UIButton) {
        
        if otherAccount.text?.characters.count == 0 {
            self.show("请填写赠送账户", delay:0.8);
            return;
        }
        if sendNUmber.text?.characters.count == 0 {
            self.show("请填写赠送数量", delay:0.8);
            return;
        }
        requestDta();
    }
    override func requestDta() {
        HTTPTool.Post(API.beanSend, parameters: ["token":MMUserInfo.UserInfo.token!,"friend_account":otherAccount.text!,"send_number":sendNUmber.text!]) { (model, error) in
            if model != nil{
                let title = model?.data!["info"].string!
                self.show(title, delay: 0.8)
                if title == "赠送成功~"{
                    self.reloadData!()
                    self.popViewControllerAnimated()
                    
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
