//
//  MMLoginTypeViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/18.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
class MMLoginTypeViewController: MMBaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    @IBAction func login(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "MMToLoginViewController", sender: self)
        
    }
    
    @IBAction func registered(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "MMUserRegistrationViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let vc = sender?.destinationViewController;
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
