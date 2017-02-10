//
//  MMPhoneCodeViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/19.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMPhoneCodeViewController: MMBaseViewController {
    
    @IBOutlet weak var phoneCode: AnimatableTextField!
    var phoneText:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "短信验证"
        self.rightStr = "下一步"
    }
    override func rightBtnSelector() {
        self.validCode()
    }
    func validCode() -> Void {
        self.view.endEditing(true)
        
        HTTPTool.Post(API.validCode, parameters: ["phone":phoneText!,"phone_code":phoneCode.text!]) { (model, error) in
            if model != nil{
                log("dic=====\(model?.info)")
                if  model?.status  == (1){
                    let alertController = UIAlertController.init(title: "提示", message: model?.info, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction.init(title: "下一步", style:  .default, handler: {[unowned self]  action in
                        self.performSegue(withIdentifier: "MMResetPasswordViewController", sender: nil)
                        }))
                    self.present(alertController, animated: true, completion: nil)
                    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMResetPasswordViewController" {
            let controller = segue.destination as! MMResetPasswordViewController
            controller.phoneText = phoneText
            controller.phoneCodeText = phoneCode.text!
        }
        
    }
}
