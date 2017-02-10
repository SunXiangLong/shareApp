//
//  MMInviteFriendViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/26.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMInviteFriendViewController: MMBaseViewController {
    
    var qrCodeView: MMQrcodeView!
    
    
    
    //先缓存二维码和店铺头像image
    lazy var avatarsImageView:UIImageView = {
        return UIImageView()
    }()
    lazy var qrcodeImageView:UIImageView = {
        return UIImageView()
    }()
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    @IBAction func hidden(_ sender: AnyObject) {
        
        
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = true
        self.shareView.shopView.isHidden  = false
        self.shareView.cancleButton.isHidden = false
        self.shareView.shopEvent = {[unowned self]  (shopSharemodel) in
            self.shareView.url = URL.init(string:MMUserInfo.UserInfo.shop_invite_url.absoluteString + "?c=\(shopSharemodel.id!)" )
            
            
            self.show()
            
            self.avatarsImageView.kf.setImage(with: shopSharemodel.shopAvatar, placeholder:nil , options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.dismiss()
                if image == nil{
                self.shareView.image = UIImage.init(named: "mm_defaultAvatar")
                }else{
                self.shareView.image = image
                }
                
            })
            
            self.qrcodeImageView.kf.setImage(with:
            URL.init(string: Key.shopQrCode + MMUserInfo.UserInfo.token! + "/" + shopSharemodel.id + "/" + "2"))
            
            self.shareView.title = shopSharemodel.shopName + "  给你送大礼了"
            self.shareView.centerText = " 欢迎成为共享购的新朋友，购买开店大礼包，免费赠您开店资格，超级划算哦"
            
        }
        
        self.shareView.event = {  [unowned self]   (type) in
            switch type {
            case .cancelType:
                self.hiddenShare()
                break
            case .loadQrCodeViewType:
                self.hiddenQrcode()
                break
            }
        }
        UIApplication.shared.keyWindow?.addSubview(self.shareView);
        self.shareView.autoRun =  true
    }
    
    ///分享店铺二维码
    func hiddenQrcode() {
        qrCodeView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        UIApplication.shared.keyWindow?.addSubview(qrCodeView);
        
        qrCodeView.qrcodeImageView.image = qrcodeImageView.image
        qrCodeView.animationType = .slide(way: .in, direction: .down)
        qrCodeView.autoRun = false
        
        self.hiddenShare()
         qrCodeView.autoRun = true
        qrCodeView.cancleEvent = { [unowned self]  () in
            UIView.animate(withDuration: 0.3, animations: {
                self.qrCodeView.sxl_y = screenH
            }) { (bool) in
                self.qrCodeView.removeFromSuperview()
                
            }
        }
    }
    @IBAction func back(_ sender: AnyObject) {
        
        self.popViewController(animated: true)
    }
  
    ///移除分享View
    func hiddenShare() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.sxl_y = screenH
        }) { (bool) in
            self.shareView.removeFromSuperview()
            
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
