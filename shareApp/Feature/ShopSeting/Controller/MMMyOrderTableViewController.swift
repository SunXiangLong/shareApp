//
//  MMMyOrderTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/28.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
class MMMyOrderTableViewController: MMBaseTableViewController {
    var orderModeArray:[myOrderModel]? = []
    var model:orderOrderModel?
    @IBOutlet var noDataView: UIView!

    var page = 1
    var order_sn = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(39, 0, 0, 0)
        self.tableView.tableFooterView = UIView()
        ///没有数据提示
        noDataView.frame = CGRect(x: 0, y: 39, width: screenW, height: screenH - 39)
        noDataView.isHidden = true
        self.view.addSubview(noDataView)
        self.requestDta()
        
        ///   上拉加载
//        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
        
    }
    override func requestDta() ->Void{
     
        self.show()
        HTTPTool.PostNoHUD(API.orderOrderList, parameters: ["token":MMUserInfo.UserInfo.token! as AnyObject,"order_type":self.model!.order_type_code,"page":String(page),"order_sn":order_sn]) { (model, error) in
            self.dismiss()
            if self.page == 1 {
                self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            if let  model = model{
                //                log(model?.data)
                if model.data!.array!.count > 0{
                    for orderModel in model.data!.array!{
                        let order = myOrderModel.init(json: orderModel)
                        self.orderModeArray?.append(order)
                        self.tableView.reloadData()
                        self.page = self.page + 1
                        
                    }
                    
                }else{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
                if self.orderModeArray!.count == 0{
                    self.tableView.mj_footer.removeFromSuperview()
                    self.noDataView.isHidden = false
                    
                }
                
            }

        }
//        HTTPTool.Post(API.orderOrderList, parameters: ["token":MMUserInfo.UserInfo.token! as AnyObject,"order_type":self.model!.order_type_code,"page":String(page),"order_sn":order_sn]) { (model, error) in
//            
//            if let  model = model{
////                log(model?.data)
//                if model.data!.array!.count > 0{
//                    for orderModel in model.data!.array!{
//                        let order = myOrderModel.init(json: orderModel)
//                        self.orderModeArray?.append(order)
//                        self.tableView.reloadData()
//                        self.page = self.page + 1
//                        
//                    }
//                    
//                }else{
//                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                }
//            
//                if self.orderModeArray!.count == 0{
//                    self.tableView.mj_footer.removeFromSuperview()
//                     self.noDataView.isHidden = false
//                    
//                }
//                
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (orderModeArray?.count)!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let model = orderModeArray![section]
        
        return model.order_goods.count
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("MMMyOrderTableFootView", owner: nil, options: nil)!.last as!MMMyOrderTableFootView
        view.frame = CGRect(x: 0, y: 0, width: screenW, height: 50)
        view.model  = orderModeArray![section]
        view.detailsJump = {[unowned self]  (model) in
            self.performSegue(withIdentifier: "MMOrderDetailsTableViewController", sender: model)
        }
        return view
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("MMMyOrderTableHeadView", owner: nil, options: nil)!.last as!MMMyOrderTableHeadView
        view.frame = CGRect(x: 0, y: 0, width: screenW, height: 56)
        view.model  = orderModeArray![section]
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMMyOrderTableViewCell", for: indexPath)as!MMMyOrderTableViewCell
        let model = orderModeArray![indexPath.section]
        cell.model = model.order_goods[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMOrderDetailsTableViewController" {
             let controller = segue.destination as! MMOrderDetailsTableViewController
             controller.model = sender as? myOrderModel
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
