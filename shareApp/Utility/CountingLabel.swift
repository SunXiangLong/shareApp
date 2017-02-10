//
//  CountingLabel.swift
//  CuntingLabel
//
//  Created by Bing on 7/9/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

@IBDesignable class CountingLabel: UILabel
{
    // 开始的数字
    var fromNum = NSNumber(value: 0 as Int)
    
    // 结束的数字
    var toNum = NSNumber(value: 100 as Int)
    
    // 动画的持续时间
    fileprivate var duration: TimeInterval = 1.0
    
    // 动画开始时刻的时间
    fileprivate var startTime: CFTimeInterval = 0
    
    // 字符串格式化
    var format: NSString = "%d"
    
    // 格式化字符串闭包
    var formatBlock: ((_ value: Double) -> NSString)?

    // 定时器
    fileprivate var displayLink: CADisplayLink!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // 从数字fromNum经过duration长的时间变化到数字toNum
    func countFrom(fromNum: NSNumber, toNum: NSNumber, duration: Double)
    {
        self.text = fromNum.stringValue
        self.fromNum = fromNum
        self.toNum = toNum
        self.duration = duration
        
        startDisplayLink()
    }
    
    // 开始定时器
    fileprivate func startDisplayLink()
    {
        if displayLink != nil
        {
            displayLink.invalidate()
        }
        displayLink = CADisplayLink(target: self, selector: .handleDisplayLink)
        // 记录动画开始时刻的时间
        startTime = CACurrentMediaTime()
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    // 定时器的回调
    @objc fileprivate func handleDisplayLink(_ displayLink: CADisplayLink)
    {
        if displayLink.timestamp - startTime >= duration
        {
            if formatBlock != nil
            {
                self.text = self.formatBlock!(toNum.doubleValue) as String
            }
            else
            {
                self.text = NSString(format: self.format, toNum.doubleValue) as String
            }
            // 结束定时器
            stopCounting()
        }
        else
        {
            // 计算现在时刻的数字
            let current = (toNum.doubleValue - fromNum.doubleValue) * (displayLink.timestamp - startTime) / duration + fromNum.doubleValue
            if formatBlock != nil
            {
                self.text = self.formatBlock!(current) as String
            }
            else
            {
                self.text = NSString(format: self.format, current) as String
            }
        }
    }
    
    // 结束定时器
    func stopCounting()
    {
        displayLink.invalidate()
    }
}

private extension Selector
{
    static let handleDisplayLink = #selector(CountingLabel.handleDisplayLink)
}
