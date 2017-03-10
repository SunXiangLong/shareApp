//
//  MMTabPageViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/23.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
import SnapKit

class MMTabPageViewController: TabPageViewController,UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet var qrCodeView: MMQrcodeView!
    @IBOutlet weak var searchTextField: AnimatableTextField!
    
    @IBOutlet var shareButton: UIButton!
    var sortButton:AnimatableButton?
     /// 排序关键字数组
    var sortArray:[(String,String)]? = []
     /// 搜索关键字数组
    var keywordArray:[String]? = []
    
   lazy var keepView:UIView = {
        let view = UIView.init(frame: CGRect(x: screenW - 60, y: 0, width: 60, height: 44));
        view.backgroundColor = Color.white
        return view
    }()
    //先缓存二维码和店铺头像image
    lazy var avatarsImageView : UIImageView = {
        return UIImageView()
    }()
    lazy var qrcodeImageView : UIImageView = {
        return UIImageView()
    }()
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.addSubview(keepView)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        keepView.removeFromSuperview()
//        shareButton.removeFromSuperview()
//        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
//
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
//        self.navigationController?.navigationBar.backItem?.hidesBackButton  = true
        self.view.backgroundColor = UIColor.white;
         requestDta(false);
        
        self.searchTextField.frame = CGRect(x: 60, y: 7, width: screenW - 120, height: 30)
        self.childView = {[unowned self]  (page) in
            
            if page == 0 {
                self.keepView.isHidden = false
            }else{
                self.keepView.isHidden = true
            }
            self.searchTextField.resignFirstResponder()
            self.searchTextField.text = self.keywordArray![page]
        }
        
      
    }
    /// 获取商品类目列表
    var categoryModel:[MMGoodsCategoryModel]? = []
    func requestDta(_ isVip:Bool){
        categoryModel?.removeAll()
        var parameters = [String:String]()
        let  url = API.goodsCategoryList
        if let token = MMUserInfo.UserInfo.token{
            parameters = ["token":token]
           
        }
        HTTPTool.Post(url, parameters:parameters ) { (model, error) in
            if model != nil{
//                log(model?.data)
                self.categoryModel = model?.data?.array!.map{
                    MMGoodsCategoryModel.init(json: $0)
                }
              
//                    let controller = segue.destination as! MMTabPageViewController
                    self.isInfinity = false
                    for categoryModel in self.categoryModel! {
                        let vc = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "MMChooseGoodsShelvesTableViewController") as!MMChooseGoodsShelvesTableViewController
                        vc.categoryModel = categoryModel
                        vc.cateID =  categoryModel.cat_id
                        if  categoryModel.type != nil && categoryModel.type == "brand" {
                            vc.type = tableViewCellType.brand
                        }else{
                            vc.type = tableViewCellType.category
                        }
                        self.tabItems.append((vc,categoryModel.cat_name))
                        self.sortArray?.append(("默认排序","default"))
                        self.keywordArray?.append("")
                    }
                    var option = TabPageOption()
                    option.currentColor = "ffffff".color
                    option.defaultColor = "f6b0ac".color
                    option.tabHeight = 39
                    self.option = option
                super.viewWillAppear(true)
                super.viewWillDisappear(true)
                super.viewDidLoad()
                self.view.addSubview(self.shareButton)
                self.shareButton.snp.makeConstraints { (make) in
                    make.right.equalTo(-10)
                    make.bottom.equalTo(-100)
                }
//                    self.performSegue(withIdentifier: "MMTabPageViewController", sender: nil)
                
                
            }
        }
    }
    
    @IBAction func share(_ sender: AnyObject) {
        
        if !self.toLogIn(){
            
            return;
        }
        
        if MMUserInfo.UserInfo.shop_share_normal_url == nil{
            self.show("请退出重新登录！", delay: 1);
            return;
        }
        share()
    }
    func share() {
        
        
        ///分享视图
        self.shareView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.shareView.animationType = .slide(way: .in, direction: .down);
        self.shareView.autoRun = false
        self.shareView.shareView.isHidden = true
        self.shareView.shopView.isHidden  = false
        self.shareView.cancleButton.isHidden = false
        self.shareView.shopEvent = {[unowned self]  (shopSharemodel) in
            self.shareView.url = URL.init(string:MMUserInfo.UserInfo.shop_share_normal_url.absoluteString + "?c=\(shopSharemodel.id!)")
          
            self.show()
        
            
            self.avatarsImageView.kf.setImage(with:shopSharemodel.shopAvatar, placeholder:nil , options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.dismiss()
                if image == nil{
                    self.shareView.image = UIImage.init(named: "mm_defaultAvatar")
                }else{
                    self.shareView.image = image
                }
                
            })
            
            self.qrcodeImageView.kf.setImage(with: URL.init(string: Key.shopQrCode + MMUserInfo.UserInfo.token! + "/" + shopSharemodel.id + "/" + "3"))
            
            self.shareView.title = shopSharemodel.shopName
            self.shareView.centerText = shopSharemodel.shopDescription
            
        }
        
        self.shareView.event = { [unowned self]   (type) in
            switch type {
            case .cancelType:
                self.hiddenShare()
                break
            case .loadQrCodeViewType:
                self.hiddenShare()
                self.hiddenQrcode()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            
            switch identifier {
            case "MMSortingTableViewController":
                let vc = segue.destination as!MMSortingTableViewController
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.permittedArrowDirections = .any
                vc.popoverPresentationController!.backgroundColor = Color.white
                vc.popoverPresentationController!.delegate = self
                vc.selectedItem = sortArray![self.currentIndex!]
                vc.selectdString = {[unowned self] srots in
                    self.sortArray![self.currentIndex!] = srots
                    let vc =  self.tabItems[self.currentIndex!].0 as!MMChooseGoodsShelvesTableViewController
                    vc.sort = srots
                    vc.page = 1
                    vc.goodsModelArray.removeAll()
                    vc.tableView.mj_footer.resetNoMoreData()
                    vc.tableView.reloadData()
                    vc.requestDta()
                }
            
            case "MMSearchGoodsViewController":
                let vc = segue.destination as!MMSearchGoodsViewController
                vc.type = .ordinaryGoods
            default: break
                
            } 
        }
    }
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.navigationBar.isTranslucent = true
        self.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if self.toLogIn(){
            self.performSegue(withIdentifier: "MMSearchGoodsViewController", sender: nil)
        }
        
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        return false
    }
    
}
