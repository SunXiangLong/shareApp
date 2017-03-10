//
//  AppDelegate.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/15.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import IBAnimatable
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,WXApiDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ///是否需要更新新版本
        updateInfo()
        ///友盟统计注册
        mobClick()
        /**解决键盘遮挡输入栏问题*/
        IQKeyboardManager.sharedManager().enable = true
        /***shareSdk分享初始化*/
        self.shareSDK()
        ///微信支付初始化
        WXApi.registerApp(APP_ID, withDescription: "共享购")
        ///极光推送注册
        jpusRegistered(launchOptions)
//        ///提醒用户去评价app
//        appirater()
        ///判断根视图
        refreshTokenRootVC()
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            
            
            log(aps)
        }
        UIApplication.shared.applicationIconBadgeNumber = 0;

        return true
        
    }
    
  

    
    
    //MARK: ----WXApiDelegate
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
            
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "AlipayPay"), object: nil, userInfo: resultDic))
        }
        return WXApi.handleOpen(url, delegate: self)
        
    }
    func onResp(_ resp: BaseResp!) {
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "WxPay"), object: nil, userInfo: ["resp":resp]))
    }
    //MARK: ----极光推送注册相关
    func  jpusRegistered(_ launchOptions: [AnyHashable: Any]?) -> Void {
        ///极光推送注册
        JPusService.JPUSHServiceFunc(launchOptions);
        
        ///监听是否收到极光推送消息
        NotificationCenter.default.addObserver(self, selector: #selector(self.jPusMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        JPusService.receiveMessage()
    }
    func jPusMessage(_ notification:Notification) ->Void{
        log(notification.userInfo)
        
    }
    
    
    //MARK: ----极光推送相关根据token是否过期 判断根视图为登录还是主界面
    func refreshTokenRootVC() -> Void {
        let userinfoDic =   UserDefaults.standard.value(forKey: "userinfo")
        log(userinfoDic)
        
        if userinfoDic != nil{
            let json =   JSON.init( userinfoDic as![String:AnyObject])
            let token = json["token"].string
            self.token(token!, block: { (isToken) in
                if isToken{
                    let model = MMBaseModel.init(json: json)
                    model.data = json
                    MMUserInfo.UserInfo.initUserInfo(model)
                
                }
                let TabBar = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as!UITabBarController
                self.window?.rootViewController = TabBar
            })


        }else{
            let TabBar = UIStoryboard(name: "ShopSeting", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as!UITabBarController
            self.window?.rootViewController = TabBar
        }
    }
    func token(_ token:String,block:(Bool)->Void) -> Void {
        let url = URL.init(string: API.refreshToken)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        let body = "token=" + token + "&" + "device_id=" + UUID() + "&" + "device_desc=" + "ios"
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
            let json = JSON.init(data: data)
            log(json)
            if json["status"].number == (1) {
                block(true)
            }else{
                block(false)
            }
        } catch{
            log("失败，未知错误")
        }
        
    }
    /// shareSDK初始化
      func shareSDK() -> Void {
        
        
        ShareSDK.registerApp("1585ca9d0d140", activePlatforms: [SSDKPlatformType.typeWechat.rawValue,SSDKPlatformType.typeCopy.rawValue], onImport: { (platform : SSDKPlatformType) in
            switch platform{
            case SSDKPlatformType.typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
            default:
                break
            }
        }) { (platform,appInfo) -> Void in
            switch platform {
            case SSDKPlatformType.typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: APP_ID, appSecret:APP_SECRET)
                break
            default:
                break
                
            }
        }
    }
    //MARK:--推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /***极光推送获取token*/
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        ///根据推送过来的信息进行对应的处理
        JPusService.receiveRemoteNotification(userInfo, windows: self.window!, application: application)
        /**
         IOS7 Support Required
         */
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        log("did Fail To Register For Remote Notifications With Error:\(error)")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
              // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
               // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    lazy var updateView:MMUpdateView =  {
        let updateView = Bundle.main.loadNibNamed("MMUpdateView", owner: nil, options: nil)?.last as!MMUpdateView
        return updateView
    }()
    /// 获取提示更新信息
    func updateInfo() -> Void {
        HTTPTool.PostNoHUD(API.commonUpdate, parameters: ["device":"ios"]) { (model, error) in
            guard let model = model else { return }
        
            let  updetemodel = updateModel.init(json: (model.data)!)
            
            if updetemodel.latestVersion > Key.Version {
               
                
                self.updateView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
                self.updateView.model = updetemodel;
                UIApplication.shared.keyWindow?.addSubview(self.updateView)
                self.updateView.updateView.animationType = .slide(way: .in, direction: .down)
                self.updateView.updateView.autoRun = true
            }

        }
        
    }
    
    
}

