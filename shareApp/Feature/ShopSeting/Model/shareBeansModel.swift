//
//  shareBeansModel.swift
//  shareApp
//
//  Created by xiaomabao on 2016/12/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
import SwiftyJSON
struct shareBeansModel {
    
    var number : String!
    var records : [RecordModel]! = []
    init(json:JSON) {
        number = json["number"].string
     records = json["records"].array!.map{
         RecordModel.init(json: $0);
    
        }
    }
}

struct RecordModel{
    
    var id : String!
    var recordDesc : String!
    var recordTime : String!
    var recordType : String!
    var recordVal : String!
    var userId : String!
    init(json:JSON){
        id = json["id"].string
        recordDesc = json["record_desc"].string
        recordTime = json["record_time"].string
        recordType = json["record_type"].string
        recordVal = json["record_val"].string
        userId = json["user_id"].string
    }

}
