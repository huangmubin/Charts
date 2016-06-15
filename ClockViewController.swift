//
//  ClockViewController.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        clock.draw()
    }
    
    @IBOutlet weak var clock: Clock!
    
    
    @IBAction func sliderAction(sender: UISlider) {
    }
    @IBAction func startAction(sender: UIButton) {
        clock.animate()
    }

    @IBAction func endAction(sender: AnyObject) {
    }
}
