//
//  MMShopSetTableViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class MMShopSetTableViewController: MMBaseTableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    var shopimagetype:shopImageType?
    var shopAvatar:UIImage?
    var shopBackground:UIImage?
    /// 店名
    @IBOutlet weak var shopNameTextField: UITextField!
    /// 店铺描述
    @IBOutlet weak var shopIntroducedTextView: UITextView!
    @IBOutlet weak var playhelod: UILabel!
    
    var model:ShopShareInfo?
    
    var indexPath:IndexPath?
    var isaddShop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺设置"
        self.tableView.tableFooterView = UIView()
        if isaddShop||model == nil {
            isaddShop = true
            
        }else{
            shopIntroducedTextView.text = model!.shopDescription
            shopNameTextField.text = model!.shopName
            playhelod?.isHidden = true;
            
        }
        
        self.rightBtn?.setTitle("保存", for: UIControlState())
        self.rightBtn?.setTitleColor("333333".color, for: UIControlState())
    }
    override func popViewControllerAnimated() -> Void {
        self.popViewController(animated: true)
    }
    override func rightBtnSelector() {
        if shopNameTextField.text == nil {
            self.show("请输入店铺名称", delay: 1)
            return
        }
        
        if shopIntroducedTextView.text == nil {
            self.show("请输入店铺描述", delay: 1)
            return
        }
        
        self.postData()
    }
   
    /**
     去相册（拍照）选择店铺头像
     */
    func choosePicture() -> Void {
        
      self.actionSheet(.shopAvatar)
    }
    
    /**
     去相册（拍照）选择店铺top背景
     */
    func chooseBackgroup() -> Void {
        self.actionSheet(.shopBackground)
    }
    
    func actionSheet(_ type:shopImageType) -> Void {
        self.shopimagetype = type
        
        let alertController = UIAlertController.init(title: "上传照片",message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction.init(title: "从相册获取", style:  .default, handler: {[unowned self]  action in
            let cameraController  = UIImagePickerController.init()
                cameraController.sourceType = .photoLibrary
                cameraController.delegate = self
                cameraController.isEditing = false
                self.present(cameraController, animated: true, completion: nil)

            
            }))
        alertController.addAction(UIAlertAction.init(title: "从相机获取", style:
            .default, handler: {[unowned self]  action in
            
            let cameraController  = UIImagePickerController.init()
                cameraController.sourceType = .camera
                cameraController.delegate = self
                cameraController.isEditing = false
                self.present(cameraController, animated: true, completion: nil)
        
            }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    /**
     提交修改数据
     */
    func postData() -> Void {
        var url:String
        if isaddShop {
            url = API.shopAddShare
        }else{
            url = API.shopUpdateShare
        }
        HTTPTool.Upload(url, parameters: nil, multipartFormData: { multipartFormData in
            if self.shopAvatar != nil {
               let  name = "shop_avatar"
               let fileName = "shop_avatar.jpg"
               let data = UIImageJPEGRepresentation(self.shopAvatar!, 1.0)
                multipartFormData.append(data!, withName: name, fileName: fileName, mimeType: "image/jpeg");
                
            }
            if self.shopBackground != nil{
               let  name = "shop_background"
               let  fileName = "shop_background.jpg"
               let data = UIImageJPEGRepresentation(self.shopBackground!, 1.0)
                multipartFormData.append(data!, withName: name, fileName: fileName, mimeType: "image/jpeg");
               
            
            }
            multipartFormData.append(MMUserInfo.UserInfo.token!.data(using: .utf8)!, withName: "token")
            multipartFormData.append(UUID().data(using: .utf8)!, withName: "device_id")
            multipartFormData.append("ios".data(using: .utf8)!, withName: "device_desc")
            multipartFormData.append(self.shopNameTextField.text!.data(using: .utf8)!, withName: "shop_name")
           multipartFormData.append(self.shopIntroducedTextView.text!.data(using: .utf8)!, withName: "shop_description")
            
            if !self.isaddShop {
                multipartFormData.append(self.model!.id.data(using: .utf8)!, withName: "share_id")
                
            
            }
            }, closure: { progress in
                
                log(progress)
                
        }) { (model, error) in
            if model != nil{
                log(model?.data)
//                var model:ShopShareInfo
                let shopShareModel = ShopShareInfo.init(json: (model?.data)!)
                if shopShareModel.isDefault == "1"{
                    MMUserInfo.UserInfo.shopShareModel = shopShareModel
                
                }
                if self.isaddShop {
                    MMUserInfo.UserInfo.shareInfo.append(shopShareModel)
                }else{
                    MMUserInfo.UserInfo.shareInfo[(self.indexPath?.row)!] = shopShareModel
                }
                self.show("保存成功", delay: 1)
                self.popViewController(animated: true)
                return
               
            }else{
                log("erro == \(error)")
            }
            
            
        }


}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UIImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    picker.dismiss(animated: true) { 
        
        let portraitImg = info["UIImagePickerControllerOriginalImage"] as! UIImage
       
        if  self.shopimagetype == shopImageType.shopBackground {


            let photoEditor = MMPhotoEditorController.init(baseImg: portraitImg, resultImgSize: CGSize(width: screenW - 50, height: (screenW - 50)*70/124))
            photoEditor.callBack = { [unowned self]  (image) in
            
                self.shopBackground  = image
                self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
            
            }
            self.present(photoEditor, animated: true, completion: nil)
          
        
        }else{
        

            let photoEditor = MMPhotoEditorController.init(baseImg: portraitImg, resultImgSize: CGSize(width: screenW - 100, height: (screenW - 100)))
            photoEditor.callBack = { [unowned self]  (image) in
                
                self.shopAvatar   = image
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                
            }
            self.present(photoEditor, animated: true, completion: nil)
            
        }
        
       
        }
    
    
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 60
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let  headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 10))
             headView.backgroundColor = "f3f3f3".color
        
        return headView
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MMShopSetTableTwoCell", for: indexPath)as!MMShopSetTableTwoCell
        cell.model = model
        cell.indexPath = indexPath
        
        if indexPath.row == 0 {
            if shopAvatar != nil {
                cell.shopInfoImageView.image = shopAvatar
            }
        
        }else{
            
            if shopBackground != nil {
                cell.shopInfoImageView.image = shopBackground
            }else{
                
            }
            
        
        }
            
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            switch indexPath.row {
            case 0:
                self.choosePicture()
                break
            case 1:
                 self.chooseBackgroup()
                break
            default:
                break
            }
        
        
       
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
              
    }
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            playhelod?.isHidden = false
        }
        else {
            playhelod?.isHidden = true
        }
    }

}
