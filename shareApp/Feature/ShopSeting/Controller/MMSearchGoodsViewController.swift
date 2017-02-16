//
//  MMSearchGoodsViewController.swift
//  ShareApp
//
//  Created by xiaomabao on 2016/10/8.
//  Copyright © 2016年 sunxianglong. All rights reserved.
import UIKit
import IBAnimatable
import RxSwift
import RxCocoa
class MMSearchGoodsViewController: MMBaseCollectionViewController {
    var type:CommodityType?
    lazy var hotRecommendedArray:[MMBrandModel] = {
        return [MMBrandModel]()
    }()
    lazy  var searchHistoryArray:[String] = {
        var searchHistory = [String]()
        if let  search = UserDefaults.standard.value(forKey: "searchHistory")  {
            searchHistory = search as! [String]
        }
        return searchHistory
    }()
    
    
    lazy var dataArray:[[AnyObject]] = {
        return [[AnyObject]]()
    }()
    lazy var shareView:MMShareView =  {
        let shareView = Bundle.main.loadNibNamed("MMShareView", owner: nil, options: nil)?.last as!MMShareView
        return shareView
    }()
    
    lazy var source:[String] = {
        var data =  [String]()
        if let sou = UserDefaults.standard.value(forKey: "source"){
            data = sou as! [String]
            
        }
        return data
    }()
    lazy  var viewModel:ViewModel = {
        
        var viewModel = ViewModel()
        viewModel.type = self.type
        return viewModel
        
    }()
    
    @IBOutlet var tabeleView: UITableView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchTextField: AnimatableTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.searchView.superview != nil {
            self.searchView.isHidden = false
            self.tabeleView.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.isHidden = true
        self.tabeleView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hotRecommendedData()
        self.searchView.frame = CGRect(x: 0, y: 0, width: screenW, height: 44)
        self.navigationController?.navigationBar.addSubview(self.searchView)
        self.searchTextField.becomeFirstResponder()
        
        searchTextField.rx.text.orEmpty.bindNext({ [unowned self]  value in
            
            if value == ""{
                self.tabeleView.removeFromSuperview()
            }
        }).addDisposableTo(disposeBag)
        
        self.tabeleView.rowHeight = 164
        self.tabeleView.tableFooterView = UIView()
        
        let results
            = searchTextField
                .rx.text
                .orEmpty
                .asDriver()
                .filter{
                    // 只有当搜索关键不为空字符串切字符串长度大于0 并且可以搜索才会走flatMapLatest方法
                    $0 !=  "" && $0.characters.count > 0&&self.viewModel.isSearch.value
                }
                .flatMapLatest{[unowned self]   query in
                    self.viewModel.getRepositories(query)
                        .retry(3)
                        .startWith([]) // clears results on new search term
                        .asDriver(onErrorJustReturn: [])
                    
        }
        
        
        
        results
            .asObservable()
            .skip(1)
            .bindNext({[unowned self]  (modelArr) in
                if self.tabeleView.superview == nil{
                    self.tabeleView.frame = CGRect(x: 0, y: 64, width: screenW, height: screenH-64)
                    UIApplication.shared.keyWindow?.addSubview(self.tabeleView)
                }
                if self.searchTextField.text == ""{
                    self.tabeleView.removeFromSuperview()
                    
                    return
                }
                log(modelArr.count)
                
                
                if  modelArr.count == 0{
                    self.tabeleView.removeFromSuperview()
                    if self.viewModel.isSearch.value {

                        self.show("搜索不到该商品", delay: 1)
                    }
                }else{
                    
                    
                    if self.searchTextField.text!.characters.count < 2{
                        return;
                    }
                    if !self.searchHistoryArray.contains(self.searchTextField.text!){
                        self.searchHistoryArray.append(self.searchTextField.text!)
                    }
                    
                    UserDefaults.standard.set(self.searchHistoryArray, forKey: "searchHistory")
                    UserDefaults.standard.synchronize()
                }
                
                self.viewModel.isSearch.value = false
                 
             
            })
            .addDisposableTo(disposeBag)
        
        switch type! {
        case .ordinaryGoods:
            
            results
                .drive(tabeleView.rx.items(cellIdentifier: "MMGoodsTableViewCell")) {[unowned self] (index, repository, cell) in
                    let cell = cell as! MMGoodsTableViewCell
                    cell.goodsModel = repository
                    cell.indexPath = IndexPath.init(row: index, section: 0)
                    cell.uiedgeInsetsZero()
                    cell.buttonEventType = { [unowned self] (model,indexPath,type) in
                        if type == buttonClickEventType.share {
                            self.share(model, image: cell.goodsThumbImageView.image!)
                        }else{
                            self.goodsOnSale(model, indexPath: indexPath)
                        }
                    }
                }.addDisposableTo(disposeBag)
            
        case .vipGoods:
            results
                .drive(tabeleView.rx.items(cellIdentifier: "MMVIPGoodsListTableViewCell")) {[unowned self] (index, repository, cell) in
                    let cell = cell as! MMVIPGoodsListTableViewCell
                    cell.goodsModel = repository
                    cell.indexPath = IndexPath.init(row: index, section: 0) //NSIndexPath.init(forRow: index, inSection:0)
                    cell.uiedgeInsetsZero()
                    cell.buttonEventType = {[unowned self]  (model,indexPath,type) in
                        self.share(model, image: cell.goodsThumbImageView.image!)
                        
                    }
                }.addDisposableTo(disposeBag)
            
        }
        tabeleView.rx.modelSelected(MMGoodsModel.self).bindNext({[unowned self]  value in
            self.searchTextField.resignFirstResponder()
            self.performSegue(withIdentifier: "MMGoodsDetailsViewController", sender: value)
        }).addDisposableTo(disposeBag)
        
        
        
    }
    
    
    
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
            self.shareView.url = URL.init(string:model.share_url.absoluteString + "?c=\(shopSharemodel.id!)" )
            
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
                    self.tabeleView.reloadRows(at: [indexPath], with: .automatic)
                    
