//
//  PieChartViewController.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/14.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class PieChartViewController: UIViewController {

    var datas = PicChartModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.calculateValue()
        pieChart.setNeedsDisplay()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBOutlet weak var pieChart: PieChart!
    
    @IBAction func action(sender: UIButton) {
        pieChart.animation()
    }
}
