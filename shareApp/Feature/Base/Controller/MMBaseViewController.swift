//
//  MMBaseViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/18.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MBProgressHUD

class MMBaseViewController: UIViewController {
    
    
    var backBtn:UIButton?
    var rightBtn:UIButton?
    var rightStr:String?{
        didSet{
            if rightStr != nil {
                self.rightBtn!.setTitle(rightStr!, for: UIControlState())
            }
            
        }
        
        
    }
    var rightImageStr:String?{
        didSet{
            if rightStr != nil {
                self.rightBtn!.setImage(UIImage.init(named: rightImageStr!), for: UIControlState())
            }
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(String.init(describing: type(of: self)))
       
           }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(String.init(describing: type(of: self)))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        self.backBtn = UIButton.init(type: .custom)
        self.backBtn!.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        self.backBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
        self.backBtn!.addTarget(self, action: #selector(self.popViewControllerAnimated), for: .touchUpInside)
        self.backBtn!.setImage(UIImage.init(named: "back_arrow"), for: UIControlState())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn!)
        
        
        self.rightBtn = UIButton.init(type: .custom)
        self.rightBtn!.frame = CGRect(x: 0, y: 0, width: 60, height: 44);
        self.rightBtn!.addTarget(self, action: #selector(self.rightBtnSelector), for: .touchUpInside)
        self.rightBtn!.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        self.rightBtn!.setTitleColor("333333".color, for: UIControlState())
        self.rightBtn!.titleLabel?.font = UIFont.init(name:NeueFont, size: 14)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn!)
    }
    
    /**
     右按钮相应方法
     */
    func rightBtnSelector() -> Void {
        
    }
    /**
     请求数据方法
     */
    func requestDta() -> Void {
        
    }
    func popViewControllerAnimated() -> Void {
        self.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    deinit{
        
        log("\(String.init(describing: type(of: self))) ---> 被销毁 ")

    }
}
extension UIViewController{
   
    
    func popViewController(animated: Bool) -> Void {
      _ =  self.navigationController?.popViewController(animated: animated)
    }
    func popToViewController(_ viewController: UIViewController,animated: Bool) -> Void {
       _ = self.navigationController?.popToViewController(viewController, animated: animated)
    }
    ///提醒tool(带显示时间自动取消)
    func show(_ message:String?,delay: TimeInterval) -> Void{
        if message != nil {
            MBProgressHUD.show(message, delay: delay)
        }else{
            
        }
    }
//    ///请求等待tool(带提示文字)
//    func show(_ title:String) -> Void {
//    
//        MBProgressHUD.showMessage(title, toView: nil,delay: nil)
//    }
    ///请求等待tool(不带提示文字)
    func show() -> Void {
        
       MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    ///取消tool
    func dismiss() -> Void {
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    ///截屏图片
    func screenSnapshot(save: Bool) -> UIImage? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if save { UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil) }
        
        return image
    }
    
}
