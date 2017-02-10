//
//  MMPhotoEditorViewController.swift
//  LoveTrail
//
//  Created by Xiaoqiang Zhang on 16/3/16.
//  Copyright © 2016年 Xiaoqiang Zhang. All rights reserved.
//

import UIKit

let SCALE_FRAME_Y    = 100.0
let BOUNDCE_DURATION = 0.3

 protocol MMPhotoEditorDelegate : NSObjectProtocol {
    func photoKitController(_ photoKitController:MMPhotoEditorViewController,resultImage:UIImage)->Void
}
class MMPhotoEditorController: UIViewController {
    
    let clipperView = HKClipperVeiw.init()
    
    var callBack:((UIImage)->Void)?
    /// 取消按钮
    lazy  fileprivate var buttonCancel:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 16, y: screenH-28-16, width: 40, height: 28))
        button.backgroundColor = RGBA(0, g: 0, b: 0, a:50.0/255)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("取消", for: UIControlState())
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = RGBA(255, g: 255, b: 255, a: 60.0/255).cgColor
        button.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        return button
    }()
    /// 确认按钮
    lazy fileprivate var buttonConfirm:UIButton = {
        let button = UIButton.init(frame: CGRect(x: screenW-40-16, y: screenH-28-16, width: 40, height: 28))
        button.backgroundColor = RGBA(0, g: 0, b: 0, a:50.0/255)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("确定", for: UIControlState())
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = RGBA(255, g: 255, b: 255, a: 60.0/255).cgColor
        button.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(baseImg:UIImage, resultImgSize:CGSize) {
        self.init(nibName: nil, bundle: nil)
        clipperView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        clipperView.backgroundColor = Color.black
        clipperView.resultImgSize = resultImgSize
        clipperView.baseImg = baseImg
        self.view.addSubview(clipperView)
        self.view.addSubview(buttonCancel)
        self.view.addSubview(buttonConfirm)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.black
        
    }
    
    
    ///取消
    func cancel() -> Void {
        
        self.dismiss(animated: true, completion: nil)
    }
    /**
     确定
     */
    func confirm() -> Void {
        self.callBack!(clipperView.clipImg())
        self.dismiss(animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
class MMPhotoEditorViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var   sacle:CGFloat?
    /// 修剪的位置
    fileprivate var rectClip:CGRect?
     /// 原始图片, 必须设置
     var imageOriginal:UIImage?
     /// 图片的尺寸,剪切框，最好是需求图片的2x, 默认是CGSizeMake(ScreenWidth, ScreenWidth)
    var sizeClip :CGSize? = CGSize(width: screenW, height: screenW)
     /// 代理对象
     weak var delegate:MMPhotoEditorDelegate?
    /// 图片
    lazy  fileprivate var imageView:UIImageView = {
        let imageView  = UIImageView.init(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        return imageView
    }()
    /// 取消按钮
    lazy  fileprivate var buttonCancel:UIButton = {
          let button = UIButton.init(frame: CGRect(x: 16, y: screenH-28-16, width: 40, height: 28))
          button.backgroundColor = RGBA(0, g: 0, b: 0, a:50.0/255)
          button.setTitleColor(UIColor.white, for: UIControlState())
          button.setTitle("取消", for: UIControlState())
          button.clipsToBounds = true
          button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
          button.layer.cornerRadius = 2
          button.layer.borderWidth = 0.5
          button.layer.borderColor = RGBA(255, g: 255, b: 255, a: 60.0/255).cgColor
          button.addTarget(self, action: #selector(MMPhotoEditorViewController.cancel), for: .touchUpInside)
          return button
    }()
    /// 确认按钮
    lazy fileprivate var buttonConfirm:UIButton = {
        let button = UIButton.init(frame: CGRect(x: screenW-40-16, y: screenH-28-16, width: 40, height: 28))
        button.backgroundColor = RGBA(0, g: 0, b: 0, a:50.0/255)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("确定", for: UIControlState())
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = RGBA(255, g: 255, b: 255, a: 60.0/255).cgColor
        button.addTarget(self, action: #selector(MMPhotoEditorViewController.confirm), for: .touchUpInside)
        return button
    }()

    /// 覆盖图
    lazy  fileprivate var viewOverlay:UIView = {
        let view = UIView.init(frame: self.view.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.6
        return view
    
    }()
    /// 虚线框
     fileprivate let  tailorImageView = UIImageView.init(image: UIImage.init(named: "caijian_bg"))
    /// 图片返回初始状态
    lazy fileprivate var buttonBack:UIButton = {
        let button = UIButton.init(frame: CGRect(x: screenW-40-16, y: screenH-28-16, width: 40, height: 28))
        button.sxl_centerX = screenW/2
        button.backgroundColor = RGBA(0, g: 0, b: 0, a:50.0/255)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("复原", for: UIControlState())
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = RGBA(255, g: 255, b: 255, a: 60.0/255).cgColor
        button.isHidden = true
        button.addTarget(self, action: #selector(MMPhotoEditorViewController.recover), for: .touchUpInside)
        return button
    }()

    
  
  deinit {
    
    self.imageOriginal  = nil
    self.sizeClip = nil
    self.delegate = nil
  

    
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(originalImage:UIImage, sizeClip:CGSize) {
    self.init(nibName: nil, bundle: nil)
    self.imageOriginal = originalImage
    self.sizeClip = sizeClip
    self.rectClip = CGRect(x: (screenW - self.sizeClip!.width)/2, y: (screenH - self.sizeClip!.height)/2, width: self.sizeClip!.width, height: self.sizeClip!.height)
    self.imageView.image = imageOriginal;
    
    sacle  =  self.imageView.image!.size.width / self.imageView.frame.size.width
    
        
    
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    
      self.initView()
    
  }

  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override var shouldAutorotate : Bool {
    return false
  }
  

  
  // initView
  func initView() ->Void {
    
    self.view.backgroundColor = UIColor.black
    self.setHollowWithCenterFrame(self.rectClip!, view: self.viewOverlay)
    self.tailorImageView.frame = self.rectClip!
    self.tailorImageView.center = self.view.center
    self.view.addSubview(self.imageView)
    self.view.addSubview(self.viewOverlay)
    self.view.addSubview(self.buttonCancel)
    self.view.addSubview(self.buttonBack)
    self.view.addSubview(self.buttonConfirm)
    self.view.addSubview(tailorImageView)
    self.addGestureRecognizerToView(self.view)
    
    
    
    
  }
    ///添加所有的手势
    fileprivate   func addGestureRecognizerToView(_ view:UIView) -> Void {
        // 旋转手势
        let rotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(self.rotateView(_:)))
        view.addGestureRecognizer(rotationGestureRecognizer)
        // 缩放手势
        let pinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(self.pinchView(_:)))
         view.addGestureRecognizer(pinchGestureRecognizer)
       // 移动手势
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.panView(_:)))
        view.addGestureRecognizer(panGestureRecognizer)

        
       
        
    }
    ///画要截取的位置
fileprivate  func setHollowWithCenterFrame(_ centerFrame:CGRect, view:UIView) -> Void {
            let path = UIBezierPath.init()
            path.append(UIBezierPath.init(rect: view.frame))
            path.append(UIBezierPath.init(rect: centerFrame).reversing())
            let maskLayer = CAShapeLayer.init()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer

    }
    ///取消
    func cancel() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    /**
     确定
     */
    func confirm() -> Void {
         self.dismiss(animated: true, completion: nil)
        if self.delegate != nil  {
            self.delegate?.photoKitController(self, resultImage: self.getResultImage())
        }
    }
    /**
     还原
     */
    func recover() -> Void {
        
        self.buttonBack.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { 
            
            self.imageView.transform = CGAffineTransform(rotationAngle: 0)
            self.imageView.frame = self.view.bounds
            
            }) { (finished) in
                
        }
        
    }
        ///处理旋转手势
    func rotateView(_ rotationGestureRecognizer:UIRotationGestureRecognizer) -> Void {
        
        self.buttonBack.isHidden = false
        let view = self.imageView as UIView
        if rotationGestureRecognizer.state == .began || rotationGestureRecognizer.state == .changed  {
            view.transform = view.transform.rotated(by: rotationGestureRecognizer.rotation)
            rotationGestureRecognizer.rotation = 0
        }

    }
    ///处理缩放手势
    func pinchView(_ pinchGestureRecognizer:UIPinchGestureRecognizer) -> Void {
        
        self.buttonBack.isHidden = false
        let view = self.imageView as UIView

        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed  {
            view.transform = view.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1
        }
        
    }
    ///处理拖拉手势
    func panView(_ panGestureRecognizer:UIPanGestureRecognizer) -> Void {
        
        self.buttonBack.isHidden = false
        let view = self.imageView as UIView
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed  {

            let translation = panGestureRecognizer.translation(in: view.superview)
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            
            panGestureRecognizer.setTranslation(CGPoint.zero, in: view.superview)
            
        }
        
    }

   ///获取截取的图片
 fileprivate   func getResultImage() -> UIImage {
         self.tailorImageView.isHidden = true
        let image = self.imageFromSelfView(self.view)
        let  scale = UIScreen.main.scale * sacle!
    

        return image.croppedImage(self.rectClip!,scale: scale)
    
//        return clipImg()
    }
    
    func clipImg() -> UIImage {
       
        let  scale = UIScreen.main.scale * sacle!
        
        let  rect =  self.view.convert(rectClip!, to: imageView)
        let  rect2 =  CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: scale * rect.size.width, height: scale * rect.size.height)
        let imageRef = imageOriginal!.cgImage!.cropping(to: rect2)
        
         let croppedImage = UIImage.init(cgImage: imageRef!, scale:scale, orientation:.up)
        
        return croppedImage
    }
    ///获取屏幕图片
   fileprivate func imageFromSelfView(_ view:UIView) -> UIImage {

        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        UIRectClip(view.frame)
        view.layer.render(in: context!)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
        return theImage!
    }
    
//  func handleBorderOverflow(frame:CGRect) -> CGRect {
//    var newFrame = frame
//    if newFrame.origin.x > self.cropFrame!.origin.x {
//      newFrame.origin.x = self.cropFrame!.origin.x
//    }
//    if CGRectGetMaxX(newFrame) < self.cropFrame!.size.width {
//      newFrame.origin.x = self.cropFrame!.size.width - newFrame.size.width
//    }
//    
//    if newFrame.origin.y > self.cropFrame!.origin.y {
//      newFrame.origin.y = self.cropFrame!.origin.y
//    }
//    if CGRectGetMaxY(newFrame) < self.cropFrame!.origin.y + self.cropFrame!.size.height {
//      newFrame.origin.y = self.cropFrame!.origin.y + self.cropFrame!.size.height - newFrame.size.height
//    }
//    
//    if self.showImgView!.frame.size.width > self.showImgView!.frame.size.height && newFrame.size.height <= self.cropFrame!.size.height {
//      newFrame.origin.y = self.cropFrame!.origin.y + (self.cropFrame!.size.height - newFrame.size.height) / 2
//    }
//    return newFrame
//  }
//  
//    func getSubImage(cropFrame:UIImage) -> UIImage {
//    let squareFrame = self.cropFrame!
//    let scaleRatio = self.latestFrame!.size.width / self.originalImage!.size.width
//    var x = (squareFrame.origin.x - self.latestFrame!.origin.x) / scaleRatio
//    var y = (squareFrame.origin.y - self.latestFrame!.origin.y) / scaleRatio
//    var w = squareFrame.size.width / scaleRatio
//    var h = squareFrame.size.height / scaleRatio
//    if self.latestFrame!.size.width < self.cropFrame!.size.width {
//      let newW = self.originalImage!.size.width
//      let newH = newW * (self.cropFrame!.size.height / self.cropFrame!.size.width)
//      x = 0;
//      y = y + (h - newH) / 2
//      w = newH
//      h = newH
//    }
//    if self.latestFrame!.size.height < self.cropFrame!.size.height {
//      let newH = self.originalImage!.size.height
//      let newW = newH * (self.cropFrame!.size.width / self.cropFrame!.size.height)
//      x = x + (w - newW) / 2
//      y = 0
//      w = newH
//      h = newH
//    }
//    
//    let myImageRect = CGRectMake(x, y, w, h)
//    let imageRef = self.originalImage!.CGImage
//    let subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect)
//    let size:CGSize = CGSizeMake(myImageRect.size.width, myImageRect.size.height)
//    UIGraphicsBeginImageContext(size)
//    let context:CGContextRef = UIGraphicsGetCurrentContext()!
//    CGContextDrawImage(context, myImageRect, subImageRef)
//    let smallImage = UIImage(CGImage: subImageRef!)
//    UIGraphicsEndImageContext()
//    return smallImage
//  }
//  
//  // orientation
//  func fixOrientation(srcImg:UIImage) -> UIImage {
//    if srcImg.imageOrientation == UIImageOrientation.Up {
//      return srcImg
//    }
//    var transform = CGAffineTransformIdentity
//    switch srcImg.imageOrientation {
//    case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
//      transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height)
//      transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
//    case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
//      transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0)
//      transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
//    case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
//      transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height)
//      transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
//    case UIImageOrientation.Up, UIImageOrientation.UpMirrored: break
//    }
//    switch srcImg.imageOrientation {
//    case UIImageOrientation.UpMirrored, UIImageOrientation.DownMirrored:
//      transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0)
//      transform = CGAffineTransformScale(transform, -1, 1)
//    case UIImageOrientation.LeftMirrored, UIImageOrientation.RightMirrored:
//      transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0)
//      transform = CGAffineTransformScale(transform, -1, 1)
//    case UIImageOrientation.Up, UIImageOrientation.Down, UIImageOrientation.Left, UIImageOrientation.Right:break
//    }
//    
//    // 上下文
//    let ctx:CGContextRef = CGBitmapContextCreate(nil, Int(srcImg.size.width), Int(srcImg.size.height), CGImageGetBitsPerComponent(srcImg.CGImage), 0, CGImageGetColorSpace(srcImg.CGImage), CGImageGetBitmapInfo(srcImg.CGImage).rawValue)!
//    
//    CGContextConcatCTM(ctx, transform)
//    switch srcImg.imageOrientation {
//    case UIImageOrientation.Left, UIImageOrientation.LeftMirrored, UIImageOrientation.Right, UIImageOrientation.RightMirrored:
//      CGContextDrawImage(ctx, CGRectMake(0, 0, srcImg.size.height, srcImg.size.width), srcImg.CGImage)
//    default:
//      CGContextDrawImage(ctx, CGRectMake(0, 0, srcImg.size.width, srcImg.size.height), srcImg.CGImage)
//    }
//    
//    let cgImg:CGImageRef = CGBitmapContextCreateImage(ctx)!
//    let img:UIImage = UIImage(CGImage: cgImg)
//    
//    CGContextClosePath(ctx)
//    return img
//  }
  
}
