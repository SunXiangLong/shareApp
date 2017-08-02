//
//  MMPersonalCenterViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/20.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMPersonalCenterViewController: MMBaseCollectionViewController {
    
    let operatorCellModelArr = [
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon2"), optionsStr: "VIP专享"),
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon3"), optionsStr: "我的店铺"),
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon4"), optionsStr: "我的收益"),
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon5"), optionsStr: "订单管理"),
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon1"), optionsStr: "个人中心"),
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon6"), optionsStr: "设置"),
        optionCellModel.init(optionimage: UIImage.init(named: "mm_syicon7"), optionsStr: "邀请好友")]
    var statisticShopInfo:shopStatisticInfo?
    var type:String?
    var headView:MMSetingReusableView?
    lazy var customFlowLayout:UICollectionViewFlowLayout = {
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.headerReferenceSize = CGSize(width: screenW, height: 212 + screenW*70/124)
        customFlowLayout.footerReferenceSize = CGSize(width: 0, height: 0)
        customFlowLayout.minimumInteritemSpacing = 0
        customFlowLayout.minimumLineSpacing = 0
        customFlowLayout.itemSize = CGSize(width: screenW/3,height: screenW/3*192/249)
        customFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return customFlowLayout
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if   MMUserInfo.UserInfo.token == nil{
            statisticShopInfo = nil
            self.collectionView?.reloadData()
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = MMBaseViewModel()
        viewModel.refreshtStatusype.value = .invalidData
        viewModel.refreshtStatusype.value = .pullSuccessNoMoreData
        collectionView?.alwaysBounceVertical = true
        collectionView?.setCollectionViewLayout(self.customFlowLayout, animated: true)
        if !self.toLogIn(){
            return
        }else{
            self.statisticStoreInfo()
        }
    }
    @IBAction func pusShopSeting(_ sender: UITapGestureRecognizer) {
        
        if !self.toLogIn(){
            return
        }
        
        if MMUserInfo.UserInfo.shareInfo.count > 0 {
            self.performSegue(withIdentifier: "MMShopsSetTableViewController", sender: nil)
        }else{
            self.performSegue(withIdentifier: "MMShopSetTableViewController", sender: nil)
            
        }
        
        
    }
    
    
    
    /**获取店铺统计信息*/
    func statisticStoreInfo() -> Void {
        
        HTTPTool.PostNoHUD(API.statisticInfo, parameters: ["token":MMUserInfo.UserInfo.token!]) { (model, error) in
            if model != nil{
                self.dismiss()
                //                log("dic=====\(model?.data)")
                if  model?.status == (1){
                    self.statisticShopInfo = shopStatisticInfo.init(json: (model?.data)!)
                    self.collectionView?.reloadData()
                }else{
                    self.dismiss()
                    self.show(model?.info , delay: 1)
                }
            }else{
                self.dismiss()
                log("erro == \(String(describing: error))")
                
                self.show("请求失败", delay: 0.7);
                
                
                
            }
        }
        
    }
    
    /// 获取商品类目列表
    var categoryModel:[MMGoodsCategoryModel]? = []
    func requestDta(_ isVip:Bool) ->Void{
        categoryModel?.removeAll()
        HTTPTool.Post(API.goodsCategoryList, parameters: ["token":MMUserInfo.UserInfo.token!]) { (model, error) in
            if model != nil{
//                log(model?.data)
                self.categoryModel = model?.data?.array!.map{
                    MMGoodsCategoryModel.init(json: $0)
                }
                if isVip {
                    self.performSegue(withIdentifier: "MMVipTabPageViewController", sender: nil)
                }else{
                    self.performSegue(withIdentifier: "MMTabPageViewController", sender: nil)
                }
                
            }
        }
    }
    /// 获取订单分类列表
    var orderOrderModelArr:[orderOrderModel]? = []
    func orderOrderTypeRequestDta() ->Void{
        orderOrderModelArr?.removeAll()
        HTTPTool.Post(API.orderOrderType, parameters: ["token":MMUserInfo.UserInfo.token!]) { (model, error) in
            if model != nil{
                self.orderOrderModelArr = model?.data?.array!.map{
                    orderOrderModel.init(json: $0)
                }
                self.performSegue(withIdentifier: "MMMyOrderTabPageViewController", sender: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "MMTabPageViewController":
            let controller = segue.destination as! MMTabPageViewController
            controller.isInfinity = false
            for categoryModel in self.categoryModel! {
                let vc = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "MMChooseGoodsShelvesTableViewController") as!MMChooseGoodsShelvesTableViewController
                vc.categoryModel = categoryModel
                vc.cateID =  categoryModel.cat_id
                if  categoryModel.type != nil && categoryModel.type == "brand" {
                    vc.type = tableViewCellType.brand
                }else{
                    vc.type = tableViewCellType.category
                }
                controller.tabItems.append((vc,categoryModel.cat_name))
                controller.sortArray?.append(("默认排序","default"))
                controller.keywordArray?.append("")
            }
            var option = TabPageOption()
            option.currentColor = "ffffff".color
            option.defaultColor = "f6b0ac".color
            option.tabHeight = 39
            controller.option = option
            break
        case "MMMyOrderTabPageViewController":
            let controller = segue.destination as! MMMyOrderTabPageViewController
            controller.isInfinity = false
            for model in self.orderOrderModelArr! {
                let vc = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "MMMyOrderTableViewController") as!MMMyOrderTableViewController
                vc.model = model
                controller.tabItems.append((vc,model.order_type_name!))
                controller.keywordArray?.append("")
            }
            var option = TabPageOption()
            option.currentColor = "fb5151".color
            option.defaultColor = "555555".color
            option.tabBackColor = "f3f3f3".color
            option.tabHeight = 39
            controller.option = option
            break
        case "MMVipTabPageViewController":
            let controller = segue.destination as! MMVipTabPageViewController
            controller.isInfinity = false
            for categoryModel in self.categoryModel! {
                let vc = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "MMVIPGoodsListTableViewController") as!MMVIPGoodsListTableViewController
                vc.categoryModel = categoryModel
                vc.cateID =  categoryModel.cat_id
                if  categoryModel.type != nil && categoryModel.type == "brand" {
                    vc.type = tableViewCellType.brand
                }else{
                    vc.type = tableViewCellType.category
                }
                controller.tabItems.append((vc,categoryModel.cat_name))
                controller.keywordArray.append("")
            }
            var option = TabPageOption()
            option.currentColor = "ffffff".color
            option.defaultColor = "f6b0ac".color
            option.tabHeight = 39
            controller.option = option
        case "MMShopSetTableViewController":
            let VC = segue.destination as! MMShopSetTableViewController
            VC.model = MMUserInfo.UserInfo.shopShareModel
        default:
            break
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.mj_offsetY < 0 {
            headView?.top.constant = scrollView.mj_offsetY
            headView?.height.constant = screenW*70/124 - scrollView.mj_offsetY
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return operatorCellModelArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMsetingCollectionViewCell", for: indexPath) as! MMsetingCollectionViewCell
        cell.cellModel = operatorCellModelArr[indexPath.row]
        cell.indexPath = indexPath
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let rusableView  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MMsetingCollectionHeadView", for: indexPath) as? MMSetingReusableView
            rusableView?.statisticShopInfo = self.statisticShopInfo
            headView = rusableView;
            return rusableView!
        default: return UICollectionReusableView()
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !self.toLogIn(){
            return
        }
        switch indexPath.row {
        case 0:
            self.requestDta(true)
        case 1:
            self.performSegue(withIdentifier: "MMMyShopTableViewController", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "MMMyEarningsTableViewController", sender: nil)
        case 3:
            self.orderOrderTypeRequestDta()
        case 4:
            self.performSegue(withIdentifier: "personalCenterViewController", sender: nil)
        case 5:
            self.performSegue(withIdentifier: "MMSetUpTableViewController", sender: nil)
        case 6:
            self.performSegue(withIdentifier: "MMInviteFriendViewController", sender: nil)
        default:
            break
            
        }
    }
    
    
    
}
