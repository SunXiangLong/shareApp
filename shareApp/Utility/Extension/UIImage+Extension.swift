//
//  UIImage+Extension.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/22.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import ImageIO
import Accelerate
import Kingfisher
extension UIImage{

/// 截取指定位置的屏幕转出图片
    public func croppedImage(_ bounds:CGRect,scale:CGFloat) ->UIImage{
        let scale = max(self.scale, 1.0)
        print(scale)
        let scaledBounds = CGRect(x: bounds.origin.x * scale, y: bounds.origin.y * scale, width: bounds.size.width * scale, height: bounds.size.height * scale);
        let imageRef = self.cgImage!.cropping(to: scaledBounds)
        
       
        let croppedImage = UIImage.init(cgImage: imageRef!, scale: scale, orientation:.up)
        return croppedImage
    }
    
    
    /// 高斯模糊
    func gaussianBlur( _ bluramount:CGFloat) -> UIImage {
        var blurAmount = bluramount
        
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        if (blurAmount < 0.0 || blurAmount > 1.0) {
            blurAmount = 0.5
        }
        
        var boxSize = Int(blurAmount * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = self.cgImage
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        
        let inProvider =  img!.dataProvider
        let inBitmapData =  inProvider!.data
        
        inBuffer.width = vImagePixelCount(img!.width)
        inBuffer.height = vImagePixelCount(img!.height)
        inBuffer.rowBytes = img!.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        //手动申请内存
        let pixelBuffer = malloc(img!.bytesPerRow * img!.height)
        
        outBuffer.width = vImagePixelCount(img!.width)
        outBuffer.height = vImagePixelCount(img!.height)
        outBuffer.rowBytes = img!.bytesPerRow
        outBuffer.data = pixelBuffer
        
        var error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if (kvImageNoError != error)
        {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if (kvImageNoError != error)
            {
                error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                                   &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                                   UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data,
                                        width: Int(outBuffer.width),
                                        height: Int(outBuffer.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: outBuffer.rowBytes,
                                        space: colorSpace,
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let imageRef = ctx!.makeImage()
        
        //手动申请内存
        free(pixelBuffer)
        return UIImage(cgImage: imageRef!)
    }
   
}
extension UIImageView{
      /// 设置图片居中铺满，多出的裁减掉
    func imageViewFill() -> Void {
        self.contentMode = .scaleAspectFill
        self.autoresizingMask = .flexibleHeight
        self.clipsToBounds = true
    }
    func setImage(_ url:URL?,image:UIImage) -> Void {
    
        if let url = url {
            self.kf.setImage(with: url, placeholder: image , options: nil, progressBlock: nil, completionHandler: nil)
        }
    
    }
    func setImage(_ url:URL?,type:PlaceholderType) -> Void {
        if  url == nil {
            return
        }
        var placeholderImage = #imageLiteral(resourceName: "mm_placeholder1")
        
        switch type {
        case .zero:
            self.kf.setImage(with: url)
        case .one:
            placeholderImage = #imageLiteral(resourceName: "mm_placeholder1")
        case .two:
            placeholderImage = #imageLiteral(resourceName: "mm_placeholder2")
        case .three:
            placeholderImage = #imageLiteral(resourceName: "mm_placeholder3")
        }
        
        self.kf.setImage(with: url, placeholder: placeholderImage , options: nil, progressBlock: nil, completionHandler: nil)
        
    }

}
