//
//  ProgressBarViewController.swift
//  Charts
//
//  Created by 黄穆斌 on 16/6/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class ProgressBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        progressBar.angles = (-CGFloat(M_PI) * 0.5, CGFloat(M_PI) * 1.5)
        progressBar.draw()
    }
    @IBOutlet weak var progressBar: ProgressBar!

    @IBAction func sliderAction(sender: UISlider) {
        progressBar.progress(CGFloat(sender.value / 100))
    }
    @IBAction func startAction(sender: AnyObject) {
        progressBar.animate()
    }
    @IBAction func endAction(sender: UIButton) {
    }
    

}
