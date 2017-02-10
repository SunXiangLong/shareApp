//
//  MMImmediatelyOpenShopViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMImmediatelyOpenShopViewController: MMBaseViewController {

    @IBOutlet weak var receiptUserTextfield: AnimatableTextField!
    @IBOutlet weak var receiptPhoneTextfield: AnimatableTextField!
    @IBOutlet weak var provinceNameTextField: AnimatableTextField!
    @IBOutlet weak var receiptCodeTextField: AnimatableTextField!
    @IBOutlet weak var districtNameTextField: AnimatableTextField!
    @IBOutlet weak var cityNameTextField: AnimatableTextField!
    @IBOutlet weak var receiptAddressTextField: AnimatableTextField!
    @IBOutlet weak var codeButton: AnimatableButton!
    @IBOutlet weak var heightConstriaint: NSLayoutConstraint!
    @IBOutlet var pickView: MMPickerSelectionView!
    
    var countdownTimer: Timer?
    
    lazy var maskView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 64, width: screenW, height: screenH-64))
        view.backgroundColor = Color.black
        view.alpha = 0
        return view
        
    }()
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 30
                
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                codeButton.backgroundColor = Color.white
            }
            
            codeButton.isEnabled = !newValue
        }
    }
    var remainingSeconds: Int = 0 {
        willSet {
            codeButton.setTitle("\(newValue)秒", for: .normal)
            
            if newValue <= 0 {
                codeButton.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = Color.white
        self.title = "立即开店"
        heightConstriaint.constant = 0.5
        
    }

    ///选择地址（省市区）
    @IBAction func selectAddress(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.accordMyPicker()
        
    }
    @IBAction func sendButtonClick(_ sender: AnyObject) {
        
         self .sendCode()
     
    }
    ///去支付
    @IBAction func payButton(_ sender: AnyObject) {
        
        self.requestDta()
    }
    ///加载pickView
    func accordMyPicker() -> Void {
        pickView.pickviewType = pickViewType.address
        pickView.determineChoice = { [unowned self]   (dic,type) in
            switch type {
            case .cancle:
                self.cancel()
                break
            case .address:
                self.cancel()
                self.provinceNameTextField.text = dic!["province"]
                self.cityNameTextField.text = dic!["city"]
                self.districtNameTextField.text = dic!["district"]
                break
            default:
                break
            }
        
        }
        self.view.addSubview(self.maskView)
        self.view.addSubview(pickView)
        self.pickView.sxl_width = screenW
        self.pickView.sxl_y = screenH
        maskView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.cancel)))
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha   = 0.3
            self.pickView.sxl_y = self.pickView.sxl_y - self.pickView.sxl_height
        }) 
        pickView.pickerView.reloadAllComponents()
    }
       ///隐藏pickView
    func cancel() ->Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0
            self.pickView.sxl_y = screenH
        }, completion: { (finished) in
            self.maskView.removeFromSuperview()
            self.pickView.removeFromSuperview()
        }) 
    }
    func updateTime(_ timer: Timer) ->Void {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    ///获取手机验证码
    func sendCode() -> Void {
        self.view.endEditing(true)
        
        HTTPTool.Post(API.sendCode, parameters: ["phone":receiptPhoneTextfield.text!]) { (model, error) in
            
            
            if model != nil{
                
                log("object=====\(model?.data)")
                if  model?.status  == (1){
                    
                    self.show((model?.info)!+",请等待", delay: 1.5)
                    // 启动倒计时
                    self.isCounting = true
                }
                
                
            }else{
                
                log("erro == \(error)")
                
            }
        }
        
        
    }
    ///提交表单数据-->进行支付
    override func requestDta() {
        HTTPTool.Post(API.applyShopCode, parameters: ["receipt_user":receiptUserTextfield.text!,"receipt_code":receiptCodeTextField.text!,"province_name":provinceNameTextField.text!,"city_name":cityNameTextField.text!,"district_name":districtNameTextField.text!,"receipt_address":receiptAddressTextField.text!,"receipt_phone":receiptPhoneTextfield.text!]) { (model, error) in
            
            
            if model != nil{
                
                log("object=====\(model?.data)")
                if  model?.status  == (1){
                    self.performSegue(withIdentifier: "MMMethodPaymentViewController", sender: model?.data?.dictionaryObject)
                    
                }
                
                
            }else{
                
                log("erro == \(error)")
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMMethodPaymentViewController" {
            let vc = segue.destination as! MMMethodPaymentViewController
            vc.object = sender as?[String:String]
            vc.phone = receiptPhoneTextfield.text!
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
