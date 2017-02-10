//
//  UseHelpVC.swift
//  shareApp
//
//  Created by xiaomabao on 2016/12/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class UseHelpVC: MMBaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "共享豆使用协议"
        self.automaticallyAdjustsScrollViewInsets = false;
        let request = URLRequest.init(url: URL.init(string: API.commonBean)!)
        self.show()
        webView.loadRequest(request);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UseHelpVC:UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.dismiss()
    }

}
