//
//  PublicTool.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/15.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
//import Appirater
import Kingfisher
import RxCocoa
import RxSwift
public let NeueFont:String = "HelveticaNeue"
public let ThinFont:String = "PingFangSC-Thin"
public let LightFont:String = "PingFangSC-Light"
public let RegularFont:String = "PingFangSC-Regular"
/// 屏幕宽度
let screenW = UIScreen.main.bounds.width
/// 屏幕高度
let screenH = UIScreen.main.bounds.height

 let  disposeBag = DisposeBag()
///全局获取RGBA颜色
public func RGBA(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) ->UIColor
{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    
    
}
///全局获取RGBA颜色
public func RGB(_ r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor
{
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    
}
/**
 在调试程序时，很多开发者喜欢用输出 log 的方式对代码的运行进行追踪，帮助理解。Swift 编译器并
 会帮我们将 log 或者 debuglog 删去，在最终 app 中它们会把内容输出到终端，造成性能的损
 失。我们当然可以在发布时用查找的方式将所有这些 log 输出语句删除或者注释掉，但是更好的方法是通过
 添加条件编译来将这些语句排除在 Release 版本外。在 Xcode 的 Build Setting 中，在 Other
 Swift flags 的 Debug 栏中加入 -D DEBUG 即可加入一个编译标识。
 */
func log<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]  \(message)")
        
    #endif
}
///启动页
func startPage(_ view:UIView) -> Void {
    
    if  !UserDefaults.standard.bool(forKey: "walkthroughPresented") {
        showWalkthrough(view)
        UserDefaults.standard.set(true, forKey: "walkthroughPresented")
        UserDefaults.standard.synchronize()
    }
}
private func showWalkthrough(_ view:UIView) -> Void {
    
    let item1 = RMParallaxItem(image: UIImage(named: "mm_startPage1")!, text: "")
    let item2 = RMParallaxItem(image: UIImage(named: "mm_startPage2")!, text: "")
    let item3 = RMParallaxItem(image: UIImage(named: "mm_startPage3")!, text: "")
    
    
    let rmParallaxView = RMParallax.init(items: [item1, item2, item3], motion: false, frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
    rmParallaxView.completionHandler = {
        UIView.animate(withDuration: 0.4, animations: {
            rmParallaxView.alpha = 0.0
            }, completion: { (bool) in
                rmParallaxView.removeFromSuperview()
        })
        
    }
    
    view.addSubview(rmParallaxView)
    
    
}
///统计缓存文件大小
func fileSizeOfCache()-> Int {
 
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    //缓存目录路径
    log(cachePath)
    
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
    //快速枚举出所有文件名 计算文件大小
    var size = 0
    for file in fileArr! {
        
        // 把文件名拼接到路径中
        let path = (cachePath)! + "/\(file)"
        // 取出文件属性
        let floder = try! FileManager.default.attributesOfItem(atPath: path)
        // 用元组取出文件大小属性
        for (abc, bcd) in floder {
            // 累加文件大小
            if abc == FileAttributeKey.size {
                size += (bcd as AnyObject).intValue
            }
        }
    }
    
    let mm = size / 1024 / 1024
    
    return mm
}

func deleteCookie() -> Void {
    
    let cookieStorage = HTTPCookieStorage.shared
    let cookies = HTTPCookieStorage.shared.cookies
    
    cookies!.forEach{
        cookieStorage.deleteCookie($0)
    }
}
///删除缓存
func clearCache() {
    MBProgressHUD.show()
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
    // 遍历删除
    for file in fileArr! {
        
        let path = (cachePath)! + "/\(file)"
        if FileManager.default.fileExists(atPath: path) {
            
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                
            }
        }
    }
    MBProgressHUD.dismiss()
}
///去除空格和回车
public func trimLineString(_ str:String)->String{
    let nowStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return nowStr
}
///获取设备UUID
public func UUID() ->String{
    var UUID:String?  =  UserDefaults.standard.value(forKey: "UUID") as! String!
    if UUID == nil {
        UUID = Foundation.UUID().uuidString
        UserDefaults.standard.set(UUID, forKey: "UUID")
        //设置同步
        UserDefaults.standard.synchronize()
    }

    return UUID!
    
}
/////提醒用户评价app  安装应用1天后提醒5次   点击以后提醒 推迟两天提醒评价
//public func appirater() -> Void {
//    Appirater.setAppId(Key.ShareAppAppId)
//    Appirater.setDaysUntilPrompt(5)
//    Appirater.setUsesUntilPrompt(10)
//    Appirater.setSignificantEventsUntilPrompt(-1)
//    Appirater.setTimeBeforeReminding(2)
//    Appirater.setDebug(false)
//    Appirater.appLaunched(true)
//}

///友盟统计注册
public func mobClick() -> Void {
    let  XcodeAppVersion =  Bundle.main.infoDictionary!["CFBundleShortVersionString"]as!String
    let configure = UMAnalyticsConfig()
    configure.appKey = Key.umengAppKey
    MobClick.setAppVersion(XcodeAppVersion)
    MobClick.start(withConfigure: configure)
}

extension String{
    //MARK: -字符串替换
    func myreplace(_ oldStr:String,newStr:String)->String{
        return self.replacingOccurrences(of: oldStr, with: newStr, options: NSString.CompareOptions.numeric, range: nil)
    }
    ///swift md5加密
    func md5() ->String!{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
}
