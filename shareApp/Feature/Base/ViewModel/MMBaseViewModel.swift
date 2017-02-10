//
//  MMBaseViewModel.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/14.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
enum RefreshStatus: Int {
    case dropDownSuccess // 下拉成功
    case pullSuccessHasMoreData // 上拉，还有更多数据
    case pullSuccessNoMoreData // 上拉，没有更多数据
    case invalidData // 无效的数据
    
}
class MMBaseViewModel {
    var  refreshtStatusype = Variable(RefreshStatus.invalidData)
    
    var page = 0
    init() {}
    fileprivate var urlString = ""
    fileprivate var parameters = [String: AnyObject]()
    func requestData(_ url:String,parameter:[String: AnyObject]) -> Any {
        urlString = url
        parameters = parameter
        
        
        return [Any]()
        
        
    }
    func updateData() -> Void {
        
    }
        
    
    
}
