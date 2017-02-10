//
//  MMUpdateView.swift
//  ShareApp
//
//  Created by xiaomabao on 16/9/8.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftyJSON
struct updateModel{
    
    var latestVersion : String!
    var size : String!
    var versionDescription : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init( json: JSON){
        latestVersion = json["latest_version"].string
        size = json["size"].string
        versionDescription = json["version_description"].string
    }
}
class MMUpdateView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var ceny: NSLayoutConstraint!
    @IBOutlet weak var updateView: AnimatableView!
    @IBOutlet weak var ver_description: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var version: UILabel!
    var model:updateModel? {
        didSet{
            ver_description.text = model?.versionDescription
             ver_description.rowSpace(14)
            version.text = "最新版本：" + (model?.latestVersion)!
            size.text =  "新版本大小：" + (model?.size)!
            
        }
    
    }
//    var event:(() ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib();

    }
    @IBAction func buttonEvent(_ sender: UIButton) {
       UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/cn/app/xiao-ma-bao/id1135323453?mt=8")!)
        
//        switch sender.tag {
//        case 0:
//            UIView.animateWithDuration(0.5, animations: { 
//                self.ceny.constant = screenW*1.5
//                }, completion: { (bool) in
//                    self.event!()
//            })
//
//        case 1:
//            UIApplication.sharedApplication().openURL(NSURL.init(string: "https://itunes.apple.com/cn/app/xiao-ma-bao/id1135323453?mt=8")!)
//
//            self.event!()
//          
//
//        default:break
//        }
    }
    
}
