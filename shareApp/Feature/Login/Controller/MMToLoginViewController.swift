//
//  MMToLoginViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/18.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MBProgressHUD
class MMToLoginViewController: MMBaseViewController {

    @IBOutlet weak var phoneTextFeld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var password:String?
    var  selectedIndex = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        password = UserDefaults.standard.value(forKey: "password") as! String!
        if password != nil {
            self.passwordTextField.text = password
            self.phoneTextFeld.text = UserDefaults.standard.value(forKey: "username") as! String!
        }else{
        self.passwordTextField.text = ""
        self.phoneTextFeld.text = ""
        
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "帐号登录"
        self.rightStr = "注册"
        
        
    }

    override func rightBtnSelector() {
        self.performSegue(withIdentifier: "MMNewShopRegistrationViewController", sender: nil)
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        self.postData()
        
        
    }
    
    func postData() -> Void {
    
        HTTPTool.Post(API.login, parameters: ["username":phoneTextFeld.text!,"password":passwordTextField.text!.md5()]) { (model, error) in
        
            if model != nil{
                log("dic=====\(model?.data)")
                if  model?.status  == (1){
    
                    MMUserInfo.UserInfo.initUserInfo(model)
                    let TabBar = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as!UITabBarController
                    TabBar.selectedIndex = self.selectedIndex
                    UIApplication.shared.keyWindow?.rootViewController = TabBar
                    self.view.endEditing(false)
                    
                }
           
        }else{
            
            log("erro == \(error)")
             }
        }
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMPersonalCenterViewControllerTwo" {
//            let TabBar = segue.destination as!UITabBarController
//            let vc = nav.viewControllers.first as! MMPersonalCenterViewController
//            vc.type = "跳转"
            
        }
        
       
    }


}
