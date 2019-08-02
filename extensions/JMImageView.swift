//
//  JMImageView.swift
//  news
//
//  Created by zhouweijie on 2019/5/20.
//  Copyright © 2019 malei. All rights reserved.
//

import UIKit

@objcMembers class JMImageView: UIImageView {

    private(set) var dayImage: UIImage?

    private(set) var nightImage: UIImage?

    ///不传nightImage就会加蒙层
    convenience init(dayImage: UIImage?, nightImage: UIImage?) {
        self.init(frame: .zero)
        self.dayImage = dayImage
        self.nightImage = nightImage
    }
    ///网络加载图片适合用这个初始化方法，会自动加蒙层
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: NSNotification.Name(rawValue: DKNightVersionThemeChangingNotificaiton), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func themeDidChange() {
        if DKNightVersionManager.isNight() {
            if (self.nightImage != nil) {
                self.image = self.nightImage
            } else {
                self.showMask()
            }
        } else {
            if (self.nightImage != nil) {
                self.image = self.dayImage
            } else {
                self.hideMask()
            }
        }
    }

    var maskview: UIView?

    func showMask() {
        self.showMask(color: UIColor.hex(hexValue: 0x000000), alpha: 0.3)
    }

    func showMask(color: UIColor, alpha: CGFloat) {
        if maskview == nil {
            let mask = UIView()
            mask.backgroundColor = color
            mask.alpha = alpha
            mask.isHidden = false
            self.maskview = mask
            self.addSubview(maskview!)
            self.bringSubviewToFront(maskview!)
            maskview?.mas_makeConstraints({ (make) in
                make?.edges.equalTo()(self)
            })
        } else {
            maskview?.isHidden = false
        }
    }

    func hideMask() {
        maskview?.isHidden = true
    }

}
