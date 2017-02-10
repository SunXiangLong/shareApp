//
//  MMWithdrawalRecordTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/27.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import  MJRefresh
class MMWithdrawalRecordTableViewController: MMBaseTableViewController {
    
    @IBOutlet var noDataView: UIView!
    
    var page = 1
    var profitModel:profitWithdrawRecord?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现记录"
        self.UI()
        
        
    }
    func UI() -> Void {
        
        noDataView.frame = CGRect(x: 0, y: 64, width: screenW, height: screenH - 64)
        noDataView.isHidden = true
        self.view.addSubview(noDataView)
        self.tableView.tableFooterView = UIView()
        self.requestDta()
        ///上拉加载
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
    }
    override func requestDta() -> Void {
        HTTPTool.PostJson(API.profitWithdrawRecord, parameters: ["token":MMUserInfo.UserInfo.token!,"page": String(page)]) { (json, error) in
            self.tableView.mj_footer.endRefreshing()
            if let json = json {
                if json["data"].array!.count == 0{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                if self.page == 1{
                    if json["data"].array!.count > 0{
                        self.profitModel = profitWithdrawRecord.init(json: json)
                        self.tableView.reloadData()
                    }
                    
                    if self.profitModel == nil{
                        self.tableView.mj_footer.removeFromSuperview()
                        self.noDataView.isHidden = false
                    }
                    
                }else{

                    self.profitModel!.data = self.profitModel!.data + json["data"].array!.map{
                    withdrawalRecordModel.init(json: $0)
                    }
                    self.tableView.reloadData()
                
                }
                 self.page = self.page + 1
            }
            
        }
        
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.profitModel == nil {
            return 0
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return (self.profitModel?.data.count)!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMWithdrawalRecordTableViewCellOne", for: indexPath)as!MMWithdrawalRecordTableViewCellOne
            
            cell.model = self.profitModel
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMWithdrawalRecordTableViewCellTwo", for: indexPath) as!MMWithdrawalRecordTableViewCellTwo
        
        cell.model = self.profitModel?.data[indexPath.row]
        
        return cell
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
