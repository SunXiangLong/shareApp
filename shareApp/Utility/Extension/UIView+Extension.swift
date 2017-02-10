//
//  UIView+Extension.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/15.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
extension UIView {
    
    

    /// x
    public final var sxl_x: CGFloat {
        set(x) {
            frame.origin.x = x
        }
        
        get {
            return frame.origin.x
        }
    }
    /// y
    public final var sxl_y:CGFloat {
        set(y) {
            frame.origin.y = y
        }
        
        get {
            return frame.origin.y
        }
    }
    /// centerX
    public final var sxl_centerX: CGFloat {
        set(centerX) {
            center.x = centerX
        }
        
        get {
            return center.x
        }
    }
    /// centerY
    public final var sxl_centerY: CGFloat {
        set(centerY) {
            center.y = centerY
        }
        
        get {
            return center.y
        }
    }
    /// width
    public final var sxl_width: CGFloat {
        set(width) {
            frame.size.width = width
        }
        
        get {
            return bounds.size.width
        }
    }
    /// height
    public final var sxl_height: CGFloat {
        set(height) {
            frame.size.height = height
        }
        
        get {
            return bounds.size.height
        }
    }
    
}
