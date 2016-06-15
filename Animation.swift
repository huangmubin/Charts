import UIKit



// MARK: - Animation 动画类 : 接口
extension Animation {
    
    // MARK: 类接口
    
    /**
     重复动画
     */
    class func repeart(duration: NSTimeInterval, functionType: Animation.AnimationType, update: ((schedule: Double) -> Bool)?) -> Animation {
        let animation = Animation()
        animation.setTimeAndValue(43200, function: typeFunction(functionType))
        animation.setBlock({ (schedule) in
            return update?(schedule: schedule * (43200.0 / duration) % 1) ?? true
        }, completed: nil)
        animation.start()
        return animation
    }
    
    
    /**
     重复动画
     */
    class func repeart(duration: NSTimeInterval, functionType: Animation.AnimationType, update: ((schedule: Double) -> Bool)?, completed: (() -> Void)?) -> Animation {
        let animation = Animation()
        animation.setTimeAndValue(43200, function: typeFunction(functionType))
        animation.setBlock({ (schedule) in
            return update?(schedule: schedule * (43200.0 / duration) % 1) ?? true
            }, completed: completed)
        animation.start()
        return animation
    }
    
    /**
     运行动画。
     - parameter duration: 持续时间
     - parameter function: 时间函数
     - parameter update: 更新回调
     - parameter completed: 完成回调
     - returns: 动画实例
     */
    class func run(duration: NSTimeInterval, function: (NSTimeInterval) -> NSTimeInterval, update: ((schedule: Double) -> Bool)?, completed: (() -> Void)?) -> Animation {
        let animation = Animation()
        animation.setTimeAndValue(duration, function: function)
        animation.setBlock(update, completed: completed)
        animation.start()
        return animation
    }
    
    /**
     运行动画。
     - parameter duration: 持续时间
     - parameter functionType: 时间函数类型
     - parameter update: 更新回调
     - parameter completed: 完成回调
     - returns: 动画实例
     */
    class func run(duration: NSTimeInterval, functionType: Animation.AnimationType, update: ((schedule: Double) -> Bool)?, completed: (() -> Void)?) -> Animation {
        return run(duration, function: typeFunction(functionType), update: update, completed: completed)
    }
    
    /**
     运行动画。
     - parameter duration: 持续时间
     - parameter functionType: 时间函数类型
     - parameter update: 更新回调
     - returns: 动画实例
     */
    class func run(duration: NSTimeInterval, functionType: Animation.AnimationType, update: ((schedule: Double) -> Bool)?) -> Animation {
        return run(duration, function: typeFunction(functionType), update: update, completed: nil)
    }
    
    /**
     运行动画。
     - parameter duration: 持续时间
     - parameter update: 更新回调
     - returns: 动画实例
     */
    class func run(duration: NSTimeInterval, update: ((schedule: Double) -> Bool)?) -> Animation {
        return run(duration, function: Animation.linear, update: update, completed: nil)
    }
    
    
    // MARK: 实例接口
    /**
     设置回调
     - parameter update: 更新回调
     - parameter completed: 完成回调
     */
    func setBlock(update: ((schedule: Double) -> Bool)?, completed: (() -> Void)?) {
        self.update = update
        self.completed = completed
    }
    
    /**
     设置时间和更新值
     - parameter duration: 持续时间
     - parameter function: 时间函数
     */
    func setTimeAndValue(duration: NSTimeInterval, function: (NSTimeInterval) -> NSTimeInterval) {
        durationTime = duration
        let times = Int(duration * 60)
        values = Array(count: times, repeatedValue: 0)
        for i in 0 ..< times {
            values[i] = function(Double(i) / Double(times))
        }
    }
}

// MARK: - Animation 动画类
/// 动画类
final class Animation: NSObject {
    
    // MARK: 初始化
    override init() {
        super.init()
        print("\(self) is init.")
    }
    
    deinit {
        print("\(self) is deinit.")
    }
    
    // MARK: 属性
    
    /// RunLoop 每秒在主线程中调用 loop 60 次
    private var displayLink: CADisplayLink?
    
    /// 开始时间
    private var startTime     : NSTimeInterval = 0
    /// 结束时间
    private var endTime       : NSTimeInterval = 0
    /// 持续时间
    private var durationTime  : NSTimeInterval = 0
    
    /// 更新调用的 Block
    private var update: ((schedule: Double) -> Bool)?
    //private var update: ((schedule: Double) -> Void)?
    /// 动画完成时调用的 Block
    private var completed: (() -> Void)?
    
    /// 动画进度数组
    private var values = [Double]()
    
