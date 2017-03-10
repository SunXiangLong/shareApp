//
//  MMPreviewShopViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/27.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import WebKit
import KYNavigationProgress
class MMPreviewShopViewController: MMBaseViewController{
    var webView:WKWebView?
    var url = MMUserInfo.UserInfo.shop_preview_url
    var titles = "店铺预览"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        URLCache.shared.removeAllCachedResponses()
        self.title = titles
        webView = WKWebView.init(frame:CGRect(x: 0, y: 0, width: screenW, height: screenH ))
        _ = webView?.load(URLRequest.init(url:url! ))
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func popViewControllerAnimated() {
        
        if webView!.canGoBack {
        _ = webView?.goBack()
        }else{
            
            
            if self.titles == "支付成功" {
                self.popToViewController((self.navigationController?.childViewControllers.first)!, animated: true)
                
            }else{
                self.popViewController(animated: true)
            }
        }
    }

   

}

extension MMPreviewShopViewController :WKNavigationDelegate,WKUIDelegate{

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         self.navigationController?.progress = 0.5
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         self.navigationController?.finishProgress()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.navigationController?.cancelProgress()
        self.show("加载失败", delay: 1);
        
    }

}
