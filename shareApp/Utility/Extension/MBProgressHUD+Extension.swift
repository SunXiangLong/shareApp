//
//  MBProgressHUD+Extension.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/18.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MBProgressHUD
extension MBProgressHUD
{
    class func showMessage(_ message:String?,toView:UIView?,delay: TimeInterval?)->Void{
        
        var views:UIView?
        
        if let view = toView {
            views = view
        }else{
            
            views = UIApplication.shared.keyWindow
      
            
        }
        let  hud = MBProgressHUD.showAdded(to: views!, animated: true)
        //        hud.mode = .Text
        if let message = message {
            hud.label.text = message
        }
        if let delay = delay {
            
            hud.label.textColor  = UIColor.white
            hud.mode = .text
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: delay)
            
            
        }
        
        
        
        
    }
    
    class  func show() -> Void {
        
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)

    }
    class  func show(_ message:String?,delay: TimeInterval) -> Void {
        if message != nil {
             MBProgressHUD.showMessage(message, toView: nil,delay: delay)
        }
       
    }
 
   class  func dismiss() -> Void {
        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)

    }
    class func hideHUDForView(_ toView:UIView?)->Void{
        var views:UIView?
        
        if let view = toView {
            views = view
        }else{

            views = UIApplication.shared.keyWindow

        }
        
        
          self.hide(for: views!, animated: true)
        
        
        
    }
    
    
}
