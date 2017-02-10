//
//  MMShowResultViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/27.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMShowResultViewController: MMBaseViewController {

    @IBOutlet weak var applyMoneylabel: UILabel!
    var applyMoney:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现结果"
        applyMoneylabel.text = applyMoney
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func popViewControllerAnimated() {
        
        for vc in (self.navigationController?.viewControllers)!{
            
            if vc.isKind(of: MMMyEarningsTableViewController.classForKeyedArchiver()!){
                self.popToViewController(vc, animated: true)
            }
            
        }
       
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
