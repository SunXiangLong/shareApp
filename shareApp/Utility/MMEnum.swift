//
//  MMEnum.swift
//  ShareApp
//
//  Created by xiaomabao on 16/9/20.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import Foundation
///分享视图回调类型类型
public  enum buttonResponseType : Int{
    ///   取消分享，隐藏分享视图
    case  cancelType
    ///   隐藏分享视图，弹出二维码视图
    case  loadQrCodeViewType
    
}

///按钮的点击事件类型
public enum buttonClickEventType : Int {
    ///   分享按钮点击事件
    case share
    /// 上架和取消上架点击事件
    case shelves
    ///是否默认选中
    case isDefault
    ///编辑
    case edit
    ///删除
    case out
    
}
///pickView类型
public enum pickViewType : Int {
    /// 选择地址
    case address
    /// 选择开户行
    case depositBank
    ///取消
    case cancle
    
}
///获取图片设置类型
public enum shopImageType : Int {
    /// 选择店铺头像
    case shopAvatar
    /// 选择店铺top背景
    case shopBackground
    
}
///分类商品cell类型
public enum tableViewCellType : Int {
    /// 图片
    case brand
    /// 商品
    case category
    
    
    
}
///加载webview的内容
public enum LoadingWebviewType : Int {
    /// 商品详情
    case goodsDetails
    /// 活动网页
    case eventWebsite
    
}
///商品类型
public enum CommodityType : Int {
    /// 普通商品
    case ordinaryGoods
    /// vip商品
    case vipGoods
    
}
///支付类型
public enum PayType : Int {
    /// 开店大礼包支付
    case payGoodieBag
    /// 商品支付
    case payGoods
    
}

enum  PlaceholderType : Int {
     ///  无占位图
    case zero
    ///  正方形的占位图 120*120px
    case one
    /// 长方形的占位图  750*350px
    case two
    /// 长方形的占位图  122*162px
    case three


}