                    self.show(model?.info, delay: 1)
                }
                
            }
            
        }
    }
    func hotRecommendedData() -> Void {
        
        HTTPTool.Post(API.searchIndex, parameters: ["token":MMUserInfo.UserInfo.token!]) { (model, error) in
            if model != nil{
                //                log(model?.data)
                self.hotRecommendedArray =  (model?.data!["hot"].array!.map{
                    MMBrandModel.init(json: $0)
                    })!
                self.dataArray.append(self.hotRecommendedArray)
                self.dataArray.append(self.searchHistoryArray as [AnyObject])
                
                
                self.collectionView?.reloadData()
                
            }else{
                log(error)
            }
        }
        
    }
    
    @IBAction func cancle(_ sender: AnyObject) {
        searchTextField.resignFirstResponder()
        self.tabeleView.removeFromSuperview()
        self.searchView.removeFromSuperview()
        self.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let identifier =  segue.identifier {
            switch identifier {
            case "MMGoodsDetailsViewController":
                let controller = segue.destination as! MMGoodsDetailsViewController
                
                let model = sender as!MMGoodsModel
                controller.type = LoadingWebviewType.goodsDetails
                controller.url = model.buy_url
            case "MMBrandGoodsListTableViewController":
                let controller = segue.destination as! MMBrandGoodsListTableViewController
                let indexPath = sender as! IndexPath
                let model = dataArray[indexPath.section][indexPath.row] as!MMBrandModel
                controller.brandModel = model
                controller.title = model.title
                controller.type = CommodityType.ordinaryGoods
            default:break
            }
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray[section].count
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let rusableView  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MMSearchGoodsReusableHeaderView", for: indexPath) as? MMSearchGoodsReusableView
            
            
            if indexPath.section == 0 {
                rusableView?.title.text = "热门推荐"
                rusableView?.deleteButton.isHidden = true
            }else{
                rusableView?.title.text = "搜索历史"
                rusableView?.deleteButton.isHidden = false
                
            }
            rusableView?.deleteAll = {[unowned self]    () in
                self.searchHistoryArray.removeAll()
                self.dataArray[1] = self.searchHistoryArray as [AnyObject]
                UserDefaults.standard.set(self.searchHistoryArray, forKey: "searchHistory")
                UserDefaults.standard.synchronize()
                self.collectionView?.reloadData()
            }
            return rusableView!
        default: return UICollectionReusableView()
            
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMSearchGoodsViewCell", for: indexPath) as! MMSearchGoodsViewCell
        
        switch indexPath.section {
        case 0:
            let model = dataArray[indexPath.section][indexPath.row] as!MMBrandModel
            cell.namel.text = model.title
        case 1:
            cell.namel.text = dataArray[indexPath.section][indexPath.row] as? String
        default:break
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        var str = ""
        switch indexPath.section {
        case 0:
            let model = dataArray[indexPath.section][indexPath.row] as!MMBrandModel
            str = model.title!
        case 1:
            str = (dataArray[indexPath.section][indexPath.row] as? String)!
        default:break
            
        }
        
        var  w = str.stringWithSize(CGSize(width: 999, height: 30), font: UIFont.systemFont(ofSize: 12)).width + 36
        
        if w > screenW - 30 {
            w = screenW - 30
        }
        return  CGSize(width: w,height: 30)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.isSearch.value = true
        switch indexPath.section {
        case 0:
            let model = dataArray[indexPath.section][indexPath.row] as! MMBrandModel
            searchTextField.text = model.title
            if self.searchTextField.becomeFirstResponder() {
                self.searchTextField.resignFirstResponder()
            }else{
                self.searchTextField.becomeFirstResponder()
                
            }
            
        case 1:
            searchTextField.text = dataArray[indexPath.section][indexPath.row] as? String
            if self.searchTextField.becomeFirstResponder() {
                self.searchTextField.resignFirstResponder()
            }else{
                self.searchTextField.becomeFirstResponder()
                
            }
        default:break
        }
    }
    
    
}
extension MMSearchGoodsViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.viewModel.isSearch.value = true
        self.searchTextField.resignFirstResponder()
        return false
    }
    
}
