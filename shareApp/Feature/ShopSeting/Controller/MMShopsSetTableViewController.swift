//
//  MMShopsSetTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
class MMShopsSetTableViewController: MMBaseTableViewController{
    var shopimagetype:shopImageType?
    var indexPath:IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺设置"

    }
    override func popViewControllerAnimated() -> Void {
        self.popViewController(animated: true)
    }

    @IBAction func addNewStoreButton(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "MMShopSetTableViewController", sender:nil)
    }
    /// 删除分享店铺
    func deleteShare(_ indexPath:IndexPath) -> Void {
        self.show()
        let model = MMUserInfo.UserInfo.shareInfo[indexPath.row]
        HTTPTool.PostNoHUD(API.shopDeleteShare, parameters: ["token":MMUserInfo.UserInfo.token!,"share_id":model.id]) { (model, error) in
            self.dismiss()
            if model != nil{
                log("dic=====\(model?.data)")
                if model?.status == (1){
                    self.show(model?.info , delay: 1)
                    MMUserInfo.UserInfo.shareInfo.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }else{
                log("erro == \(error)")
                self.show("请求失败", delay: 1)
                
            }
        }
    }
    /// 设置默认分享店铺
    ///
    /// - parameter indexPath: indexPath
    func setDefault(_ indexPath:IndexPath) -> Void {
        self.show()
        let sharModel = MMUserInfo.UserInfo.shareInfo[indexPath.row]
        HTTPTool.PostNoHUD(API.shopSetDefault, parameters: ["token":MMUserInfo.UserInfo.token!,"share_id":sharModel.id]) { (model, error) in
            self.dismiss()
            if model != nil{
                log("dic=====\(model?.data)")
                if model?.status == (1){
                    self.show(model?.info, delay: 1)
                    if self.indexPath != nil{
                        var  oldModel = MMUserInfo.UserInfo.shareInfo[(self.indexPath?.row)!]
                        oldModel.isDefault = "0"
                        MMUserInfo.UserInfo.shareInfo[(self.indexPath?.row)!] = oldModel
                    }
                    
                    var  newModel = MMUserInfo.UserInfo.shareInfo[indexPath.row]
                    newModel.isDefault = "1"
                    MMUserInfo.UserInfo.shareInfo[indexPath.row] = newModel
                    
                    MMUserInfo.UserInfo.shopShareModel = newModel
                    
                    self.tableView.reloadData()
                    
                }
            }else{
                log("erro == \(error)")
                self.show("请求失败", delay: 1)
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MMUserInfo.UserInfo.shareInfo.count
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMSetUpTableViewCell", for: indexPath) as! MMSetUpTableViewCell
        cell.indexPath = indexPath
        cell.model = MMUserInfo.UserInfo.shareInfo[indexPath.row]
        
        if cell.model?.isDefault == "1" {
            self.indexPath = indexPath
        }
        cell.event = {[unowned self]  (index,type)  in
            switch type {
            case .isDefault:
                self.setDefault(indexPath)
            case .edit:
                self.performSegue(withIdentifier: "MMShopSetTableViewController", sender: indexPath)
            case .out:
                
                if MMUserInfo.UserInfo.shareInfo.count < 2 {
                    self.show("至少保留一个店铺设置", delay: 1)
                    return
                }
                self.deleteShare(indexPath)
                
            default:
                break
            }
            
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMShopSetTableViewController" {
            let VC = segue.destination as! MMShopSetTableViewController
            if sender != nil {
                let indexPath = sender as! IndexPath
                VC.model = MMUserInfo.UserInfo.shareInfo[indexPath.row]
                VC.indexPath = indexPath
            }else{
                VC.isaddShop = true
            }
            
        }
        
    }
    
    
}
