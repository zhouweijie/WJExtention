//
//  ViewController.swift
//  WJExtesionDemo
//
//  Created by zhouweijie on 2019/3/21.
//  Copyright © 2019 zhouweijie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.view.mask == nil {
            self.view.showMask()
        } else {
            self.view.hideMask()
        }
    }

}

