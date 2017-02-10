//
//  MMBindBanKCardViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/26.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftyJSON

class MMBindBanKCardViewController: MMBaseViewController,UITextFieldDelegate{
    @IBOutlet weak var realNameTextField: AnimatableTextField!
    @IBOutlet weak var countyTextField: AnimatableTextField!
    @IBOutlet weak var cityTextField: AnimatableTextField!
    @IBOutlet weak var provincesTextField: AnimatableTextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var depositBanktextField: AnimatableTextField!
    @IBOutlet weak var branchBankTextField: AnimatableTextField!
    @IBOutlet weak var cardNoTextField: AnimatableTextField!
    @IBOutlet weak var mobilePhoneTextField: AnimatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstraint.constant = 0.4
        self.title = "绑定银行卡"
        
        
    }
    
    @IBAction func bind(_ sender: AnyObject) {
        self.requestDta()
        
    }
    override func requestDta() {
        
        HTTPTool.Post(API.profitBind_card, parameters: ["token":MMUserInfo.UserInfo.token!,"real_name":realNameTextField.text!,"province_name":provincesTextField.text!,"city_name":cityTextField.text!,"district_name":countyTextField.text!,"deposit_bank":depositBanktextField.text!,"branch_bank":branchBankTextField.text!,"card_no":cardNoTextField.text!,"mobile_phone":mobilePhoneTextField.text!]) { (model, error) in
            
            if model != nil{
                if model?.status == (1){
                    
                    self.show(model?.info, delay: 1)
                    MMUserInfo.UserInfo.branch_bank = model?.data!["branch_bank"].string
                    MMUserInfo.UserInfo.card_no = model?.data!["card_no"].string
                    MMUserInfo.UserInfo.card_bind_status = true
                    MMUserInfo.UserInfo.real_name = model?.data!["real_name"].string
                    MMUserInfo.UserInfo.deposit_bank = model?.data!["deposit_bank"].string
                    self.performSegue(withIdentifier: "MMApplyWithdrawViewController", sender: nil)
                }
                
                
            }
            
        }
        
    }
    // MARK: - pickView
    @IBOutlet var pickerView: MMPickerSelectionView!
    
    lazy var maskView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 64, width: screenW, height: screenH-64))
        view.backgroundColor = Color.black
        view.alpha = 0
        return view
        
    }()
    
    ///选择所在地地址
    @IBAction func address(_ sender: AnyObject) {
        self.view.endEditing(false)
        self.accordMyPicker(.address)
        
    }
    ///选择开户行
    @IBAction func depositBank(_ sender: AnyObject) {
        self.view.endEditing(false)
        self.accordMyPicker(.depositBank)
        
    }
    
    ///加载pickView
    func accordMyPicker(_ type:pickViewType) -> Void {
        self.view.addSubview(self.maskView)
        self.view.addSubview(pickerView)
        
        self.pickerView.sxl_width = screenW
        self.pickerView.sxl_y = screenH
        self.pickerView.pickviewType = type
     
        self.pickerView.determineChoice = {[unowned self]  (dic,pickType) in
            switch type {
            case .address:
                switch pickType {
                case .address:
                    self.camcel()
                    self.provincesTextField.text = dic!["province"]
                    self.cityTextField.text = dic!["city"]
                    self.countyTextField.text = dic!["district"]
                    break
                case .cancle:
                    self.camcel()
                    break
                default:
                    break
                }
                break
            case .depositBank:
                switch pickType {
                case .depositBank:
                    self.camcel()
                    self.depositBanktextField.text = dic!["depositBank"]
                    break
                case .cancle:
                    self.camcel()
                    break
                default:
                    break
                }
                
                break
            default:
                break
            }
            
        }
        maskView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.camcel)))
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha   = 0.3
            self.pickerView.sxl_y = self.pickerView.sxl_y - self.pickerView.sxl_height
        }) 
        
    }
    ///隐藏pickView
    func camcel() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0
            self.pickerView.sxl_y = screenH
        }, completion: { (finished) in
            self.maskView.removeFromSuperview()
            self.pickerView.removeFromSuperview()
        }) 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // MARK: - UIPickerViewDelegate  UIPickerViewDataSource
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        
        return false
        
    }
}
