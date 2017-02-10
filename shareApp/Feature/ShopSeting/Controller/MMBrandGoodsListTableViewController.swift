//
//  MMBrandGoodsListTableViewController.swift
//  ShareApp
//
//  Created by xiaomabao on 16/9/7.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
import IBAnimatable
class MMBrandGoodsListTableViewController: MMBaseTableViewController {

    
     @IBOutlet var tableHeadView: UIImageView!
    /// 页数
    var page = 1
    var  brandModel:MMBrandModel?
    
    var type:CommodityType?
    
    lazy var avatarsImageVIew : UIImageView = {
        return UIImageView()
    }()
    lazy var goodsModelArray:[MMGoodsModel] = {
        return [MMGoodsModel]()
    }()
    
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UI()
    }
    func UI() -> Void {
        tableHeadView.sxl_height = screenW*350/750
        avatarsImageVIew.image =  #imageLiteral(resourceName: "mm_defaultAvatar")
        avatarsImageVIew.setImage(MMUserInfo.UserInfo.shop_avatar, type: .zero);
        
        self.rightBtn!.setImage(#imageLiteral(resourceName: "mm_share1"),for:UIControlState())
        self.rightBtn!.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        tableHeadView.setImage(brandModel!.banner, image:#imageLiteral(resourceName: "backgroupImage"))
        tableHeadView.kf.setImage(with: brandModel?.banner, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        self.requestDta()
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.requestDta))
        self.tableView.mj_footer.isHidden = true
    }
  
    override func rightBtnSelector() -> Void {
       
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = false
        self.shareView.shopView.isHidden  = true
        self.shareView.cancleButton.isHidden = true
        self.shareView.title = brandModel?.title
        self.shareView.centerText = "听说只有长得好看的人才能看到这个分享哦！!"
        self.shareView.image = avatarsImageVIew.image
        switch type! {
        case .ordinaryGoods:
            self.shareView.url = brandModel?.share_url
        case .vipGoods:
            self.shareView.url = brandModel?.share_vip_url
        }
        
       
        self.shareView.width.constant = 0
        self.shareView.event = { [unowned self]   (type) in
            self.hiddenShare()
        }
      UIApplication.shared.keyWindow?.addSubview(self.shareView)

        self.shareView.autoRun =  true
    }
    
    func  share( _ model:MMGoodsModel,image:UIImage) -> Void {
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = true
        self.shareView.shopView.isHidden  = false
        self.shareView.cancleButton.isHidden = false
        self.shareView.title = model.goods_name
        self.shareView.centerText = "有人@你，你有一个分享尚未点击"
        self.shareView.image = image
        self.shareView.width.constant = 0
        self.shareView.shopEvent = { [unowned self]  (shopSharemodel) in
            self.shareView.url = URL.init(string:model.share_url.absoluteString + "?c=\(shopSharemodel.id!)" )
            
        }
        self.shareView.event = { [unowned self]   (type) in
            switch type {
            case .cancelType:
                self.hiddenShare()
                
            case .loadQrCodeViewType:
                break
            }
        }
        
        UIApplication.shared.keyWindow?.addSubview(self.shareView);
        self.shareView.autoRun =  true

    }
    func hiddenShare() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.sxl_y = screenH
        }) { (bool) in
            self.shareView.removeFromSuperview()
        }
    }
    
    
    /**
     请求商品列表
     */
    override func requestDta() ->Void{
        
        var typeStr:String?
        
        switch type! {
            
        case .ordinaryGoods:
            typeStr = "0"
        case .vipGoods:
            typeStr = "1"
        }
        HTTPTool.Post(API.brandGoodList, parameters:["token":MMUserInfo.UserInfo.token!,"page":String(page),"type":typeStr!,"topic_id":(brandModel?.topic_id)!]) { (model, error) in
            self.tableView.mj_footer.endRefreshing()
            self.tableView.mj_footer.isHidden = false
            if model != nil{
                
                self.goodsModelArray = self.goodsModelArray + (model?.data?.array!.map{
                    MMGoodsModel.init(json: $0)
                    })!
                    if model?.data?.array?.count == 0{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }
                    self.page = self.page + 1
                    self.tableView.reloadData()
                }
                
            }
            
        
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


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (goodsModelArray.count)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 0.00001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch type! {
        case .ordinaryGoods:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMGoodsTableViewCell", for: indexPath)as!MMGoodsTableViewCell
            cell.goodsModel = goodsModelArray[indexPath.row]
            cell.indexPath = indexPath
            cell.uiedgeInsetsZero()
            cell.buttonEventType = {[unowned self] (model,indexPath,type) in
                
                if type == buttonClickEventType.share {
                    self.share(model, image: cell.goodsThumbImageView.image!)
                    
                }else{
                    self.goodsOnSale(model, indexPath: indexPath as IndexPath)
                }
                
            }
            
            return cell
        case .vipGoods:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MMVIPGoodsListTableViewCell", for: indexPath) as!MMVIPGoodsListTableViewCell
            
            cell.goodsModel = goodsModelArray[indexPath.row]
            cell.indexPath = indexPath
            cell.uiedgeInsetsZero()
            cell.buttonEventType = {[unowned self] (model,indexPath,type) in
                
                self.share(model,image: cell.goodsThumbImageView.image!)
                
            }
            
            
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "MMGoodsDetailsViewController", sender: indexPath)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MMGoodsDetailsViewController" {
            let controller = segue.destination as! MMGoodsDetailsViewController
            let indexPath = sender as!IndexPath
            let model = goodsModelArray[indexPath.row]
            controller.type = LoadingWebviewType.goodsDetails
            controller.url = model.buy_url
            
            
        }
        
    }

}
