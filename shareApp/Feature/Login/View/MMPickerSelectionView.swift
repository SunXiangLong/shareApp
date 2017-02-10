//
//  MMAddressSelectionView.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
class MMPickerSelectionView: UIView {

    @IBOutlet weak var pickerView: UIPickerView!
    /// 省份选择 记录
    var provinceIndex = 0
    /// 市选择 记录
    var cityIndex = 0
    /// 区选择 记录
    var districtIndex = 0
    /// 银行悬着记录
    var depositBankIndex = 0
    ///类型
    var pickviewType:pickViewType?{
        didSet{
        pickerView.reloadAllComponents()
        }
    }
    ///确定回调
    var determineChoice:((_ dic:[String:String
    ]?,_ type:pickViewType) ->Void)?
    
    lazy  var dataArr:NSArray = {
        let diaryList = Bundle.main.path(forResource: "Province.plist", ofType:nil)!
        let dataArr = NSArray(contentsOfFile:diaryList)
        
        return dataArr!
    }()
    

    var depositBankAarr = ["中国银行","中国工商银行","中国建设银行","中国农业银行","招商银行","交通银行"]
    override func awakeFromNib() {
    
    }
    
    @IBAction func Determine(_ sender: AnyObject) {
        
        if pickviewType == pickViewType.address {
         
            let dic = dataArr[provinceIndex] as! [String:AnyObject];
            let province = dic["province"] as! String
            
            let cityArr = dic["citys"] as! NSArray
            
            let cityDic = cityArr[cityIndex]as! [String:AnyObject];
            let city = cityDic["city"]as!String
            
            let districtArr =  cityDic["districts"] as! NSArray
            let district = districtArr[districtIndex] as! String
            
            determineChoice!(["province":province,"city":city,"district":district],pickViewType.address)
            
        }else{
            let   depositBanktext = depositBankAarr[depositBankIndex]
             determineChoice!(["depositBank":depositBanktext],pickViewType.depositBank)
            
        }
    }

    @IBAction func cancel(_ sender: AnyObject) {
         determineChoice!(nil,pickViewType.cancle)
        
    }
    
    
    ///刷新pickView
    func resetPickerSelectRow() -> Void {
        
        if pickviewType == pickViewType.address {
            pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
            pickerView.selectRow(cityIndex, inComponent: 1, animated: true)
            pickerView.selectRow(districtIndex, inComponent: 2, animated: true)
            
        }else{
            
            pickerView .selectRow(depositBankIndex, inComponent: 0, animated: true)
            
        }
            
        
        
    }

    // MARK: - UIPickerViewDelegate  UIPickerViewDataSource
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        if pickviewType == pickViewType.address {
            return 3
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let dic = dataArr[provinceIndex] as! [String:AnyObject]
        let cityArr = dic["citys"] as! NSArray
        let cityDic = cityArr[cityIndex]as! [String:AnyObject];
        let districtArr =  cityDic["districts"] as! NSArray
        if pickviewType == pickViewType.address {
            switch component {
            case 0:
                return dataArr.count
            case 1:
                
                
                return cityArr.count
            default:
                
                return districtArr.count
                
            }
        }else{
            return depositBankAarr.count
            
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dic = dataArr[provinceIndex] as! [String:AnyObject]
        let cityArr = dic["citys"] as! NSArray
        let cityDic = cityArr[cityIndex]as! [String:AnyObject];
        let districtArr =  cityDic["districts"] as! NSArray
        if pickviewType == pickViewType.address {
            
            switch component {
            case 0:
                let provinceDic = dataArr[row] as! [String:AnyObject]
                return  provinceDic["province"] as? String
            case 1:
                let city = cityArr[row]as! [String:AnyObject];
                return city["city"] as?String
            default:
                
                
                return districtArr[row] as? String
            }
        }else{
            
            return depositBankAarr[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickviewType == pickViewType.address {
            
            switch component {
            case 0:
                provinceIndex = row
                cityIndex = 0
                districtIndex = 0
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
                break
            case 1:
                cityIndex = row
                districtIndex = 0
                pickerView.reloadComponent(2)
                break
            default:
                districtIndex = row
                break
            }
        }else{
            
            depositBankIndex = row
            
            
        }
        
        
        self.resetPickerSelectRow()
    }
}
