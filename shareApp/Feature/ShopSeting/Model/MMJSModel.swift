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
    func call_pay(_ payParameter: [String: AnyObject])
}
@objc class MMJSModel: NSObject,SwiftJavaScriptDelegate {
   
    weak var controller: UIViewController?

    weak var jsContext:JSContext?
    
    var event:((_ order_sn:String) ->Void)?
    
    func call_pay(_ payParameter: [String: AnyObject]) -> Void {
        let order_price = String(Int(Double(payParameter["order_amount"]! as! String)!*100));
        
        PayTool.wxPay(["orderName":payParameter["subject"]! as! String,"orderPrice":order_price,"order_sn":payParameter["order_sn"]! as! String],payType: .payGoods)
        self.event!(payParameter["order_sn"]! as! String)
        log(payParameter)
    }
}
