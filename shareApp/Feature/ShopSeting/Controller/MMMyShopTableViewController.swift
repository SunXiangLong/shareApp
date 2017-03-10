//
//  MMMyShopTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/26.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
import IBAnimatable
import RxCocoa
import RxSwift
class MMMyShopTableViewController: MMBaseTableViewController {
    
    @IBOutlet var noDataView: UIView!
    var qrCodeView: MMQrcodeView!
    var isData = false
    @IBOutlet weak var shopDescriptionLabel: AnimatableLabel!
    @IBOutlet weak var shopNameLabel: AnimatableLabel!
    @IBOutlet weak var avatarsImageVIew: AnimatableImageView!
    @IBOutlet weak var topImageView: AnimatableImageView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var navBarView: UIView!
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()
    lazy var avatarImageView:UIImageView = {
        return UIImageView()
    }()
    lazy var qrcodeImageView:UIImageView = {
        return UIImageView()
    }()
    lazy var goodsModelArray:[MMGoodsModel] = {
        return [MMGoodsModel]()
    }()
    lazy var myShopViewMoel:MMMyShopViewModel = {
    
        return MMMyShopViewModel()
    }()

    @IBOutlet weak var top: NSLayoutConstraint!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headView.sxl_height = screenW*70/124
        self.navigationController?.isNavigationBarHidden = true
        self.navBarView.frame = CGRect(x: 0, y: 20, width: screenW, height: 44)
        UIApplication.shared.keyWindow?.addSubview(self.navBarView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navBarView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UI()
        self.configureTableView()
    }
    
    
    func UI() -> Void {
        self.automaticallyAdjustsScrollViewInsets = false

        ///headView 赋值
        shopDescriptionLabel.text = MMUserInfo.UserInfo.shopShareModel?.shopDescription
        shopNameLabel.text = MMUserInfo.UserInfo.shopShareModel?.shopName
        avatarsImageVIew.setImage(MMUserInfo.UserInfo.shopShareModel?.shopAvatar, image: #imageLiteral(resourceName: "mm_defaultAvatar"))
        
        topImageView.setImage(MMUserInfo.UserInfo.shopShareModel?.shopBackground, image: #imageLiteral(resourceName: "backgroupImage"))
        
        ///没有数据提示
        
        noDataView.frame = CGRect(x: 0, y: screenW*70/124, width: screenW, height: screenH - screenW*70/124)
        noDataView.isHidden = true
        self.view.addSubview(noDataView)
    }
    
    func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = self.headView
        
        fetchData()

        ///   上拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(fetchData))
        tableView.mj_footer.isHidden = true
        
        
        myShopViewMoel.page = 1
        
        myShopViewMoel
            .refreshtStatusype
            .asObservable()
            .bindNext {[unowned self]  (type) in
                switch type {
                case .pullSuccessHasMoreData:
                    self.tableView.mj_footer.endRefreshing()
                case.pullSuccessNoMoreData:
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    break
                default :break
                }
            }.addDisposableTo(disposeBag)
        
        
        myShopViewMoel
            .response
            .asObservable()
            .bindNext({ [unowned self] (value) in
                if self.isData {
                    self.goodsModelArray = value
                    self.tableView.mj_footer.isHidden = false
                    if value.count > 0{
                        self.noDataView.isHidden = true
                    }else{
                        self.noDataView.isHidden = false
                    }
                    
                    self.tableView.reloadData()
                }
                self.isData = true;

            })
            
            .addDisposableTo(disposeBag)

        myShopViewMoel.indexPath
            .asObservable()
            .skip(1)
            .bindNext({[unowned self]  (value) in
                self.goodsModelArray.remove(at: value.row)
                self.tableView.deleteRows(at: [value], with: .automatic)
                self.tableView.reloadData()
                self.show("商品下架成功", delay: 0.5)
                if self.goodsModelArray.count == 0{
                    self.tableView.mj_footer.removeFromSuperview()
                    self.noDataView.isHidden = false
                }
            })
            .addDisposableTo(disposeBag)
        
        

    }
    func fetchData() {
        myShopViewMoel.requestData(API.goodsShopGoods, parameter: ["token":MMUserInfo.UserInfo.token! as AnyObject])
            .bindTo(myShopViewMoel.response)
            .addDisposableTo(disposeBag)
    }
    
    
    ///分享店铺二维码
    func hiddenQrcode() {
        qrCodeView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        UIApplication.shared.keyWindow?.addSubview(qrCodeView);
        qrCodeView.qrcodeImageView.image = qrcodeImageView.image
        qrCodeView.animationType = .slide(way: .in, direction: .down)
        qrCodeView.autoRun = false
        self.hiddenShare()
        qrCodeView.autoRun = true
        qrCodeView.cancleEvent = { [unowned self]  () in
            UIView.animate(withDuration: 0.3, animations: {
                self.qrCodeView.sxl_y = screenH
            }) { (bool) in
                self.qrCodeView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func back(_ sender: AnyObject) {
        
        self.popViewController(animated: true)
        
    }
    ///显示店铺里已上架商品分享view
    func share( _ model:MMGoodsModel,image:UIImage) -> Void {
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
        self.shareView.url = URL.init(string:model.share_url.absoluteString + "?c=\(shopSharemodel.id!)")
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
    ///显示店铺分享view
    @IBAction func share(_ sender: AnyObject) {
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down)
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = true
        self.shareView.shopView.isHidden  = false
        self.shareView.cancleButton.isHidden = false
        self.shareView.width.constant = screenW/4
        
        self.shareView.event = { [unowned self]   (type) in
            switch type {
            case .cancelType:
                self.hiddenShare()
                break
            case .loadQrCodeViewType:
                self.hiddenQrcode()
                break
            }
        }
        self.shareView.shopEvent = {[unowned self]  (shopSharemodel) in
            
            
            self.shareView.url = URL.init(string:MMUserInfo.UserInfo.shop_share_url.absoluteString + "?c=\(shopSharemodel.id!)" )
            
            
            self.show()
            self.avatarImageView.kf.setImage(with:shopSharemodel.shopAvatar, placeholder:nil , options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.dismiss()
                if image == nil{
                    self.shareView.image = UIImage.init(named: "mm_defaultAvatar")
                }else{
                    self.shareView.image = image
                }
                
            })
            
            self.qrcodeImageView.setImage(URL.init(string: Key.shopQrCode + MMUserInfo.UserInfo.token! + "/" + shopSharemodel.id + "/" + "0"), type: .zero)
            
            
            self.shareView.title = shopSharemodel.shopName
            self.shareView.centerText = shopSharemodel.shopDescription
            
        }
        UIApplication.shared.keyWindow?.addSubview(self.shareView);
        self.shareView.autoRun =  true
        
    }
    
    ///移除分享View
    func hiddenShare() -> Void {
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.shareView.sxl_y = screenH
            
        }) { (bool) in
            
            self.shareView.removeFromSuperview()
            
            
        }
        
    }
    

        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var oldOffsetY:CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
              
        if scrollView.mj_offsetY < 0 {
            top.constant = scrollView.mj_offsetY
        }else{
            if scrollView.mj_offsetY - oldOffsetY > 5 {
                navBarView.isHidden = true
                
            }else if (oldOffsetY - scrollView.mj_offsetY > 5 ){
                navBarView.isHidden = false
            }
            
            oldOffsetY = scrollView.mj_offsetY
        
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goodsModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMGoodsTableViewCell", for: indexPath)as!MMGoodsTableViewCell
        cell.goodsModel = goodsModelArray[indexPath.item]
        cell.indexPath = indexPath
        cell.uiedgeInsetsZero()
        cell.buttonEventType = {[unowned self] (model,indexPath,type) in
            
            if type == buttonClickEventType.share {
                self.share(model, image: cell.goodsThumbImageView.image!)
            }else{
                self.myShopViewMoel.goodsOnSale(model, indexPath: indexPath)
            }
            
        }
        return cell
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
            controller.isMyShop = true

            
        }
    }
    

}
