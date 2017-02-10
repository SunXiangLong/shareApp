//
//  MMSetUpTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/23.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMSetUpTableViewController: MMBaseTableViewController {
    
    let array = ["关于共享购","联系我们  010-85170751","清除缓存","当前版本"]
    var cache:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.tableView.tableFooterView = UIView()
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
        backBtn.addTarget(self, action: #selector(self.popViewControllerAnimated), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "back_arrow"), for: UIControlState())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        
        
        
    }
    override func popViewControllerAnimated() -> Void {
        
        self.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return array.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 5))
        
        return headView
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMSetUpTableViewOneCell", for: indexPath) as!MMSetUpTableViewOneCell
            cell.nameLabel.text = array[indexPath.row]
            cell.versionLabel.text = ""
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 3 {
                cell.accessoryType = .none
                cell.versionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as?String
            }
            
            if indexPath.row == 2 {
                cell.versionLabel.text = String(fileSizeOfCache()) + "M"
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMSetUpTableViewTwoCell", for: indexPath) as!MMSetUpTableViewTwoCell
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "MMAppIntroducedTableViewController", sender: nil)
                break
            case 1:
                let url = URL.init(string: "telprompt:010-85170751")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
                break
            case 2:
                clearCache()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                break
            case 3:
                break
            default:
                break
            }
            break
        case 1:
            
            // 退出登录时，清空本地存储的用户信息 UUID  搜索历史  网页cookie
            MMUserInfo.UserInfo.clearUserInfo()
            UserDefaults.standard.removeObject(forKey: "userinfo")
            UserDefaults.standard.removeObject(forKey: "UUID")
            UserDefaults.standard.removeObject(forKey: "source")
            deleteCookie()
            
            let vc = self.navigationController?.viewControllers.first as!MMPersonalCenterViewController
            if vc.type != nil   {
                vc.dismiss(animated: true, completion: nil)
            }else{
                let nav = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigationController") as!MMNavigationController
                let window =   UIApplication.shared.delegate?.window
                window!!.rootViewController = nav
            }
            break
        default:
            break
        }
    }
    
    
    
}
