//
//  MMSearchGoodsViewCell.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/8.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import RxSwift
import RxCocoa
class MMSearchGoodsViewCell: MMBaseCollectionViewCell {
    
    
    @IBOutlet weak var namel: AnimatableLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

struct ViewModel {
    var type:CommodityType?
    var isSearch = Variable(false)
    
    func getRepositories(_ githubId:String) -> Observable<[MMGoodsModel]> {
       
        return Observable.create{  observer in
           
            if !self.isSearch.value {
            
                return Disposables.create()
            }
            log(self.isSearch.value)
            self.isSearch.value = false;
            
            var isVip = "1"
            if self.type! == .ordinaryGoods{
            
                isVip = "0"
            
            }
            
            HTTPTool.Post(API.searchGoods, parameters: ["token":MMUserInfo.UserInfo.token!,"keywords":githubId,"is_vip":isVip]) { (model, error) in
                
                 self.isSearch.value = true
                if model != nil&&model!.data!["lists"] != nil&&model!.data!["lists"].count > 0 {
                    
                    let data  = (model?.data?["lists"].array!.map{
                        MMGoodsModel.init(json: $0)
                        })!
                    
                    observer.onNext(data)
                    
                }else{
                observer.onNext([])
                }
                
            }
            return Disposables.create()
        }
    }
}

