//
//  MMOrderDetailsTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMOrderDetailsTableViewController: MMBaseTableViewController {
  var model:myOrderModel?
    var  orderDetailsModel:OrderDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        self.tableView.tableFooterView = UIView()
       
        self.requestDta()
    }

    
    @IBAction func back(_ sender: AnyObject) {
        self.popViewController(animated: true)
    }
    override func requestDta() ->Void{
        
        
        HTTPTool.PostJson(API.orderDetail, parameters: ["token":MMUserInfo.UserInfo.token!,"order_sn":self.model!.order_sn]) { (json, error) in
             log(json)
            
            if json != nil{
              
                self.orderDetailsModel = OrderDetailsModel.init(json: json!["data"])
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
        if orderDetailsModel == nil {
            return 0
        }
        if orderDetailsModel?.shipping_status == "1" {
            return 4;
        }
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return (orderDetailsModel?.order_goods?.count)!
        default:
            return 1
        }
      
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 76
        case 1:
            return 176
        case 2:
            return 91
        default:
            return 68
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
            return 5
    
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.section {
        case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "MMOrderDetailsTableViewOneCell", for: indexPath)as!MMOrderDetailsTableViewOneCell
             cell.model = orderDetailsModel
             return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMOrderDetailsTableViewTwoCell", for: indexPath)as!MMOrderDetailsTableViewTwoCell
            cell.model = orderDetailsModel
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMMyOrderTableViewCell", for: indexPath) as!MMMyOrderTableViewCell
            cell.model = orderDetailsModel?.order_goods![indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMOrderDetailsTableViewThreeCell", for: indexPath)as!MMOrderDetailsTableViewThreeCell
           cell.model = orderDetailsModel
            cell.checkLogistic =  {[unowned self]  model in
                self.performSegue(withIdentifier: "MMCheckLogisticsViewController", sender: indexPath)
            }
            return cell
            
        }
       

}
   
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMCheckLogisticsViewController" {
            let controller = segue.destination as! MMCheckLogisticsViewController
            
           controller.title = "物流追踪"
            controller.url = orderDetailsModel?.shipping_url
            
            
        }
        
    }
    

}
