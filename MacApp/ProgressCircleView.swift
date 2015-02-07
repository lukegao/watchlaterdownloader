//
//  ProgressCircleView.swift
//  MacApp
//
//  Created by Luke Gao on 1/22/15.
//  Copyright (c) 2015 Luke Gao. All rights reserved.
//

import Cocoa
import QuartzCore

@IBDesignable
class ProgressCircleView: NSView {
    var bgLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var textLayer: CATextLayer!
    
    var lineWidth: CGFloat = 10.0
    var totalLength: Int64 = 100
    
    var currentLength: Int64 = 10 {
        didSet {
            if currentLength > 100 {
                currentLength = currentLength - totalLength
            }
            updateProgress()
        }
    }
    
    private func updateProgress() {
        if progressLayer != nil {
            progressLayer.strokeEnd = CGFloat(currentLength) / CGFloat(totalLength)
        }
        
        if textLayer != nil {
            textLayer.string = "\(progressLayer.strokeEnd * 100)%"
        }
    }
    
    override var wantsUpdateLayer: Bool {
        get {
            return true
        }
    }
    
    override func updateLayer() {
        if bgLayer == nil {
            bgLayer = CAShapeLayer()
            layer?.addSublayer(bgLayer)
            let rect = CGRectInset(bounds, lineWidth/2.0, lineWidth/2.0)
            bgLayer.path = CGPathCreateWithEllipseInRect(rect, nil)
            bgLayer.fillColor = nil
            bgLayer.lineWidth = 5
            bgLayer.strokeColor = NSColor(white: 0.5, alpha: 0.3).CGColor
        }
        bgLayer.frame = bounds
        
        if progressLayer == nil {
            progressLayer = CAShapeLayer()
            layer?.addSublayer(progressLayer)
            let rect = CGRectInset(bounds, lineWidth/2.0, lineWidth/2.0)
            var path = CGPathCreateMutable()
            CGPathAddArc(path, nil, rect.midX, rect.midY, rect.width/2, 0, CGFloat(M_PI*2), true)
            progressLayer.path = path
            progressLayer.fillColor = nil
            progressLayer.lineWidth = 5
            progressLayer.strokeColor = CGColorCreateGenericRGB(0.0, 0.8, 0.0, 0.8)
            progressLayer.anchorPoint = CGPointMake(0.5, 0.5)
            progressLayer.transform = CATransform3DRotate(progressLayer.transform, CGFloat(M_PI/2), 0, 0, 1)

        }
        progressLayer.frame = bounds
        
        if textLayer == nil {
            textLayer = CATextLayer()
            layer?.addSublayer(textLayer)
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.foregroundColor = NSColor.blackColor().CGColor
        }
        textLayer.frame = CGRectInset(bounds, lineWidth, bounds.height/3)
        updateProgress()
    }
}
