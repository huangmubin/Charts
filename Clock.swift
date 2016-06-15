//
//  Clock.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class Clock: UIView {

    // MARK: - Global
    
    ///
    var radius: (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0, 0, 0)
    private var height = true
    private var centre = CGPointZero
    private var layerFrame = CGRectZero
    private var layerCentre = CGPointZero
    
    func autoSize() {
        centre = CGPoint(x: frame.width/2, y: frame.height/2)
        height = frame.width >= frame.height
        let out = (height ? frame.height : frame.width) * 0.5 - 20
        radius = (out, out - 5, out - 25, out - 30, out - 35, out - 40)
        layerFrame = CGRect(x: height ? (frame.width - frame.height) / 2 : 0 , y: height ? 0 : (frame.height - frame.width) / 2, width: height ? frame.height : frame.width, height: height ? frame.height : frame.width)
        layerCentre = CGPoint(x: layerFrame.width/2, y: layerFrame.height/2)
    }
    
    
    // MARK: - Background
    private func drawBackground() {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.whiteColor().CGColor
        shape.strokeColor = UIColor.blackColor().CGColor
        shape.lineWidth = 2
        shape.path = UIBezierPath(arcCenter: centre, radius: radius.0, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true).CGPath
        layer.addSublayer(shape)
    }
    
    // MARK: - Lines layer
    
    private let linesLayer = CALayer()
    private func drawLinesLayer() {
        linesLayer.frame = layerFrame
        
        // MARK: Color
        let size   = linesLayer.frame.width / 2
        let colors = (
            UIColor.blackColor().CGColor,
            UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor,
            UIColor.clearColor().CGColor
        )
        
        let _ = {
            let gradient        = CAGradientLayer()
            gradient.frame      = CGRect(x: 0, y: 0, width: size + 4, height: size)
            gradient.startPoint = CGPoint(x: 0.2, y: 0.2)
            gradient.endPoint   = CGPoint(x: 0.8, y: 0.8)
            gradient.colors     = [colors.1, colors.0]
            linesLayer.addSublayer(gradient)
        }()
        let _ = {
            let gradient        = CAGradientLayer()
            gradient.frame      = CGRect(x: 0, y: size, width: size, height: size)
            gradient.startPoint = CGPoint(x: 0.2, y: 0.8)
            gradient.endPoint   = CGPoint(x: 0.8, y: 0.2)
            gradient.colors     = [colors.1, colors.2]
            linesLayer.addSublayer(gradient)
        }()
        
        // MARK: Path
        let _ = {
            let mask = CAShapeLayer()
            mask.fillColor = UIColor.clearColor().CGColor
            mask.strokeColor = UIColor.blackColor().CGColor
            mask.lineWidth = 2
            mask.lineCap = kCALineCapRound
            
            let path = UIBezierPath()
            //let center = CGPoint(x: linesLayer.frame.width/2, y: linesLayer.frame.height/2)
            for i in 0 ..< 36 {
                path.moveToPoint(Tools.circle(layerCentre, radius: radius.1, angle: CGFloat(i) * 10))
                path.addLineToPoint(Tools.circle(layerCentre, radius: radius.2, angle: CGFloat(i) * 10))
            }
            
            mask.path = path.CGPath
            linesLayer.mask = mask
        }()
        
        layer.addSublayer(linesLayer)
    }
    
    // MARK: - Second Layer
    private let secondLayer = CAShapeLayer()
    private func drawSecondLayer() {
        secondLayer.frame = layerFrame
        secondLayer.fillColor = UIColor.whiteColor().CGColor
        secondLayer.strokeColor = UIColor.blackColor().CGColor
        secondLayer.lineWidth = 2
        secondLayer.path = UIBezierPath(arcCenter: layerCentre, radius: radius.3, startAngle: -CGFloat(M_PI_2) * 1.5, endAngle: -CGFloat(M_PI_2) * 0.5, clockwise: true).CGPath
        layer.addSublayer(secondLayer)
    }
    
    // MARK: - Second Layer
    private let minuteLayer = CAShapeLayer()
    private func drawMinuteLayer() {
        minuteLayer.frame = layerFrame
        minuteLayer.fillColor = UIColor.whiteColor().CGColor
        minuteLayer.strokeColor = UIColor.blackColor().CGColor
        minuteLayer.lineWidth = 2
        minuteLayer.path = UIBezierPath(arcCenter: layerCentre, radius: radius.4, startAngle: -CGFloat(M_PI_2) * 1.1, endAngle: -CGFloat(M_PI_2) * 0.9, clockwise: true).CGPath
        layer.addSublayer(minuteLayer)
    }
    
    // MARK: - Draw
    
    func draw() {
        autoSize()
        
        drawBackground()
        drawLinesLayer()
        drawSecondLayer()
        drawMinuteLayer()
//        drawColorsLayer()
//        drawLines()
    }

    
    // MARK: - Control
    
    private var animating: Animation?
    private var minute = Double(0)
    func animate() {
        if animating == nil {
            animating = Animation.repeart(1, functionType: Animation.AnimationType.Liner, update: { [weak self] (schedule) -> Bool in
                self?.linesLayer.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(schedule * M_PI * 2)))
                self?.secondLayer.setAffineTransform(CGAffineTransformMakeRotation(-CGFloat(schedule * M_PI * 2)))
                self?.minute += schedule
                self?.minute %= 2
                print("\(schedule): \(self?.minute) - \(self?.minute ?? 2 / 2)")
//                if let minute = self?.minute {
//                    self?.minuteLayer.setAffineTransform(CGAffineTransformMakeRotation(0))
//                }
                return self != nil
            })
        }
    }
}
