//
//  Color+Extension.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/15.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
public typealias Color = UIColor
//MARK: - Color extension
public func ==(lhs: Color, rhs: Color) -> Bool{
    let (lRed, lGreen, lBlue, lAlpha) = lhs.colorComponents()
    let (rRed, rGreen, rBlue, rAlpha) = rhs.colorComponents()
    return fabsf(Float(lRed - rRed)) < FLT_EPSILON
        && fabsf(Float(lGreen - rGreen)) < FLT_EPSILON
        && fabsf(Float(lBlue - rBlue)) < FLT_EPSILON
        && fabsf(Float(lAlpha - rAlpha)) < FLT_EPSILON
}

public extension Color {
    
    public convenience init(_ hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    public convenience init(hexInt: Int, alpha: Float = 1.0) {
        var hexString = NSString(format: "%0X", hexInt)
        if hexInt <= 0xfff {
            hexString = NSString(format: "%03X", hexInt)
        }else if hexInt <= 0xffff {
            hexString = NSString(format: "%04X", hexInt)
        }else if hexInt <= 0xffffff {
            hexString = NSString(format: "%06X", hexInt)
        }
        self.init(hexString: hexString as String, alpha: alpha)
    }
    
    public convenience init(hexString: String, alpha: Float = 1.0) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var mAlpha: CGFloat = CGFloat(alpha)
        var minusLength = 0
        
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
            minusLength = 1
        }
        if hexString.hasPrefix("0x") {
            scanner.scanLocation = 2
            minusLength = 2
        }
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        switch hexString.characters.count - minusLength {
        case 3:
            red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue = CGFloat(hexValue & 0x00F) / 15.0
        case 4:
            red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            mAlpha = CGFloat(hexValue & 0x00F) / 15.0
        case 6:
            red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8:
            red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            mAlpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
            break
        }
        self.init(red: red, green: green, blue: blue, alpha: mAlpha)
    }
    
    public func alpha(_ value: Float) -> Color {
        let (red, green, blue, _) = colorComponents()
        return Color(red: red, green: green, blue: blue, alpha: CGFloat(value))
    }
    
    public func red(_ value: Int) -> Color {
        let (_, green, blue, alpha) = colorComponents()
        return Color(red: CGFloat(value)/255.0, green: green, blue: blue, alpha: alpha)
    }
    
    public func green(_ value: Int) -> Color {
        let (red, _, blue, alpha) = colorComponents()
        return Color(red: red, green: CGFloat(value)/255.0, blue: blue, alpha: alpha)
    }
    
    public func blue(_ value: Int) -> Color {
        let (red, green, _, alpha) = colorComponents()
        return Color(red: red, green: green, blue: CGFloat(value)/255.0, alpha: alpha)
    }
    
    public func colorComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        #if os(iOS)
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #elseif os(OSX)
            self.colorUsingColorSpaceName(NSCalibratedRGBColorSpace)!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #endif
        return (red, green, blue, alpha)
    }
    
}

//public extension Color {
//    
//    public class var black: Color {
//        return self.black
//    }
//    
//    public class var darkGray: Color {
//        return self.darkGray
//    }
//    
//    public class var lightGray: Color {
//        return self.lightGray
//    }
//    
//    public class var white: Color {
//        return self.white
//    }
//    
//    public class var gray: Color {
//        return self.gray
//    }
//    
//    public class var red: Color {
//        return self.red
//    }
//    
//    public class var green: Color {
//        return self.green
//    }
//    
//    public class var blue: Color {
//        return self.blue
//    }
//    
//    public class var cyan: Color {
//        return self.cyan
//    }
//    
//    public class var yellow: Color {
//        return self.yellow
//    }
//    
//    public class var magenta: Color {
//        return self.magenta
//    }
//    
//    public class var orange: Color {
//        return self.orange
//    }
//    
//    public class var purple: Color {
//        return self.purple
//    }
//    
//    public class var brown: Color {
//        return self.brown
//    }
//    
//    public class var clear: Color {
//        return self.clear
//    }
//    
//}

public extension String {
    
    public var color: Color {
        return Color.init(hexString: self, alpha: 1.0)
    }
    
}

public extension Int {
    
    public var color: Color {
        return Color(hexInt: self)
    }
    
}

public extension Color {
    
    public func toImage(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
