//
//  MMNewShopRegistrationViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/19.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMNewShopRegistrationViewController: MMBaseViewController {
    
    @IBOutlet weak var agreementButton: UIButton!
    
    @IBOutlet weak var codeButton: AnimatableButton!
    
    @IBOutlet weak var registeredButton: AnimatableButton!
    
    @IBOutlet weak var phoneTextField: AnimatableTextField!
    
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    
    @IBOutlet weak var codeTextField: AnimatableTextField!
    
    @IBOutlet weak var openShopCodeTextField: AnimatableTextField!
    
    @IBOutlet weak var inviteCodeTextField: AnimatableTextField!
    
    @IBOutlet weak var openShopButton: AnimatableButton!
    
    var countdownTimer: Timer?
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 30
                
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                codeButton.backgroundColor = Color.white
            }
            
            codeButton.isEnabled = !newValue
        }
    }
    var remainingSeconds: Int = 0 {
        willSet {
            codeButton.setTitle("\(newValue)秒", for: .normal)
            
            if newValue <= 0 {
                codeButton.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        codeTextField.text = MMUserInfo.UserInfo.code
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.commonJudge()
        self.title = "新用户注册"
        phoneTextField.resignFirstResponder()
    }
    
    @IBAction func agreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func sendButtonClick(_ sender: AnyObject) {
       
        
        self.sendCode()
    }
    
    @IBAction func registered(_ sender: AnyObject) {
        if agreementButton.isSelected {
            self.requestData()
        }else{
            
            self.show("请同意用户协议", delay: 1)
        }
        
    }
    func updateTime(_ timer: Timer) ->Void {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    func sendCode() -> Void {
        
        
        HTTPTool.Post(API.sendCode, parameters: ["phone":phoneTextField.text!]) { (model, error) in
            
            if model != nil{
                
                log("dic=====\(String(describing: model?.info))")
                if  model?.status  == (1){
                    self.show(model?.info, delay: 1.5);
                    // 启动倒计时
                    self.isCounting = true
                    MMUserInfo.UserInfo.username = self.phoneTextField.text
                }else{
                    
                }
                
            }else{
                
                log("erro == \(String(describing: error))")
            }
        }
        
    }
    
    func requestData() -> Void {
        
        self.view.endEditing(true)
        
        HTTPTool.Post(API.newRegister, parameters: ["username":phoneTextField.text!,"phone_code":codeTextField.text!,"password":passwordTextField.text!.md5(),/*"shop_code":openShopCodeTextField.text!,*/"invite_code":inviteCodeTextField.text!]) { (model, erro) in
            
            
            if let model = model{
                
                log("dic=====\(String(describing: model.data))")
                if model.status == (1){
                    self.show(model.info, delay: 1);
                    self.popViewController(animated: true)
                    
                    
                }
                
            }else{
                
                log("erro == \(String(describing: erro))")
                
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