    // MARK: 方法
    /**
     启动引擎。检查持续时间，更新开始结束时间。检查数据值是否正确。
     - parameter duration: 持续时间
     */
    private func start() {
        // 时间
        guard durationTime > 0 else { return }
        startTime       = CACurrentMediaTime()
        endTime         = startTime + durationTime
        
        // 数据值
        guard values.count == Int(durationTime * 60) else { return }
        
        // 开始循环
        displayLink = CADisplayLink(target: self, selector: #selector(loop))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    /**
     引擎运转。
     */
    @objc private func loop() {
        // 获取当前时间
        let currentTime = CACurrentMediaTime()
        
        // 运行结束
        if currentTime >= endTime {
            update?(schedule: 1)
            stop()
            return
        }
        
        // 调用更新
        if update?(schedule: values[Int((currentTime - startTime) * 60)]) == false {
            stop()
        }
        //update?(schedule: values[Int((currentTime - startTime) * 60)])
    }
    
    /**
     关闭引擎。
     */
    private func stop() {
        completed?()
        displayLink?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink = nil
    }
    
}

// MARK: - Animation 动画类 : 时间函数枚举接口
extension Animation {
    
    /// 时间函数的类型
    enum AnimationType {
        case Liner
        case InQuadratic, InCubic, InSin
        case OutQuadratic, OutCubic, OutSin
        case InOutQuadratic, InOutCubic
        case BackIn, BackOut
        case SpringDefault, SpringIn, SpringOut
    }
    
    class func typeFunction(type: AnimationType) -> (NSTimeInterval) -> (NSTimeInterval) {
        switch type {
        case .Liner:
            return Animation.linear
        case .InQuadratic:
            return Animation.easeInQuadratic
        case .InCubic:
            return Animation.easeInCubic
        case .InSin:
            return Animation.easeInSin
        case .OutQuadratic:
            return Animation.easeOutQuadratic
        case .OutCubic:
            return Animation.easeOutCubic
        case .OutSin:
            return Animation.easeOutSin
        case .InOutQuadratic:
            return Animation.easeInOutQuadratic
        case .InOutCubic:
            return Animation.easeInOutCubic
        case .BackIn:
            return Animation.easeInBack
        case .BackOut:
            return Animation.easeOutBack
        case .SpringIn:
            return Animation.easeInBounce
        case .SpringOut:
            return Animation.easeOutBounce
        case .SpringDefault:
            return Animation.spring(10, velocity: 20)
        }
    }
}

// MARK: - Animation 动画类 : 变速控制
/// 动画变速运算方式
extension Animation {
    
    // MARK: 线性
    /**
     线性
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func linear(s: NSTimeInterval) -> NSTimeInterval {
        return s
    }
    
    // MARK: 加速
    /**
     加速 (平方)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInQuadratic(s: NSTimeInterval) -> NSTimeInterval {
        return s * s
    }
    
    /**
     加速 (立方)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInCubic(s: NSTimeInterval) -> NSTimeInterval {
        return s * s * s
    }
    
    /**
     加速 (Sin)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInSin(s: NSTimeInterval) -> NSTimeInterval {
        return -cos(s * M_PI_2) + 1
    }
    
    // MARK: 减速
    /**
     减速 (平方)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeOutQuadratic(s: NSTimeInterval) -> NSTimeInterval {
        return s * (2 - s)
    }
    
    /**
     减速 (立方)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeOutCubic(s: NSTimeInterval) -> NSTimeInterval {
        return s * s * s - 3 * s * s + 3 * s
    }
    
    /**
     减速 (Sin)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeOutSin(s: NSTimeInterval) -> NSTimeInterval {
        return sin(s * M_PI_2)
    }
    
    // MARK: 先加速后减速
    /**
     加速 - 减速 (平方)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInOutQuadratic(s: NSTimeInterval) -> NSTimeInterval {
        if s <= 0.5 {
            return s * s * 2
        } else {
            return s * 4 - 2 * s * s - 1
        }
    }
    
    /**
     加速 - 减速 (立方)
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInOutCubic(s: NSTimeInterval) -> NSTimeInterval {
        if s <= 0.5 {
            return s * s * s * 4
        } else {
            return 4 * s * s * s - 12 * s * s + 12 * s - 3
        }
    }
    
    // MARK: 返回
    
    /**
     先返回一段距离然后弹出
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInBack(s: NSTimeInterval) -> NSTimeInterval {
        // 2 是控制回去的时间占据总时间的比例，2 刚好是在0.5的位置从后退变前进， 减少则往前，增加则往后
        // 1 是必须 2 - 1 的值
        // 参考值 1.70158
        return s * s * (2 * s - 1)
    }
    
    /**
     超出一定距离后返回
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeOutBack(s: NSTimeInterval) -> NSTimeInterval {
        // easeOutCubic(s) * (2 - s) 减速函数 * 大小回归变化
        return 6 * s - 9 * s * s + 5 * s * s * s - s * s * s * s
    }
    
    // MARK: 弹跳
    
    /**
     弹簧效果
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeInBounce(s: NSTimeInterval) -> NSTimeInterval {
        return 1 - easeOutBounce(1 - s)
    }
    
    /**
     到达后弹簧效果
     - parameter schedule: 进度 0 ~ 1
     - returns: 变化后的进度
     */
    class func easeOutBounce(s: NSTimeInterval) -> NSTimeInterval {
        if s < 0.3636363636363636 {
            return 7.5625 * s * s
        } else if s < 0.7272727272727273 {
            return 7.5625 * s * s - 8.25 * s + 3
        } else if s < 0.9090909090909091 {
            return 7.5625 * s * s - 12.375 * s + 6
        } else {
            return 7.5625 * s * s - 14.4375 * s + 7.875
        }
    }
    
    /**
     计算弹簧效果值的函数，根据：y = 1-e^{-5x} * cos(30x)
     - parameter s: 当前时间百分比
     - parameter damping: 默认 5, 范围 0 ... 10~， 数值越大则后期弹性效果越不明显。
     - parameter velocity: 默认 30，范围 0 ... 60~，数值越大波动次数越多
     - returns: 百分比
     */
    class func spring(s: Double, damping: Double, velocity: Double) -> Double {
        return 1 - pow(M_E, -damping * s) * cos(velocity * s)
    }
    
    /**
     计算弹簧效果值的函数，根据：y = 1-e^{-5x} * cos(30x)
     - parameter damping: 默认 5, 范围 0 ... 10~， 数值越大则后期弹性效果越不明显。
     - parameter velocity: 默认 30，范围 0 ... 60~，数值越大波动次数越多
     - returns: 接收单个参数的 spring 函数
     */
    class func spring(damping: Double, velocity: Double) -> (NSTimeInterval) -> NSTimeInterval {
        return { self.spring($0, damping: damping, velocity: velocity) }
    }
}

