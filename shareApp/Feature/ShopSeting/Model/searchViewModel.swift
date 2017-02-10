//
//  searchViewModel.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/11.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class searchViewModel: NSObject {
    
    func checkUpdate(_ block:(()->Void)?) -> Void {
        
        if UserDefaults.standard.value(forKey: "version") == nil{
            downloadSearchlib(block)
            return
        }
        HTTPTool.Get(API.download, parameters: nil) { (data, error) in
            
            log(data)
            
            if let data = data{
                
                if data["data"]!["version"] as! String == UserDefaults.standard.value(forKey: "version") as! String {
                     block!()

                }else{
                    
                    UserDefaults.standard.set(data["data"]!["version"] as! String, forKey: "version")
                    UserDefaults.standard.synchronize()
                    self.downloadSearchlib(block)
                    
                }
                
            }else{
                log(error)
            }
            
        }
    }
    func downloadSearchlib(_ block:(()->Void)?) -> Void {
        
        
        HTTPTool.PostReturn(API.downloadSearchlib, parameters: nil) { (model, error) in
//            log(model?.data)
            if model != nil{
//                log(model?.data!["source"].arrayObject)
                
                
                UserDefaults.standard.set(model!.data!["source"].arrayObject, forKey: "source")
                UserDefaults.standard.synchronize()
                block!()

            }else{
                log(error)
                
            }
        }
    }
}
