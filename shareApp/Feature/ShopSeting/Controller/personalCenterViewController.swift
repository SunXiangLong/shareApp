//
//  personalCenterViewController.swift
//  shareApp
//
//  Created by xiaomabao on 2017/3/8.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit

class personalCenterViewController: MMBaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
         URLCache.shared.removeAllCachedResponses()
        webView.loadRequest(URLRequest.init(url: MMUserInfo.UserInfo.ucenter_url))
        
        let  backBtn1 = UIButton.init(type: .custom)
        backBtn1.frame = CGRect(x: 0, y: 0, width: 30, height: 44);
        backBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        backBtn1.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        backBtn1.setImage(UIImage.init(named: "goback"), for: UIControlState())
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem.init(customView: backBtn1))

        // Do any additional setup after loading the view.
    }
    func goBack(){
        if  (webView?.canGoBack)!{
            webView?.goBack()
        }else{
            self.popViewControllerAnimated()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        self.title = "个人中心"
        
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension personalCenterViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigationController?.progress = 0.5
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.navigationController?.cancelProgress()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.navigationController?.finishProgress()
         self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
//        let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
//        let jsmodel = MMJSModel()
//        
//        jsmodel.switchtab = {[unowned self] in
//            DispatchQueue.main.async(execute: {
//                self.tabBarController?.selectedIndex = 0
//            })
//            
//        }
//        jsmodel.openWebview = { [unowned self] (url,title)in
//            DispatchQueue.main.async(execute: {
//                
//                let VC = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "shoppingCartViewController") as!shoppingCartViewController
//                VC.url = url
//                VC.title = title
//                VC.backBtnisHidden = false
//                self.navigationController?.pushViewController(VC, animated: true)
//            })
//            
//        }
//        jsmodel.event = {[unowned self]  order_sn in
//            
//            self.order_sn = order_sn
//        }
//        jsmodel.controller = self
//        jsmodel.jsContext = context
//        context!.setObject(jsmodel, forKeyedSubscript: "xmbapp" as (NSCopying & NSObjectProtocol)!)
//        let curUrl = webView.request?.url?.absoluteString  //WebView当前访问页面的链接 可动态注册
//        context!.evaluateScript(try? String(contentsOf: URL.init(string: curUrl!)!, encoding: String.Encoding.utf8))
//        context!.exceptionHandler =  { (context, exception) in
//            log( exception)
//        }
    }
}
