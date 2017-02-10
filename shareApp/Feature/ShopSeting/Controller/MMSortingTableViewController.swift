//
//  MMSortingTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/25.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
///定义闭包类型特定的函数类型
 typealias sorting = ((String,String)) -> Void
class MMSortingTableViewController: MMBaseTableViewController {
   
    
    let dataArr = [("默认排序","default"),("利润从高到低","profit"),("价格由高到低","price_high"),("价格由低到高","price_low")]
    
    var  selectedItem =  ("默认排序","default")

    var   selectdString:sorting?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMSortingTableCell", for: indexPath) as!MMSortingTableCell
        
        cell.sortingName.text =  dataArr[indexPath.row].0
        cell.uiedgeInsetsZero()
        if dataArr[indexPath.row].0 == selectedItem.0 {
           cell.sortingImageView.image = UIImage.init(named: "mm_ShelvesSelected")
            
        }else{
      
            cell.sortingImageView.image = UIImage()
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectdString!(dataArr[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        
    }

   
}
