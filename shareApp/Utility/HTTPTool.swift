//
//  HTTPTool.swift
//  xiaomabaodistribution
//
//  Created by liulianqi on 16/7/4.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
class HTTPTool {
    
    //        /// 创建一个请求的单例
    //        static let Manager = HTTPTool()
    //        /// 创建一个私有的初始化方法覆盖公共的初始化方法。
    //        private  init() {}
    //
    
    ///GET请求数据
    class  func Get(_ Url:String, parameters:[String: Any]?, completion:@escaping ([String: AnyObject]?, Error?) -> Void)-> Void{
        MBProgressHUD.show()
        Alamofire.request(URL(string: Url)!,method: .get , parameters: self.parameterAdd(parameters) , encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json","text/json","text/javascript","text/html"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                MBProgressHUD.dismiss()
                switch response.result {
                case .success:
                    self.logURL(String(describing: (response.response?.url)! as NSURL))
                    let JSON = response.result.value as?[String: AnyObject]
                    if  String(describing: JSON!["status"] as!NSNumber)  == "1"{
                        MBProgressHUD.show(JSON!["info"]as?String , delay: 1)
                    }else{
                        MBProgressHUD.show(JSON!["info"]as?String , delay: 1)
                    }
                    return completion(JSON,nil)
                case .failure(let error):
                    log(error)
                    
                    return completion(nil,error)
                    
                }
                
        }
        
    }
    
    /// POST请求数据.不带HUD
    ///
    /// - parameter Url:        请求网址
    /// - parameter parameters: body参数
    /// - parameter completion: 结果回调
    class func PostNoHUD(_ Url:String, parameters:[String: Any]?, completion:@escaping (MMBaseModel?, Error?) -> Void)-> Void{
        var theUrl = Url + "?"
        theUrl += self.query(self.parameterAdd(parameters))
        
        self.logURL(theUrl)
        Alamofire.request(URL(string: Url)!,method: .post, parameters: self.parameterAdd(parameters), encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json","text/json","text/javascript","text/html"])
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                switch response.result {
                case .success:
                    let value = response.result.value
                    let model = MMBaseModel.init(json: JSON(value!));
                    return completion(model,nil)
                case .failure(let error):
                    log(error)
                    MBProgressHUD.show("请求失败", delay: 0.7)
                    return completion(nil,error)
                    
                }
        }
        
        
    }
    
    ///POST请求数据 返回model对象
    class func Post(_ Url:String, parameters:[String: Any]?, completion:@escaping (MMBaseModel?, Error?) -> Void)-> Void{
        MBProgressHUD.show()
        var theUrl = Url + "?"
        theUrl += self.query(self.parameterAdd(parameters))
        self.logURL(theUrl)
        Alamofire.request(URL(string: Url)!,method: .post, parameters: self.parameterAdd(parameters), encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json","text/json","text/javascript","text/html"])
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                MBProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let value = response.result.value
                    
                    let model = MMBaseModel.init(json: JSON(value!))
                    if model.status != nil{
                        if  model.status  == (0){
                            MBProgressHUD.show(model.info , delay: 1.5)
                        }
                        return completion(model,nil)
                    }else{
                        return completion(model,nil)
                    }
                case .failure(let error):
                    MBProgressHUD.show("请求失败", delay: 0.7)
                    return completion(nil,error)
                }
        }
        
    }
    class func PostReturn(_ Url:String, parameters:[String: Any]?, completion:@escaping (MMBaseModel?, Error?) -> Void){
        MBProgressHUD.show()
        
        Alamofire.request(URL(string: Url)!,method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json","text/json","text/javascript","text/html"])
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                MBProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let value = response.result.value
                    let model = MMBaseModel.init(json: JSON(value!))
                    if model.status != nil{
                        if  model.status  == (0){
                            MBProgressHUD.show(model.info , delay: 1)
                        }
                        return completion(model,nil)
                    }else{
                        return completion(model,nil)
                    }
                case .failure(let error):
                    MBProgressHUD.show("请求失败", delay: 0.7)
                    return completion(nil,error)
                }
        }
        
    }
    
    ///post 返回json数据
    class func PostJson(_ Url:String, parameters:[String: Any]?, completion:@escaping (JSON?, Error?) -> Void)-> Void{
        MBProgressHUD.show()
        var theUrl = Url + "?"
        theUrl += self.query(self.parameterAdd(parameters))
        self.logURL(theUrl)
        Alamofire.request(URL(string: Url)!,method: .post, parameters: self.parameterAdd(parameters), encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json","text/json","text/javascript","text/html"])
            .validate(statusCode: 200..<300)
            .responseJSON{ response in
                MBProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let value = response.result.value
                    var json = JSON(value!)
                    if json["status"].number != nil{
                        if  json["status"].number  == (0){
                            MBProgressHUD.show(json["info"].string , delay: 1)
                        }
                        return completion(json,nil)
                    }else{
                        return completion(json,nil)
                    }
                case .failure(let error):
                    log(error)
                    MBProgressHUD.show("请求失败", delay: 0.7)
                    return completion(nil,error)
                }
        }
    }
    
    ///POST上传图片
    class func Upload(_ Url:String, parameters:[String: AnyObject]?, multipartFormData:@escaping ((MultipartFormData) -> Void),closure: ((Progress?) -> Void)?,completion:@escaping (MMBaseModel?, Error?) -> Void)-> Void{
        MBProgressHUD.show()
        self.logURL(Url)
        Alamofire.upload(multipartFormData: multipartFormData, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: URL(string: Url)!, method: .post, headers: nil, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: closure!)
                upload.responseJSON { response in
                    log(response)
                    MBProgressHUD.dismiss()
                    switch response.result{
                    case .success(let value) :
                        let model = MMBaseModel.init(json: JSON(value));
                        return completion(model,nil)
                    case .failure(let error) :
                        
                        MBProgressHUD.show("请求失败", delay: 0.7)
                        return completion(nil,error)
                        
                    }
                    
                }
                
            case .failure(_):
                MBProgressHUD.dismiss()
                MBProgressHUD.show("请求失败", delay: 1)
                
                
            }
            
        })
        
        
        
        
    }
    
    
    /**
     参数中一些固定不变的参数  在这个方法里添加 device_id   varchar 设备唯一标识
     device_desc varchar 设备信息
     
     - parameter parameters: 传过来的参数集合
     
     - returns: 添加后参数集合
     */
    fileprivate class   func parameterAdd( _ parameters:[String: Any]?) -> [String: Any] {
        var device = parameters
        device!["device_id"] = UUID() as Any?
        device!["device_desc"] = "ios" as Any?
        
        return device!
        
    }
    
    /// 参数拼接成链接URl的形式
    class  func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    class    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    class func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    ///  打印请求的完整链接
    class func logURL(_ url:String?) -> Void{
        
        log("---->请求的链接url:\(url)")
        
        
    }
}
