//
//  MMOpenShopPackageViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/1.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMOpenShopPackageViewController: MMBaseViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var confirmImage: UIImageView!
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
        self.view.backgroundColor = Color.white
        self.show()
        let  date  = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMddHHmm"
        self.imageView.kf.setImage(with:URL.init(string: Key.imageUrl + dformatter.string(from: date)), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            self.dismiss()
            self.confirmImage.isHidden = false;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(_sender: AnyObject) {
        self.popViewController(animated: true)
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
