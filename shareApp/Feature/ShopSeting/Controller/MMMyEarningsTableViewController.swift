//
//  MMMyEarningsTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/26.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftyJSON
class profitInfoModel {
    ///正在提现
    var presenting_withdraw: String!
    ///待收收益
    var waiting_profit: String!
     ///已提现金额
    var presented_withdraw: String!
    ///可提现余额
    var available_balance: String!
    init(json:JSON){
        presenting_withdraw = json["presenting_withdraw"].string
        waiting_profit = json["waiting_profit"].string
        presented_withdraw = json["presented_withdraw"].string
        available_balance = json["available_balance"].string
        MMUserInfo.UserInfo.available_balance = available_balance
    
    
    }

}
class MMMyEarningsTableViewController: MMBaseTableViewController {
    
    @IBOutlet var withdrawalButton: UIButton!
    @IBOutlet weak var withdrawalAmountLabel: CountingLabel!
    let dataArr = ["正在提现","待收收益","我的共享豆","提现纪录"]
    var profitModel:profitInfoModel?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.requestDta()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收益"
        
        self.withdrawalButton.frame = CGRect(x: 0, y: screenH - 50-64, width: screenW, height: 50);
        self.view.addSubview(self.withdrawalButton)
      
    }
     
    @IBAction func back(_ sender: AnyObject) {
        self.popViewController(animated: true)
    }
    @IBAction func withdrawalAmountLabel(_ sender: AnyObject) {
        if  MMUserInfo.UserInfo.card_bind_status!{
            
            self.performSegue(withIdentifier: "MMApplyWithdrawViewController", sender: nil)
        }else{
            self.performSegue(withIdentifier: "MMBindBanKCardViewController", sender: nil)
        
        }
    }
    
    /**请求我的收益*/
    override func requestDta() ->Void{
        
        HTTPTool.Post(API.shopProfitInfo, parameters: ["token":MMUserInfo.UserInfo.token!]) { (model, error) in
            
            if model != nil{
       
                self.profitModel = profitInfoModel.init(json: (model?.data)!);

                self.withdrawalAmountLabel.text = "0.00"
                self.withdrawalAmountLabel.format = "%.2f"
                self.withdrawalAmountLabel.countFrom(fromNum: 0.00, toNum: NSNumber.init(value: Double.init(self.profitModel!.available_balance)! as Double), duration: 0.8)
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 5
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 5))
        
        return headView
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMSetUpTableViewOneCell", for: indexPath) as!MMSetUpTableViewOneCell
        cell.nameLabel.text = dataArr[indexPath.section]
        switch indexPath.section {
        case 0:
            cell.versionLabel.text =  profitModel != nil ? profitModel!.presenting_withdraw : ""
            break
        case 1:
            cell.versionLabel.text = profitModel != nil ? profitModel!.waiting_profit : ""
            break
        case 2:
            cell.accessoryType = .disclosureIndicator
            cell.versionLabel.text = ""
            break
        default:
            break
        }
     
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            self.performSegue(withIdentifier: "MMWithdrawalRecordTableViewController", sender: nil)
        }else if indexPath.section == 2{
            self.performSegue(withIdentifier: "shareBeansVC", sender: nil)
        }
        
    }

}
