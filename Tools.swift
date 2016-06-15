//
//  Tools.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/14.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class Tools: NSObject {
    
    // MARK: - Frame
    
    /**
     Frame 转化函数。
     - parameter rect: 原始 Frame
     - parameter x: 新的 x 坐标，nil 则保持原数据不变。
     - parameter y: 新的 y 坐标，nil 则保持原数据不变。
     - parameter w: 新的 width 长度，nil 则保持原数据不变。
     - parameter h: 新的 height 长度，nil 则保持原数据不变。
     - returns: 转化后的 Frame 坐标。
     */
    class func frameChange(rect: CGRect, x: CGFloat?, y: CGFloat?, w: CGFloat?, h: CGFloat?) -> CGRect {
        return CGRect(x: x ?? rect.minX, y: y ?? rect.minY, width: w ?? rect.width, height: h ?? rect.height)
    }
    
    /**
     Frame 按比例缩放函数，中心点不变。如0.1则变成原来的0.1长。
     - parameter rect: 原始 Frame
     - parameter scale: 缩放比例
     - returns: 转化后的 Frame 坐标。
     */
    class func frameChange(rect: CGRect, scale: CGFloat) -> CGRect {
        let w = rect.width * scale
        let h = rect.height * scale
        let x = (rect.width - w) / 2 + rect.minX
        let y = (rect.height - h) / 2 + rect.minY
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    /**
     Frame 按长度缩放函数，中心点不变。如10则四边都扩展10.
     - parameter rect: 原始 Frame
     - parameter extend: 扩展比例
     - returns: 转化后的 Frame 坐标。
     */
    class func frameChange(rect: CGRect, extend: CGFloat) -> CGRect {
        let x = rect.minX + extend
        let y = rect.minY + extend
        let w = rect.width + extend * 2
        let h = rect.height + extend * 2
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    // MARK: - 圆形
    
    /**
     计算圆周上某一点的位置，(1,0) 位置为0度位置。
     - parameter center: 圆心位置。
     - parameter redius: 半径长度。
     - parameter angle: 角度。
     - returns: 转化后的 Frame 坐标。
     */
    class func circle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let radian = Double(angle) * M_PI / 180.0
        let x = radius * CGFloat(cos(radian)) + center.x
        let y = radius * CGFloat(sin(radian)) + center.y
        return CGPoint(x: rounding(x), y: rounding(y))
    }
    
    class func circlePi(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = radius * CGFloat(cos(angle)) + center.x
        let y = radius * CGFloat(sin(angle)) + center.y
        return CGPoint(x: rounding(x), y: rounding(y))
    }
    
    
    // MARK: - 三角形
    
    /**
     求直角三角形的第三边长。
     - parameter a: a
     - parameter b: b
     - returns: c。
     */
    class func triangle(a: CGFloat, b: CGFloat) -> CGFloat {
        return sqrt((a * a) + (b * b))
    }
    
    // MARK: - 点
    
    /**
     求两点之间的距离。
     - parameter a: a
     - parameter b: b
     - returns: 距离。
     */
    class func pointer(a: CGPoint, b: CGPoint) -> CGFloat {
        return triangle(a.x - b.x, b: a.y - b.y)
    }
    
    // MARK: - 数字
    
    /**
     根据位数对数字进行四舍五入。
     - parameter x: 数字
     - parameter p: 四舍五入位置，百位则是100，小数点后1位则是0.1
     - returns: 截取后数字。
     */
    class func rounding(x: CGFloat, _ p: CGFloat) -> CGFloat {
        return CGFloat(round(Double(x / p))) * p
    }
    
    /**
     对数字进行只保留小数点后5位的四舍五入。
     - parameter x: 数字
     - returns: 四舍五入后数字。
     */
    class func rounding(x: CGFloat) -> CGFloat {
        return CGFloat(round(Double(x / 0.00001))) * 0.00001
    }

}
