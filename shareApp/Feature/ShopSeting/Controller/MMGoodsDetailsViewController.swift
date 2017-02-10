//
//  MMGoodsDetailsViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit
class MMGoodsDetailsViewController: MMBaseViewController,UIWebViewDelegate{
    var web:UIWebView?
    var url:URL?
    var isMyShop = false
    var type:LoadingWebviewType?
    var  brandModel:MMBrandModel?
    var order_sn:String?
    lazy var shareImageVIew:UIImageView = {
        return UIImageView()
    }()
    var isOne = true
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if type == LoadingWebviewType.eventWebsite {
            
            self.rightBtn!.setImage(#imageLiteral(resourceName: "mm_share1"),for:UIControlState())
            self.rightBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        }
        
        if type == LoadingWebviewType.eventWebsite {
            web = UIWebView.init(frame:CGRect(x: 0, y: 0, width: screenW, height: screenH - 64 ))
            web?.loadRequest(URLRequest.init(url: url!))
            web?.delegate = self
            web?.scalesPageToFit = true
            self.view.addSubview(web!)
            self.rightBtn!.setImage(UIImage.init(named:"mm_share1"),for:UIControlState())
            self.rightBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            shareImageVIew.setImage(brandModel?.banner, image: #imageLiteral(resourceName: "mm_defaultAvatar"))
            
            
        }else if(type == LoadingWebviewType.goodsDetails){
            var frame = CGRect(x: 0, y: 0, width: screenW, height: screenH - 64)
             NotificationCenter.default.addObserver(self, selector: #selector(self.wxPayBlock(_:)), name: NSNotification.Name(rawValue: "WxPay"), object: nil)
            if isMyShop {
                
                frame = CGRect(x: 0, y: 0, width: screenW, height: screenH )
            }
            let requst = NSMutableURLRequest(url: url!)
//          设置请求方法为POST
            web = UIWebView.init(frame:frame)
            requst.httpMethod = "POST"
            web?.delegate = self
            web?.scalesPageToFit = true
            // 设置请求参数
            requst.httpBody = "token=\(MMUserInfo.UserInfo.token!)&device_id=\(UUID())".data(using: String.Encoding.utf8)
            web?.loadRequest(requst as URLRequest);
            self.view.addSubview(web!)
        }
        self.show()
    }
    override func popViewControllerAnimated() {
        
        if type! == .eventWebsite {
            if web!.canGoBack {
                web?.goBack()
            }else{
                super.popViewControllerAnimated();
            }
        }else{
         super.popViewControllerAnimated();
        }
        
    }
    override func rightBtnSelector() -> Void {
        
        if type == LoadingWebviewType.goodsDetails {
            
            return
        
        }
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = false
        self.shareView.shopView.isHidden  = true
        self.shareView.cancleButton.isHidden = true
        self.shareView.title = brandModel?.title
        self.shareView.centerText = brandModel!.share_desc
        self.shareView.image = shareImageVIew.image
        self.shareView.url = brandModel?.share_url
        self.shareView.width.constant = 0
        self.shareView.event = { [unowned self]   (type) in
            self.hiddenShare()
        }
        UIApplication.shared.keyWindow?.addSubview(self.shareView)
        self.shareView.autoRun =  true
    }
    func hiddenShare() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.sxl_y = screenH
        }) { (bool) in
            self.shareView.removeFromSuperview()
        }
    }
    ///微信支付结果的回调
    func wxPayBlock(_ notif:Notification) -> Void {
        let resp = notif.userInfo!["resp"] as!BaseResp
        switch resp.errCode {
        case 0:
            self.performSegue(withIdentifier: "MMPreviewShopViewController", sender: nil)
            break
        case -1:
            self.show(resp.errStr, delay: 1)
            break
        case -2:
            self.show("用户取消", delay: 1)
            break
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "MMPreviewShopViewController"{
            let controller = segue.destination as! MMPreviewShopViewController
            controller.url = URL.init(string: Key.payGoods + order_sn!)
            controller.titles = "支付成功"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
         self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
       self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        
//        if type == LoadingWebviewType.goodsDetails {
//            if self.title == "我的订单" || self.title == "授权登录"   {
//               
//                return true;
//            }
//            if !isOne {
//                if self.title != "支付方式"{
//                    let vC = MMGoodsDetailsViewController()
//                    vC.url = request.URL
//                    log(request.URL)
//                    vC.type = LoadingWebviewType.goodsDetails
//                    self.navigationController?.pushViewController(vC, animated: true)
//                    return false
//                }
//            }
//        
//        }
//        isOne = false
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        
        if type == LoadingWebviewType.goodsDetails {
            
            if self.title == "支付方式"{
                let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
                let jsmodel = MMJSModel()
                jsmodel.event = {[unowned self]  order_sn in
                    
                    self.order_sn = order_sn
                }
                jsmodel.controller = self
                jsmodel.jsContext = context
                context!.setObject(jsmodel, forKeyedSubscript: "xmbapp" as (NSCopying & NSObjectProtocol)!)
                let curUrl = webView.request?.url?.absoluteString  //WebView当前访问页面的链接 可动态注册
                context!.evaluateScript(try? String(contentsOf: URL.init(string: curUrl!)!, encoding: String.Encoding.utf8))
                context!.exceptionHandler =  { (context, exception) in
                    log( exception)
                }
            }
            
            

        }
                self.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        log(error)
        self.dismiss()
        self.show("加载失败", delay: 1);
    }
    
}
