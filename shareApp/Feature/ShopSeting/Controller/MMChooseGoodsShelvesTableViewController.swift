//
//  MMChooseGoodsShelvesTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/23.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
import IBAnimatable
import MBProgressHUD
class MMChooseGoodsShelvesTableViewController: MMBaseTableViewController {
    @IBOutlet weak var tableHeadView: UICollectionView!
    var categoryModel:MMGoodsCategoryModel?
    var cateID = "0"
    lazy var goodsModelArray:[MMGoodsModel] = []
    var brandModelArray:[MMBrandModel] = []
    /// 页数
    var page = 1
    /// 排序关键字
    var sort = ("默认排序","default")
    /// 搜索关键字
    var keyword = ""
    
    var type:tableViewCellType?
    var webType:LoadingWebviewType?
    
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UI()
    }
    
    func UI() -> Void {
        
        if categoryModel!.child.count == 0 {
            tableHeadView.sxl_height = 0
        }else{
            var  coun = CGFloat(categoryModel!.child.count/4)
            let num = CGFloat(categoryModel!.child.count%4)
            
            if num != 0 {
                
                coun = coun + 1
            }
            
            tableHeadView.sxl_height = ((screenW - 125)/4*162/122)*coun + coun*10+10
            
        }
        self.navigationController?.navigationBar.backgroundColor = Color.white
        self.tableView.contentInset = UIEdgeInsetsMake(40 , 0, 0, 0)
        self.tableView.tableFooterView = UIView()
        if categoryModel?.child.count == 0 {
            self.tableHeadView.removeFromSuperview()
            self.tableView.tableHeaderView = UIView()
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        self.requestDta()
        ///   上拉加载
        
        
    }
    
    func share( _ model:MMGoodsModel,image:UIImage) -> Void {
        
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.title = model.goods_name
        self.shareView.shareView.isHidden = true
        self.shareView.shopView.isHidden  = false
        self.shareView.cancleButton.isHidden = false
        self.shareView.centerText = "有人@你，你有一个分享尚未点击"
        self.shareView.image = image
        self.shareView.width.constant = 0
        
        self.shareView.shopEvent = { [unowned self]  (shopSharemodel) in
            self.shareView.url = URL.init(string:model.share_url.absoluteString + "?c=\(shopSharemodel.id!)" )
            log(self.shareView.url)
        }
        self.shareView.event = { [unowned self]   (type) in
            self.hiddenShare()
        }
        UIApplication.shared.keyWindow?.addSubview(self.shareView);
        self.shareView.autoRun =  true
    }
    
    ///移除分享view
    func hiddenShare() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.sxl_y = screenH
            
        }) { (bool) in
            self.shareView.removeFromSuperview()
            
        }
    }
    
    /**
     请求商品列表或brand列表
     */
    override func requestDta() ->Void{
        
        var  parameter:[String: String]?
        var urlStr = API.brandBrandList2
        
        switch type! {
        case .brand:
            
            if let token = MMUserInfo.UserInfo.token {
                parameter = ["token":token,"page":String(page),"cat_id":cateID]
            }else{
                parameter = ["page":String(page),"cat_id":cateID]
            }
            
        case .category:
            if let token = MMUserInfo.UserInfo.token {
                urlStr = API.goodsGoodsList
                parameter = ["token":token,"page":String(page),"cat_id":cateID ,"sort":sort.1 ,"keyword":keyword ]
            }else{
                urlStr = API.goodsGoodsList2
                parameter = ["page":String(page),"cat_id":cateID ,"sort":sort.1 ,"keyword":keyword]
                
            }
            
            
            
        }
        
        self.show()
        HTTPTool.PostNoHUD(urlStr, parameters: parameter) { (model, error) in
            self.dismiss()
            if self.page == 1 {
                self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            if model != nil{
//                log(model?.data)
                
                
                switch self.type! {
                case .brand:
                    self.brandModelArray = self.brandModelArray + (model?.data?.array!.map{
                        MMBrandModel.init(json: $0)
                        })!
                case .category:
                    self.goodsModelArray = self.goodsModelArray + (model?.data?.array!.map{
                        MMGoodsModel.init(json: $0)
                        })!
                    
                }
                
                if model?.data?.array?.count == 0{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    
                }
                self.page = self.page + 1
                self.tableView.reloadData()
                
                
            }
        }
        //        HTTPTool.Post(urlStr!, parameters: parameter) { (model, error) in
        //
        //            if self.page == 1 {
        //                self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
        //            }else{
        //                self.tableView.mj_footer.endRefreshing()
        //            }
        //            if model != nil{
        ////               log(model?.data)
        //
        //
        //                switch self.type! {
        //                case .brand:
        //                        self.brandModelArray = self.brandModelArray + (model?.data?.array!.map{
        //                            MMBrandModel.init(json: $0)
        //                            })!
        //                case .category:
        //                    self.goodsModelArray = self.goodsModelArray + (model?.data?.array!.map{
        //                        MMGoodsModel.init(json: $0)
        //                        })!
        //
        //                }
        //
        //                if model?.data?.array?.count == 0{
        //                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
        //
        //                }
        //                self.page = self.page + 1
        //                self.tableView.reloadData()
        //            }
        //
        //        }
        
    }
    /**
     商品上下架
     */
    func goodsOnSale(_ goodsModel:MMGoodsModel,indexPath:IndexPath) -> Void {
        var url:String?
        if goodsModel.goods_sale_status == "0" {
            url = API.goodsOnSale
        }else{
            url = API.goodsOffSale
        }
        
        HTTPTool.Post(url!, parameters: ["token":MMUserInfo.UserInfo.token!,"goods_id":goodsModel.goods_id]) { (model, error) in
            if model != nil{
                
                if model?.status == (1){
                    if goodsModel.goods_sale_status == "0" {
                        goodsModel.goods_sale_status = "1"
                    }else{
                        goodsModel.goods_sale_status = "0"
                        
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    self.show(model?.info, delay: 1)
                }
                
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch type! {
        case .brand:
            return brandModelArray.count
        case .category:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type! {
        case .brand:
            return 1
        case .category:
            return goodsModelArray.count
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch type! {
        case .brand:
            return screenW*350/750
        case .category:
            return 164
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if categoryModel!.child!.count > 0 {
            return 5
        }
        return 0.00001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch type! {
        case .brand:
            return 10
        case .category:
            return 0.00001
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch type! {
        case .brand:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMGoodsTableViewTwoCell", for: indexPath)as!MMGoodsTableViewTwoCell
            cell.brandModel = brandModelArray[(indexPath as IndexPath).section]
            cell.uiedgeInsetsZero()
            return cell
        case .category:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMGoodsTableViewCell", for: indexPath)as!MMGoodsTableViewCell
            cell.goodsModel = goodsModelArray[indexPath.row]
            cell.indexPath = indexPath
            cell.uiedgeInsetsZero()
            cell.buttonEventType = {[unowned self] (model,indexPath,type) in
                if !self.toLogIn(){
                    return
                }
                if type == buttonClickEventType.share {
                    self.share(model, image: cell.goodsThumbImageView.image!)
                    
                }else{
                    self.goodsOnSale(model, indexPath: indexPath as IndexPath)
                }
                
            }
            
            return cell
        }
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.toLogIn(){
            return
        }
        switch type! {
            
        case .brand:

            if brandModelArray[indexPath.section].type  == "1"{
                webType = LoadingWebviewType.eventWebsite
                self.performSegue(withIdentifier: "MMGoodsDetailsViewController", sender: indexPath)
            }else{
                
                
                self.performSegue(withIdentifier: "MMBrandGoodsListTableViewController", sender: indexPath)
                
            }
        case .category:
            self.performSegue(withIdentifier: "MMGoodsDetailsViewController", sender: indexPath)
  
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMGoodsDetailsViewController" {
            
            if webType == LoadingWebviewType.eventWebsite {
                let controller = segue.destination as! MMGoodsDetailsViewController
                let indexPath = sender as!IndexPath
                controller.type = LoadingWebviewType.eventWebsite
                controller.url = brandModelArray[indexPath.section].url
                controller.brandModel = brandModelArray[indexPath.section]
                controller.title = brandModelArray[indexPath .section].title
            }else{
                let controller = segue.destination as! MMGoodsDetailsViewController
                let indexPath = sender as!IndexPath
                let model = goodsModelArray[indexPath.row]
                controller.type = LoadingWebviewType.goodsDetails
                controller.url = model.buy_url
                
                
            }
            
        }else if segue.identifier == "MMBrandGoodsListTableViewController"{
            
            let controller = segue.destination as! MMBrandGoodsListTableViewController
            let indexPath = sender as! IndexPath
            controller.brandModel = brandModelArray[indexPath.section]
            controller.title = brandModelArray[indexPath .section].title
            controller.type = CommodityType.ordinaryGoods
            
        }
        
        
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (categoryModel?.child.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMGoodsHeadCollectionViewCell", for: indexPath) as! MMGoodsHeadCollectionViewCell
        cell.model = categoryModel?.child[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width: (screenW - 125)/4,height: (screenW - 125)/4*162/122 );
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 25, 10, 25)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 10
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 25
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    
        
        
        let model = categoryModel?.child[indexPath.item]
        cateID = (model?.cat_id)!
        self.sort = ("默认排序","default")
        self.page = 1
        self.goodsModelArray.removeAll()
        self.keyword = ""
        self.tableView.mj_footer.resetNoMoreData()
        self.tableView.reloadData()
        self.requestDta()
        
    }
    
    
    
}

