//
//  MMQrcodeView.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import MBProgressHUD
class MMQrcodeView: AnimatableView {

   
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var qrcodeImageView: UIImageView!
    
    @IBOutlet weak var groupImageView: UIImageView!
    var cancleEvent:(() ->Void)?

 
    @IBAction func cancel(_ sender: AnyObject) {
        
        cancleEvent!()
    }
    
    @IBAction func savePhoto(_ sender: AnyObject) {
        if self.qrcodeImageView.image != nil {
            UIImageWriteToSavedPhotosAlbum(self.qrcodeImageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)),nil)
        }else{
            MBProgressHUD.show("图片缓存中", delay: 1)
        
        }
        
    }
    // 提示：参数 空格 参数别名: 类型
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        
        // if didFinishSavingWithError != nil {
        if error != nil {
            log(error)
            MBProgressHUD.show("保存失败", delay: 1)
            return
        }
        MBProgressHUD.show("保存成功", delay: 1)
    }
}
