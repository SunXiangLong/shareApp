//
//  MMBaseModel.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyJSON
class MMBaseModel {
    ///  状态码 1表示成功 0表示失败
    var status:NSNumber?
    ///  提示信息
    var info:String?
    //图片连接（只有涉及到图片的接口才会用到，否则就是nil）
    var path:URL?
    ///   返回的json数据，若不返回就是nil
    var data:JSON?
    
    init(json:JSON) {
        status = json["status"].number
        data = json["data"]
        info = json["info"].string
        path = json["path"].URL
        if self.data! == nil{
            data = json
        }
  
    }
    
    
}
