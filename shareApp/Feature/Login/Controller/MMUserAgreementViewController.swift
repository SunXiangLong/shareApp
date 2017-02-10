//
//  MMUserAgreementViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/2.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import WebKit
class MMUserAgreementViewController: MMBaseViewController,WKNavigationDelegate,WKUIDelegate {

    var webView:WKWebView?
    let  url = URL.init(string: "http://vapi.xiaomabao.com/common/agreement")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户协议"
        self.show()
        
        webView = WKWebView.init(frame:CGRect(x: 0, y: 0, width: screenW, height: screenH ))
       _ = webView?.load(URLRequest.init(url:url!))
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
