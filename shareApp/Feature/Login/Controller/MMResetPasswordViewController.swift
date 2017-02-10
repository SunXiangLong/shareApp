//
//  MMResetPasswordViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/19.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import MBProgressHUD
class MMResetPasswordViewController: MMBaseViewController {
    
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    
    @IBOutlet weak var toPasswordTextField: AnimatableTextField!
    
    var phoneText:String?
    var phoneCodeText:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "重置密码"
        self.rightStr = "确定"
        
    }
    
    override func rightBtnSelector() {
        
        if passwordTextField.text! == toPasswordTextField.text! {
            self.resetPassword()
        }else{
            self.show("两次输入的密码不一致", delay: 1.5)
            
            
        }
        
    }
    
    
    func resetPassword() -> Void {
        
        log(self.navigationController?.viewControllers)
        self.view.endEditing(true)
        
        HTTPTool.Post(API.resetPassword, parameters: ["phone":phoneText!,"phone_code":phoneCodeText!,"password":passwordTextField.text!.md5()]) { (model, erro) in
            
            
            if model != nil{
                
                log("dic=====\(model?.info)")
                if model?.status  == (1){
                    
                    let alertController = UIAlertController.init(title: "提示", message: model?.info, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction.init(title: "返回登录页", style:  .default, handler: {[unowned self]  action in
                        self.navigationController?.childViewControllers.forEach{
                            if $0.isKind(of: MMToLoginViewController.classForKeyedArchiver()!) {
                                self.popToViewController($0, animated: true)
                            }
                         }
                        
                        }))
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }else{
                    
                }
                
            }else{
                
                log("erro == \(erro)")
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
