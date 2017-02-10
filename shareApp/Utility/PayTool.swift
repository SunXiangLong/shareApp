//
//  PayTool.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
final class PayTool {
    
    /***微信支付*/
    class func  wxPay(_ param:[String:String],payType:PayType) ->Void {
        let req =     payRequsestHandler.init()
        req.sxl(APP_ID, mch_id: MCH_ID)
        req.setKey(PARTNER_ID)
        let order_name =  param["orderName"]
        let order_price = param["orderPrice"]
        let noncestr = String(arc4random())
        let orderno =   param["order_sn"]
        var notify_url:String?
        switch payType {
        case .payGoods:
            notify_url = NOTIFY_URL_goods
        case .payGoodieBag:
           notify_url = NOTIFY_URL
        
        }
        let packageParams:NSMutableDictionary = [
            "appid":APP_ID,
            "mch_id":MCH_ID,
            "device_info":"APP-001",
            "nonce_str":noncestr,
            "trade_type":"APP",
            "body":order_name!,
            "notify_url":notify_url!,
            "out_trade_no":orderno!,
            "spbill_create_ip":"196.168.1.1",
            "total_fee":order_price!,
            "attach":orderno!
        ]
        var dict:NSMutableDictionary?
        
        let prePayid = req.sendPrepay(packageParams) as String
        
        
        let package = "Sign=WXPay"
        var noew = time_t()
        let time_stamp = String(time(&noew))
        let nonce_str = WXUtil.md5(time_stamp) as String
        let signParams:NSMutableDictionary = [
            "appid":APP_ID,
            "noncestr":nonce_str,
            "package":package,
            "partnerid":MCH_ID,
            "timestamp":time_stamp,
            "prepayid":prePayid
        ]
        let sign = req.createMd5Sign(signParams) as String;
        signParams.setObject(sign, forKey: "sign" as NSCopying)
        dict = NSMutableDictionary.init(dictionary: signParams)
        if dict == nil {
            let debug = req.getDebugifo()
            log(debug)
        }else{
            let stamp = dict?.object(forKey: "timestamp")
            let req = PayReq.init()
            req.openID  = dict!.object(forKey: "appid") as!String
            req.partnerId     = dict!.object(forKey: "partnerid") as!String
            req.prepayId      = dict!.object(forKey: "prepayid") as!String
            req.nonceStr      = dict!.object(forKey: "noncestr")as!String
            req.timeStamp     =  UInt32( (stamp! as AnyObject).int32Value)
            req.package         = dict!.object(forKey: "package")as!String
            req.sign          = dict!.object(forKey: "sign")as!String
            WXApi .send(req)
            
        }
        
    }

    
    
    /*** 支付宝支付*/
    class func  zfbPay(_ ali_sign:String,block:@escaping CompletionBlock) ->Void {
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
       let appScheme = "MaMi";
        AlipaySDK.defaultService().payOrder(ali_sign, fromScheme: appScheme, callback: block)
    }
}
