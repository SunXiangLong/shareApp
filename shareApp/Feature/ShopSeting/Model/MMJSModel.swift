//
//  MMJSModel.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/9/22.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import JavaScriptCore
@objc protocol SwiftJavaScriptDelegate:JSExport {
    
    /// JS方法返回支付参数
    ///
    /// - parameter payParameter: 支付参数
    func call_pay(_ payParameter: [String: String])
    func switchTab()
    func showMessage(_ message:String)
    func openWebView(_ parameter:[String: String])
}
@objc class MMJSModel: NSObject,SwiftJavaScriptDelegate {
   
    weak var controller: UIViewController?

    weak var jsContext:JSContext?
    
    var event:((_ order_sn:String) ->Void)?
    var switchtab:(() ->Void)?
    var showmessage:((_ message:String) ->Void)?
    var openWebview:((_ url:String,_ title:String) ->Void)?
    func switchTab() {
        self.switchtab!()
    }
    func showMessage(_ message: String) {
        
        self.showmessage!(message)
    }
    func openWebView(_ parameter:[String: String]) {
        log(parameter)
        self.openWebview!(parameter["url"]!,parameter["title"]!)
    }
    func call_pay(_ payParameter: [String: String]) -> Void {
        
        let order_price = String(Int(Double(payParameter["order_amount"]!)!*100));
        log(payParameter)
         self.event!(payParameter["order_sn"]!)
    
        PayTool.wxPay(["orderName":payParameter["subject"]!,"orderPrice":order_price,"order_sn":payParameter["order_sn"]!],payType: .payGoods)
       
        
    }
}
