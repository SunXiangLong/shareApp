//
//  MMVipTabPageViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/3.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMVipTabPageViewController: TabPageViewController {
    
    var qrCodeView: MMQrcodeView!
    
    @IBOutlet weak var searchTextField: AnimatableTextField!
    lazy var keywordArray:[String] = {
        return [String]()
        
    }()
    //先缓存二维码和店铺头像image
    lazy var avatarsImageView : UIImageView = {
        return UIImageView()
    }()
    lazy var qrcodeImageView : UIImageView = {
        return UIImageView()
    }()
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.frame = CGRect(x: 60, y: 7, width: screenW - 120, height: 30)
        self.childView = {[unowned self]  (page) in
            self.searchTextField.resignFirstResponder()
            self.searchTextField.text = self.keywordArray[page]
        }

    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.searchTextField.resignFirstResponder()
        self.navigationController?.navigationBar.isTranslucent = true
        self.popViewController(animated: true)
    }
    @IBAction func share(_ sender: AnyObject) {
        self.shareVIP()
    }
    func shareVIP() {
        
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = true
        self.shareView.shopView.isHidden  = false
        self.shareView.cancleButton.isHidden = false
        self.shareView.shopEvent = {[unowned self]  (shopSharemodel) in
            self.shareView.url = URL.init(string:MMUserInfo.UserInfo.shop_share_vip_url.absoluteString + "?c=\(shopSharemodel.id!)" )
            
            
            self.show()
            
            self.avatarsImageView.kf.setImage(with:shopSharemodel.shopAvatar, placeholder:nil , options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.dismiss()
                if image == nil{
                    self.shareView.image = UIImage.init(named: "mm_defaultAvatar")
                }else{
                    self.shareView.image = image
                }
                
            })
            
            self.qrcodeImageView.kf.setImage(with: URL.init(string: Key.shopQrCode + MMUserInfo.UserInfo.token! + "/" + shopSharemodel.id + "/" + "1"))
            
            self.shareView.title = shopSharemodel.shopName
            self.shareView.centerText = shopSharemodel.shopDescription
            
        }
        
        self.shareView.event = { [unowned self]   (type) in
            switch type {
            case .cancelType:
                self.hiddenShare()
                break
            case .loadQrCodeViewType:
                self.hiddenShare()
                self.hiddenQrcode()
                break
                
            }
            
        }
        UIApplication.shared.keyWindow?.addSubview(self.shareView);
        self.shareView.autoRun =  true
    }
    func hiddenShare() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.sxl_y = screenH
        }) { (bool) in
            self.shareView.removeFromSuperview()
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            
            switch identifier {
            
            case "MMSearchGoodsViewController":
                let vc = segue.destination as!MMSearchGoodsViewController
                vc.type = .vipGoods
            default: break
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
//        searchViewModel().checkUpdate{
//        self.performSegueWithIdentifier("MMSearchGoodsViewController", sender: nil)
//        }
    self.performSegue(withIdentifier: "MMSearchGoodsViewController", sender: nil)
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        return false
    }
    
    
}
