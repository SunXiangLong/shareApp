//
//  MMShareView.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/25.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import MBProgressHUD
class MMShareView: AnimatableView,UITableViewDelegate,UITableViewDataSource {
    
    var title:String?
    var centerText:String?
    var image:UIImage?
    var url:URL?
    var event:((buttonResponseType) ->Void)?
    var shopEvent:((ShopShareInfo)->Void)?
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var qrCode: UIButton!
    @IBOutlet weak var shopView: AnimatableView!
    @IBOutlet weak var shareView: AnimatableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancleButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "MMShareViewTableViewCell", bundle: nil), forCellReuseIdentifier: "MMShareViewTableViewCell")
        
        
        if  MMUserInfo.UserInfo.shareInfo.count == 0 {
            self.isHidden   = true
            
            let sheet = UIAlertView.init(title: "提醒", message: "请先设置店铺信息（点击首页头像进行设置）", delegate: nil, cancelButtonTitle: "确定")
            sheet.show()
            
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: AnyObject) {
        
        self.event!(.cancelType)
    }
    
    @IBAction func cancleBtn1(_ sender: AnyObject) {
        
        self.event!(.cancelType)
        
    }
    
    @IBAction func WechatBtn(_ sender: AnyObject) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: centerText,
                                                images :image,
                                                url :   url,
                                                title : title,
                                                type : SSDKContentType.webPage)
        self.event!(.cancelType)
        
        ShareSDK.share(.subTypeWechatSession, parameters: shareParames) { (state, userData, contentEntity, error) in
            
            self.event!(.cancelType)
            
            switch state{
            case .success:
                
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            case .fail:
                MBProgressHUD.show("分享失败", delay: 1)
                log(error);
                log(shareParames)
//            case .cancel: MBProgressHUD.show("取消分享", delay: 1)
            default:
                break
            }
            
        }
        

    }
    
    @IBAction func WechatTimeline(_ sender: AnyObject) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: centerText,
                                                images :image,
                                                url :   url,
                                                title : title,
                                                type : SSDKContentType.webPage)
        //2.进行分享到微信朋友圈
        let shareDic = NSMutableDictionary()
        shareDic.ssdkSetupShareParams(byText: String(describing: url), images: nil, url: nil, title: nil, type: .auto)
        ShareSDK.share(SSDKPlatformType.subTypeWechatTimeline, parameters: shareParames) { (state, userData,contentEntity,error) -> Void in
            self.event!(.cancelType)
            switch state{
            case SSDKResponseState.success:
                
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            case SSDKResponseState.fail:
                MBProgressHUD.show("分享失败", delay: 1)
                
//            case SSDKResponseState.cancel: MBProgressHUD.show("取消分享", delay: 1)
            default:
                break
            }
            
        }
    }
    
    @IBAction func qrBtn(_ sender: AnyObject) {
        self.event!(.loadQrCodeViewType)
        
    }
    
    @IBAction func ContentBtn(_ sender: AnyObject) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: centerText,
                                                images :image,
                                                url :   url,
                                                title : title,
                                                type : SSDKContentType.auto)
        log(shareParames)
        ShareSDK.share(SSDKPlatformType.typeCopy, parameters: shareParames) { (state , userData, contentEntity, error) -> Void in
            switch state{
            case SSDKResponseState.success:
                
                let alert = UIAlertView(title: "复制成功", message: "已复制", delegate: self, cancelButtonTitle: "确定 ")
                
                alert.show()
            case SSDKResponseState.fail: MBProgressHUD.show("复制失败", delay: 1)
            log(error)
            case SSDKResponseState.cancel: MBProgressHUD.show("取消复制", delay: 1)
            default:
                break
            }
            
        }
        
    }
    
    //MARk:UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MMUserInfo.UserInfo.shareInfo.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMShareViewTableViewCell", for: indexPath)as!MMShareViewTableViewCell
        cell.model = MMUserInfo.UserInfo.shareInfo[indexPath.row]
        cell.removeUIEdgeInsetsZero()
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        cancleButton.isHidden = true
        shopView.isHidden = true
        shareView.isHidden = false
        self.shopEvent!(MMUserInfo.UserInfo.shareInfo[indexPath.row])
        
        
    }
    
}
