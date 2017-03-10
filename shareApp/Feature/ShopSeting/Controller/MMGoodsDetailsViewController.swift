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
import KYNavigationProgress
class MMGoodsDetailsViewController: MMBaseViewController{
    var web:UIWebView?
    var url:URL?
    var isMyShop = false
    var type:LoadingWebviewType?
    var  brandModel:MMBrandModel?
    
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
        
        let  backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 44);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        backBtn.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "goback"), for: UIControlState())
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem.init(customView: backBtn))
        
        if type == LoadingWebviewType.eventWebsite {
            
            self.rightBtn!.setImage(#imageLiteral(resourceName: "mm_share1"),for:UIControlState())
            self.rightBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        }
        
        if type == LoadingWebviewType.eventWebsite {
            web = UIWebView.init()
            web?.frame =  CGRect(x: 0, y: 0, width: screenW, height: screenH - 64)
            web?.loadRequest(URLRequest.init(url: url!))
            web?.delegate = self
            web?.scalesPageToFit = true
            self.view.addSubview(web!)
            self.rightBtn!.setImage(UIImage.init(named:"mm_share1"),for:UIControlState())
            self.rightBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            shareImageVIew.setImage(brandModel?.banner, image: #imageLiteral(resourceName: "mm_defaultAvatar"))
            
            
        }else if(type == LoadingWebviewType.goodsDetails){
            var frame = CGRect(x: 0, y: 0, width: screenW, height: screenH - 64)
             
            if isMyShop {
                
                frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
            }
            let requst = NSMutableURLRequest(url: url!)
//          设置请求方法为POST
            web = UIWebView.init(frame:frame)
            requst.httpMethod = "POST"
            web?.delegate = self
            web?.scalesPageToFit = true
            // 设置请求参数
//            requst.httpBody = "token=\(MMUserInfo.UserInfo.token!)&device_id=\(UUID())".data(using: String.Encoding.utf8)
            web?.loadRequest(requst as URLRequest);
            self.view.addSubview(web!)
        }
//        self.show()
       
    }
    func goBack(){
        if  (web?.canGoBack)!{
            web?.goBack()
        }else{
            self.popViewControllerAnimated()
        }
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
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension MMGoodsDetailsViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigationController?.progress = 0.5
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
        self.navigationController?.finishProgress()
        self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        
        if type == LoadingWebviewType.goodsDetails {
            let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
            let jsmodel = MMJSModel()
            
            jsmodel.showmessage = {[unowned self]  ( message ) in
                DispatchQueue.main.async(execute: {
//                    let aleview = UIAlertView.init(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
//                    aleview.show()
                    self.show(message, delay: 0.5);
                    self.popViewControllerAnimated();
                })
              
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
//        self.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        log(error)
        self.navigationController?.cancelProgress()
//        self.dismiss()
//        self.show("加载失败", delay: 1);
    }}
