//
//  MMPhoneLoginViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/19.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import MBProgressHUD
class MMPhoneLoginViewController: MMBaseViewController {
    
    @IBOutlet weak var codeButton: AnimatableButton!
    
    @IBOutlet weak var phoneTextField: AnimatableTextField!
    
    @IBOutlet weak var loginButton: AnimatableButton!
    
    @IBOutlet weak var codeTextField: AnimatableTextField!
    
    var countdownTimer: Timer?
    var  selectedIndex = 0
 
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

    override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
        codeButton.setTitle("获取验证码", for: .normal)
        isCounting = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "手机号登录"
         self.rightStr = "注册"
       
   
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func tologin(_ sender: Any) {
        self.performSegue(withIdentifier: "MMToLoginViewController", sender: nil)
    }
   
    override func rightBtnSelector() {
          self.performSegue(withIdentifier: "MMNewShopRegistrationViewController", sender: nil)
    }
    @IBAction func sendButtonClick(_ sender: AnyObject) {
        
        self .sendCode()
    }
    
    @IBAction func login(_ sender: AnyObject) {
        //当为测试账号时走账号密码登录流程，防止傻逼苹果审核人员死活在用短信验证码的登录界面 用密码当验证码使用登录不上给拒了
        if phoneTextField.text! == "15910810785" && codeTextField.text! == "123456"{
            self.postData()
        }else{
            self.phoneLoginRequest()
        }
        
    }
    func updateTime(_ timer: Timer) ->Void {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

    func sendCode() -> Void {
        self.view.endEditing(true)

        HTTPTool.Post(API.sendLoginCode, parameters: ["phone":phoneTextField.text!]) { (model, error) in
            

            if model != nil{
                
                  log("object=====\(String(describing: model?.data))")
                if  model?.status  == (1){
                    
                  
                    self.show((model?.info)!+",请等待", delay: 1.5)
                    // 启动倒计时
                    self.isCounting = true
                }

                
            }else{
                
                log("erro == \(String(describing: error))")

            }
        }

        
    }
    func postData() -> Void {
        
        HTTPTool.Post(API.login, parameters: ["username":phoneTextField.text!,"password":codeTextField.text!.md5()]) { (model, error) in
            
            if model != nil{
                log("dic=====\(String(describing: model?.data))")
                if  model?.status  == (1){
                    
                    MMUserInfo.UserInfo.initUserInfo(model)
                    let TabBar = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as!UITabBarController
                    TabBar.selectedIndex = self.selectedIndex
                    UIApplication.shared.keyWindow?.rootViewController = TabBar
                    self.view.endEditing(false)
                

                    
                    
                }
                
            }else{
                
                log("erro == \(String(describing: error))")
            }
        }
        
    }
    func phoneLoginRequest() -> Void {
        
        self.view.endEditing(true)

        HTTPTool.Post(API.loginCode, parameters: ["username":phoneTextField.text!,"phone_code":codeTextField.text!]) { (model, error) in
            
            if model != nil{
              log("dic=====\(String(describing: model?.info))")
                 if  model?.status  == (1){

                    MMUserInfo.UserInfo.initUserInfo(model)
                    let TabBar = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as!UITabBarController
                    TabBar.selectedIndex = self.selectedIndex
                    UIApplication.shared.keyWindow?.rootViewController = TabBar
                    self.view.endEditing(false)
  
                }
                
            }else{
                
                log("erro == \(String(describing: error))")
            }
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMPersonalCenterViewControllerOne" {
            let nav = segue.destination as!MMNavigationController
            let vc = nav.viewControllers.first as! MMPersonalCenterViewController
            vc.type = "跳转"
            
        }else if segue.identifier == "MMToLoginViewController" {
            let vc = segue.destination as!MMToLoginViewController
            vc.selectedIndex = selectedIndex
        
        }
        
        
    }

  
}
