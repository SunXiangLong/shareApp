//
//  MMCheckLogisticsViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import WebKit
class MMCheckLogisticsViewController: MMBaseViewController,WKUIDelegate,WKNavigationDelegate {
    var webView:WKWebView?
    var url:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.show()
        self.automaticallyAdjustsScrollViewInsets = false
        webView = WKWebView.init(frame:CGRect(x: 0, y: 0, width: screenW, height: screenH - 64 ))
        _ = webView?.load(URLRequest.init(url: url!))
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.scrollView.bounces = false
        self.view.addSubview(webView!)
        // Do any additional setup after loading the view.
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
