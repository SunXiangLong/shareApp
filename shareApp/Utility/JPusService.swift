//
//  JPusService.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/3.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
class JPusService : NSObject{
    
    
    ///极光推送初始化
  class func JPUSHServiceFunc(_ launchOptions: [AnyHashable: Any]?) ->Void{
        JPUSHService.register( forRemoteNotificationTypes: 1 | 2 | 3, categories: nil)
        JPUSHService.setup(withOption: launchOptions, appKey: Key.jiguangAppKey, channel: Key.Channel, apsForProduction: false)
   
    
    }
    
    ///极光推送初始化 监听有没有收到推送消息（不是通知
    class func receiveMessage() ->Void{
    NotificationCenter.default.addObserver(self, selector: #selector(self.jPusMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
    }
    
     ///监听有没有收到推送远程通知
   class func receiveRemoteNotification(_ userInfo:[AnyHashable: Any],windows:UIWindow,application:UIApplication) -> Void {
        
      
        log(userInfo)
    }
    
      func jPusMessage(_ notification:Notification) ->Void{
        log(notification.userInfo)
    
    }
    
}
