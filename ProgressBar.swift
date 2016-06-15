//
//  ProgressBar.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

final class ProgressBar: UIView {
    
    // MARK: - Global
    var radius: CGFloat = 50
    var angles: (start: CGFloat, end: CGFloat) = (0, CGFloat(M_PI) * 2)
    
    private var height = true
    func autoSize() {
        height = frame.width >= frame.height
        radius = (height ? frame.height : frame.width) * 0.5 - 20
    }
    
    
    deinit {
        print("Progress Deinit")
    }
    
    // MARK: - Background Layer
    
    var backgroundBarColor: CGColor = UIColor.blackColor().CGColor
    var backgroundLineWidth: CGFloat = 4
    
    private func drawBackground() {
        let shape = CAShapeLayer()
        shape.fillColor     = UIColor.clearColor().CGColor
        shape.strokeColor   = backgroundBarColor
        shape.lineCap       = kCALineCapRound
        shape.lineWidth     = backgroundLineWidth
        shape.path          = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: radius - colorWidth / 2, startAngle: angles.start, endAngle: angles.end, clockwise: true).CGPath
        
        layer.addSublayer(shape)
    }
    
    // MARK: - Color Layer
    var color: UIColor = UIColor.blueColor()
    var colorWidth: CGFloat = 20
    private let colorLayer: CALayer = CALayer()
    
    private func drawColorLayer() {
        colorLayer.frame = CGRect(x: height ? (frame.width - frame.height) / 2 : 0 , y: height ? 0 : (frame.height - frame.width) / 2, width: height ? frame.height : frame.width, height: height ? frame.height : frame.width)
        
        let size   = colorLayer.frame.width / 2
        let colors = (
            color.CGColor,
            color.colorWithAlphaComponent(0.5).CGColor,
            UIColor.clearColor().CGColor
        )
        
        let _ = {
            let gradient        = CAGradientLayer()
            gradient.frame      = CGRect(x: 0, y: 0, width: size, height: size)
            gradient.startPoint = CGPoint(x: 0.2, y: 0.8)
            gradient.endPoint   = CGPoint(x: 0.8, y: 0.2)
            gradient.colors     = [colors.0, colors.1]
            colorLayer.addSublayer(gradient)
        }()
        let _ = {
            let gradient        = CAGradientLayer()
            gradient.frame      = CGRect(x: size, y: 0, width: size, height: size)
            gradient.startPoint = CGPoint(x: 0.2, y: 0.2)
            gradient.endPoint   = CGPoint(x: 0.8, y: 0.8)
            gradient.colors     = [colors.1, colors.2]
            colorLayer.addSublayer(gradient)
        }()
        let _ = {
            let gradient        = CAGradientLayer()
            gradient.frame      = CGRect(x: size, y: size, width: size, height: size)
            gradient.startPoint = CGPoint(x: 0.8, y: 0.2)
            gradient.endPoint   = CGPoint(x: 0.2, y: 0.8)
            gradient.colors     = [colors.2, colors.1]
            colorLayer.addSublayer(gradient)
        }()
        let _ = {
            let gradient        = CAGradientLayer()
            gradient.frame      = CGRect(x: 0, y: size, width: size, height: size)
            gradient.startPoint = CGPoint(x: 0.8, y: 0.8)
            gradient.endPoint   = CGPoint(x: 0.2, y: 0.2)
            gradient.colors     = [colors.1, colors.0]
            colorLayer.addSublayer(gradient)
        }()
        
        colorLayer.backgroundColor = UIColor.whiteColor().CGColor
        containerLayer.addSublayer(colorLayer)
    }
    
    // MARK: - Progress Layer
    private let progressLayer: CAShapeLayer = CAShapeLayer()
    private let containerLayer: CALayer = CALayer()
    
    private func drawProgress() {
        containerLayer.frame = layer.bounds
        
        let _ = {
            progressLayer.fillColor   = UIColor.clearColor().CGColor
            progressLayer.strokeColor = UIColor.whiteColor().CGColor
            progressLayer.lineCap     = kCALineCapRound
            progressLayer.lineWidth   = colorWidth
            progressLayer.path        = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: radius - colorWidth / 2, startAngle: angles.start, endAngle: angles.end, clockwise: true).CGPath
            progressLayer.strokeEnd = 0.5
            
            progressLayer.shadowOpacity = 1
            progressLayer.shadowRadius = 4
            progressLayer.shadowOffset = CGSize(width: 0, height: 0)
            containerLayer.mask = progressLayer
        }()
        
        layer.addSublayer(containerLayer)
    }
    
    
    // MARK: - Draw
    func draw() {
        autoSize()
        
        drawBackground()
        drawColorLayer()
        drawProgress()
    }
    
    // MARK: - Control
    func progress(value: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationDuration(0.5)
        progressLayer.strokeEnd = value
        CATransaction.commit()
    }
    
    private var animating: Animation?
    func animate() {
        if animating == nil {
            animating = Animation.repeart(1, functionType: Animation.AnimationType.Liner, update: { [weak self] (schedule) -> Bool in
                self?.colorLayer.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(schedule * M_PI * 2)))
                return self != nil
            })
        }
    }
    
}