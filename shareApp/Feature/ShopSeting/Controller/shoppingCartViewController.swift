//
//  shoppingCartViewController.swift
//  shareApp
//
//  Created by xiaomabao on 2017/3/6.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import JavaScriptCore
import KYNavigationProgress
class shoppingCartViewController: MMBaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsNum: UILabel!
    @IBOutlet weak var allSelectedBtn: UIButton!
    @IBOutlet weak var settlementBtn: UIButton!
    var url :String?
    var backBtnisHidden = true
    var isNotification  = false
    var order_sn:String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if let _ = MMUserInfo.UserInfo.token{
            if url == nil {
                
                url =   MMUserInfo.UserInfo.cart_url.absoluteString
            }
            
        }else{
            URLCache.shared.removeAllCachedResponses()
            url =  API.cartUrl
        }
        
        log(url);
        
        webView.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let  backBtn1 = UIButton.init(type: .custom)
        backBtn1.frame = CGRect(x: 0, y: 0, width: 30, height: 44);
        backBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        backBtn1.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        backBtn1.setImage(UIImage.init(named: "goback"), for: UIControlState())
        self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem.init(customView: backBtn1))
        //        tableView.tableFooterView = UIView()
        if isNotification{
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.wxPayBlock(_:)), name: NSNotification.Name(rawValue: "WxPay"), object: nil)
        }
        
        backBtn?.isHidden = backBtnisHidden
        backBtn1.isHidden = backBtnisHidden
        // Do any additional setup after loading the view.
    }
    
    func goBack(){
        if  (webView?.canGoBack)!{
            webView?.goBack()
        }else{
            self.popViewControllerAnimated()
        }
    }
    @IBAction func settlement(_ sender: UIButton) {
        
    }
    
    @IBAction func allSelected(_ sender: UIButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///微信支付结果的回调
    func wxPayBlock(_ notif:Notification) -> Void {
        log(notif)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension shoppingCartViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigationController?.progress = 0.5
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.navigationController?.cancelProgress()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.navigationController?.finishProgress()
        
        let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let jsmodel = MMJSModel()
        
        jsmodel.switchtab = {[unowned self] in
            DispatchQueue.main.async(execute: {
            
                self.tabBarController?.selectedIndex = 0
            })
            
        }
        jsmodel.openWebview = { [unowned self] (url,title)in
            DispatchQueue.main.async(execute: {

                let VC = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "shoppingCartViewController") as!shoppingCartViewController
                VC.url = url
                VC.title = title
                VC.backBtnisHidden = false
                VC.isNotification   = true
                self.navigationController?.pushViewController(VC, animated: true)
            })
            
        }
        jsmodel.event = {[unowned self]  order_sn in
            self.order_sn = order_sn
            log(self.order_sn)
            
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
//extension shoppingCartViewController : UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 110
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCartCell", for: indexPath) as! shoppingCartCell
//        
//        
//        return cell
//    }
//    
//    
//    
//    
//}
