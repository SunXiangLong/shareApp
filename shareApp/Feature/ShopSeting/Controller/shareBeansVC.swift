//
//  shareBeansVC.swift
//  shareApp
//
//  Created by xiaomabao on 2016/12/20.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
class shareBeansVC: MMBaseViewController {
   
    @IBOutlet weak var shareBeans: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var page  = 1
    var shareBeansmodel:shareBeansModel?{
        didSet{
            shareBeans.text = shareBeansmodel?.number
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.title = "我的共享豆"
        self.tableView.tableFooterView = UIView()
        requestDta()
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
    }
    
    override func requestDta() {
        HTTPTool.Post(API.beanInfo, parameters: ["token":MMUserInfo.UserInfo.token!,"page":"\(page)"]) { (model, error) in
            self.tableView.mj_footer.endRefreshing()
            if model != nil{
                
                if self.page == 1{
                    self.tableView.isHidden = false
                self.shareBeansmodel = shareBeansModel.init(json: model!.data!)
                    
                
                }else{
                    self.shareBeansmodel?.records = self.shareBeansmodel!.records + shareBeansModel.init(json: model!.data!).records
                }
                if model?.data?["records"].array?.count == 0 {
                    self.tableView.mj_footer.isHidden = true;
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    
                }
                self.page = self.page + 1;
                
                self.tableView .reloadData();
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GiveFriendsVC"{
        
            let controller = segue.destination as! GiveFriendsVC
            controller.number = shareBeansmodel?.number
            controller.reloadData = {[unowned self]  in
                self.page = 1;
                self.shareBeansmodel = nil;
                self.tableView.isHidden = true;
                self.requestDta();
                
            }
        }
        
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension shareBeansVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shareBeansmodel   == nil{
            return 0
        }
        
        if shareBeansmodel!.records.count > 0{
            return shareBeansmodel!.records.count
        }
        
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shareBeansmodel!.records.count > 0{
            return 65
        }
        return screenH - 129 - 64;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shareBeansmodel!.records.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "shareBeansCell", for: indexPath) as! shareBeansCell
            cell.row = indexPath.row
            cell.model = shareBeansmodel?.records[indexPath.row];
            cell.removeUIEdgeInsetsZero()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareBeansCellNULL", for: indexPath)
        cell.removeUIEdgeInsetsZero()
        return cell
        
    }

}

