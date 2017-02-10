//
//  MMMethodPaymentViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMMethodPaymentViewController: MMBaseViewController{
    
    @IBOutlet weak var wechatView: AnimatableView!
    @IBOutlet weak var orderAmountFormatted: UILabel!
    @IBOutlet weak var payTreasurePayButton: UIButton!
    @IBOutlet weak var weChatPayButton: UIButton!
    var  object:[String:String]?
    var lastButton:UIButton?
    var phone:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !WXApi.isWXAppInstalled() {
            wechatView.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.wxPayBlock(_:)), name: NSNotification.Name(rawValue: "WxPay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.AlipayPayBlock(_:)), name: NSNotification.Name(rawValue: "AlipayPay"), object: nil)
        self.title = "支付方式"
        lastButton = payTreasurePayButton
      orderAmountFormatted.text =  "   应付金额：" + object!["order_amount_formatted"]!
    }

    @IBAction func payChoose(_ sender: UIButton) {
        
        if !sender.isSelected {
            lastButton?.isSelected = !(lastButton?.isSelected)!
            lastButton = sender
            lastButton?.isSelected = !(lastButton?.isSelected)!
        }
       
    }
    
    @IBAction func payment(_ sender: AnyObject) {
        self.pay(lastButton!)
        
    }
     ///微信支付结果的回调
    func wxPayBlock(_ notif:Notification) -> Void {
        let resp = notif.userInfo!["resp"] as!BaseResp
        switch resp.errCode {
        case 0:
            self.requestDta()
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
    func AlipayPayBlock(_ notif:Notification) -> Void {
        let dic = notif.userInfo as![String:String]
        
        log( dic);
        self.alipayBlock(dic)
    }
    ///支付宝支付结果的回调
    func alipayBlock(_ dic:[String:String]) -> Void {
        let resultStatus = dic["resultStatus"]
        let memo = dic["memo"]
        switch resultStatus! {
        case "9000":
            let alertController = UIAlertController.init(title: "支付成功",message: nil, preferredStyle:.alert)
            alertController.addAction(UIAlertAction.init(title: "确定", style:  .default, handler: {[unowned self]  action in
                self.requestDta()
                
                }))
            self.present(alertController, animated: true, completion: nil)

            break
        
       
        default:
            let alertController = UIAlertController.init(title: "支付未成功",message: memo!, preferredStyle:.alert)
            alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            break
        }
        
    }
    ///发起支付
   func pay(_ sender: AnyObject) {
        let order_price = String(Int(Double(object!["order_amount"]!)!*100))
        switch sender.tag {
        case 1:
         
            PayTool.wxPay(["orderName":"微店大礼包","orderPrice":order_price,"order_sn":object!["order_sn"]!],payType: .payGoodieBag)
            break
        case 0:

            PayTool.zfbPay(object!["ali_sign"]!, block: { (resultDic) in
                let dic = resultDic as![String:String]
                self.alipayBlock(dic)
                
            })
            break
        default:
            break
        }
        
    }
    override func requestDta() {
        
        HTTPTool.Post(API.getShopCode, parameters: ["mobile": phone!,"order_sn":object!["order_sn"]!]) { (model, error) in
            
            
            if model != nil{
                
                log("object=====\(model?.data)")
                if  model?.status  == (1){
                    
                    self.performSegue(withIdentifier: "MMPayResultsViewController", sender: model?.data?.dictionaryObject)
                }
                
                
            }else{
                
                log("erro == \(error)")
                
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMPayResultsViewController" {
            let vc = segue.destination as! MMPayResultsViewController
            let dic = sender as! [String:String]
            vc.code =   dic["code"]
        }
        
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
