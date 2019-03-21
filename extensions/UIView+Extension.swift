//
//  UIView+Extension.swift
//  news
//
//  Created by zhouweijie on 2019/2/21.
//  Copyright © 2019 malei. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func viewController() -> UIViewController? {
        var view: UIResponder = self
        while view.next != nil {
            if view.next!.isKind(of: UIViewController.self) {
                return view.next as? UIViewController
            } else {
                view = view.next!
            }
        }
        return nil
    }
    
    func showMask() {
        self.showMask(color: UIColor.hex(hexValue: 0x000000), alpha: 0.3)
    }
    
    func showMask(color: UIColor, alpha: CGFloat) {
        if self.mask == nil {
            let mask = UIView()
            mask.backgroundColor = color
            mask.alpha = alpha
            mask.frame = self.bounds
            self.mask = mask
        }
    }
    
    func hideMask() {
        self.mask = nil
    }

}
