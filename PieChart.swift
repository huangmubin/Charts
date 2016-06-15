//
//  PieChart.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/14.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: - Pic Chart Model
class PicChartModel: ChartModel {
    
    // MARK: 数据
    var datas: [CGFloat]  = [0.3, 0.2, 0.4, 0.1]
    var tags: [String?]   = ["1", "2", "3", "4"]
    var colors: [UIColor] = [UIColor.blueColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.redColor()]
    
    var angles: [(start: CGFloat, end: CGFloat)] = []
    var animation: [(start: CGFloat, end: CGFloat)] = []
    var select: Int? = nil
    
    /// 圆周周长
    let pi = CGFloat(M_PI) * 2
    func calculateAngles() {
        let totail = datas.reduce(0, combine: +)
        var startValue: CGFloat = 0
        var startAngle: CGFloat = 0
        for data in datas {
            startValue += data
            let end = startValue / totail
            angles.append((start: startAngle * pi, end: end * pi))
            animation.append((start: startAngle * pi, end: end * pi))
            startAngle = end
        }
    }
    
}

// MARK: Pie Chart View
class PieChart: UIView {

    /// 图表数据
    var model = PicChartModel()
    /// 中心点
    var centre = CGPointZero
    /// 半径
    var radius:(CGFloat, CGFloat, CGFloat, CGFloat) = (0.1,0.15,0.6,0.9)
    /// 分割颜色
    var lineColor = UIColor.whiteColor().CGColor
    
    // MARK: Data
    
    func calculateValue() {
        model.calculateAngles()
        centre = CGPoint(x: frame.width / 2, y: frame.height / 2)
        radius = (
            frame.height * 0.05,
            frame.height * 0.075,
            frame.height * 0.3,
            frame.height * 0.45
        )
    }
    
    // MARK: Draw
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        CGContextSetAllowsAntialiasing(ctx, true)
        
        for (index, data) in model.animation.enumerate() {
            let oRadius = model.select == index ? radius.3 : radius.2
            let i = Tools.circlePi(centre, radius: radius.0, angle: data.start)
            let c = Tools.circlePi(centre, radius: radius.1, angle: data.start)
            let o = Tools.circlePi(centre, radius: oRadius, angle: data.end)
            
            // 绘制阴影
            CGContextMoveToPoint(ctx, i.x, i.y)
            CGContextAddArc(ctx, centre.x, centre.y, radius.0, data.start, data.end, 0)
            CGContextAddLineToPoint(ctx, o.x, o.y)
            CGContextAddArc(ctx, centre.x, centre.y, oRadius, data.end, data.start, 1)

            CGContextClosePath(ctx)
            CGContextSetFillColorWithColor(ctx, model.colors[index].colorWithAlphaComponent(0.5).CGColor)
            CGContextFillPath(ctx)
            
            // 绘制主体
            CGContextMoveToPoint(ctx, c.x, c.y)
            CGContextAddArc(ctx, centre.x, centre.y, radius.1, data.start, data.end, 0)
            CGContextAddLineToPoint(ctx, o.x, o.y)
            CGContextAddArc(ctx, centre.x, centre.y, oRadius, data.end, data.start, 1)
            
            CGContextClosePath(ctx)
            CGContextSetFillColorWithColor(ctx, model.colors[index].CGColor)
            CGContextFillPath(ctx)
        }
        
        for data in model.animation {
            let o = Tools.circlePi(centre, radius: radius.3, angle: data.end)
            CGContextMoveToPoint(ctx, centre.x, centre.y)
            CGContextAddLineToPoint(ctx, o.x, o.y)
            CGContextSetStrokeColorWithColor(ctx, lineColor)
            CGContextStrokePath(ctx)
        }
        
        CGContextRestoreGState(ctx)
    }

    // MARK: Animation
    
    /// 动画
    private var animating: Animation?
    
    func animation() {
        animating = Animation.run(10, functionType: Animation.AnimationType.SpringDefault, update: { (schedule) in
            for i in 0 ..< self.model.angles.count {
                self.model.animation[i] = (self.model.angles[i].start * CGFloat(schedule), self.model.angles[i].end * CGFloat(schedule))
                self.setNeedsDisplay()
            }
            return true
        }) {
            self.animating = nil
        }
    }
}

extension PieChart {
    
}
