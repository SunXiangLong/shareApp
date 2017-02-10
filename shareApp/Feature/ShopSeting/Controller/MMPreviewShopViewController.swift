//
//  MMPreviewShopViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/27.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import WebKit
class MMPreviewShopViewController: MMBaseViewController,WKNavigationDelegate,WKUIDelegate{
    var webView:WKWebView?
    var url = MMUserInfo.UserInfo.shop_preview_url
    var titles = "店铺预览"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = titles
        webView = WKWebView.init(frame:CGRect(x: 0, y: 0, width: screenW, height: screenH ))
        _ = webView?.load(URLRequest.init(url:url! ))
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
       
        self.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func popViewControllerAnimated() {
        
        if webView!.canGoBack {
        _ = webView?.goBack()
        }else{
            self.popViewController(animated: true)
            
            if self.titles == "支付成功" {
                self.navigationController?.childViewControllers.forEach{
                    if $0.isKind(of: MMTabPageViewController.classForKeyedArchiver()!)||$0.isKind(of: MMTabPageViewController.classForKeyedArchiver()!){
                        self.popToViewController($0, animated: true)
                    }
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismiss()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        log(error)
        self.show("加载失败", delay: 1);
        
    }

}
