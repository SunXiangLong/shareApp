//
//  MMRetrievePasswordViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/19.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMRetrievePasswordViewController: MMBaseViewController {

    @IBOutlet weak var phoneTextField: AnimatableTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "找回密码"
        self.rightStr = "下一步"
                
        
    }
    

    override func rightBtnSelector() {
            self.sendCode()
    }
 
    
    func sendCode() -> Void {
        self.view.endEditing(true)
        
        HTTPTool.Post(API.sendLoginCode, parameters: ["phone":phoneTextField.text!]) { (model, erro) in
            
            
            if model != nil{
            
                log("dic=====\(String(describing: model?.data))")
                if  model?.status  == (1){
                    let alertController = UIAlertController.init(title: "提示", message: model?.info, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction.init(title: "下一步", style:  .default, handler: {[unowned self]  action in
                        
                        self.performSegue(withIdentifier: "MMPhoneCodeViewController", sender: nil)
                        
                        }))
                    self.present(alertController, animated: true, completion: nil)

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMPhoneCodeViewController" {
            
            let controller = segue.destination as! MMPhoneCodeViewController
            controller.phoneText = phoneTextField.text!
        }
    
    }
   
}
