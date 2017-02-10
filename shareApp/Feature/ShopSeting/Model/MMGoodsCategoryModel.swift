//
//  MMGoodsCategoryModel.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/23.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyJSON
/// 商品分类对象
class MMGoodsCategoryModel {
    
    var cat_name: String!
    var icon: URL!
    var cat_id: String!
    var selected: NSNumber!
    var type:String!
    var child: [MMGoodsCategoryChildModel]! = []
    init(json:JSON)  {
        cat_name  = json["cat_name"].string
        icon = json["icon"].URL
        selected = json["selected"].number
        cat_id = json["cat_id"].string
        type = json["type"].string
        for dic in json["child"].array! {
            let  childModel = MMGoodsCategoryChildModel.init(json: dic)
            child.append(childModel)
        }
    }
}
/// 商品分类子对象
class MMGoodsCategoryChildModel{
    var cat_id: String!
    var icon: URL!
    init(json:JSON)  {
        cat_id = json["cat_id"].string
        icon = json["icon"].URL
    }
}

/// 订单分类对象
class orderOrderModel{
    var order_type_name: String!
    var order_type_code: String!
    var selected:NSNumber!
    init(json:JSON)  {
        order_type_name = json["order_type_name"].string
        order_type_code = json["order_type_code"].string
        selected = json["selected"].number
    }
}
