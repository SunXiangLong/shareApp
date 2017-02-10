//
//  MMApplyWithdrawViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/27.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMApplyWithdrawViewController: MMBaseViewController {

    
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var backID: UILabel!
    @IBOutlet weak var applyMoneyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现"
        availableBalanceLabel.text = MMUserInfo.UserInfo.available_balance
        realNameLabel.text = MMUserInfo.UserInfo.real_name
        bankLabel.text = MMUserInfo.UserInfo.deposit_bank + MMUserInfo.UserInfo.branch_bank
        backID.text = MMUserInfo.UserInfo.card_no
       
    }

    @IBAction func sureToSubmit(_ sender: AnyObject) {
        self.requestDta()
        
        
    }
    override func requestDta() {
        
        HTTPTool.Post(API.profitApplyWithdraw, parameters: ["token":MMUserInfo.UserInfo.token!,"apply_money":applyMoneyTextField.text!]) { (model, error) in
            
            if model != nil{
                
                log(model?.data)
                if model?.status == (1){
                    self.show(model?.info, delay: 1)
                    self.performSegue(withIdentifier: "MMShowResultViewController", sender: nil)
                
                }
                
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMShowResultViewController" {
            let controller = segue.destination as! MMShowResultViewController
            controller.applyMoney = self.applyMoneyTextField.text!
            
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
