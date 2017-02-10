//
//  MMMyShopViewModel.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/14.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class MMMyShopViewModel:MMBaseViewModel {
    
    var response: Variable<[MMGoodsModel]> = Variable([])
    var indexPath = Variable(IndexPath())
    func requestData(_ url: String, parameter: [String : AnyObject]) -> Observable<[MMGoodsModel]> {
        var  para = parameter
        if page != 0  {
           para["page"] = "\(page)" as AnyObject?
           
        }
        return Observable.create{[unowned self]  observer in
        HTTPTool.Post(url, parameters: para, completion: {[unowned self]  (model, error) in
            
            self.refreshtStatusype.value = .pullSuccessHasMoreData
            if model != nil{
                
                if (model?.data?.array?.count)! > 0{
//                    log(model?.data)
                    observer.onNext((model?.data?.array!.map{
                        MMGoodsModel.init(json: $0)
                        })!)
                    self.page = self.page + 1
                    
                }else{
                    self.refreshtStatusype.value = .pullSuccessNoMoreData
                }
                
            }
        })
            return Disposables.create()
        }
    }
    
    /**
     商品上下架
     */
    func goodsOnSale(_ goodsModel:MMGoodsModel,indexPath:IndexPath) -> Void {
        var url:String?
        url = API.goodsOffSale
        HTTPTool.Post(url!, parameters: ["token":MMUserInfo.UserInfo.token!,"goods_id":goodsModel.goods_id]) { (model, error) in
            if model != nil{
                
                if model?.status == (1){
                    self.indexPath.value = indexPath
                    }
                    
                }
                
            }
            
        }
    }


