//
//  MMPayResultsViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMPayResultsViewController: MMBaseViewController {

    @IBOutlet weak var codeLabel: UILabel!
    var code:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   codeLabel.text = "您的开店码为：" + code!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func popViewControllerAnimated() {
        self.back(UIButton())
    }
    
    @IBAction func back(_ sender: AnyObject) {
        
        
        self.navigationController?.childViewControllers.forEach{
            if $0.isKind(of: MMNewShopRegistrationViewController.classForKeyedArchiver()!){
                self.popToViewController($0, animated: true)
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
