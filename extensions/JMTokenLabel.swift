//
//  JMYYLabel.swift
//  news
//
//  Created by zhouweijie on 2019/7/24.
//  Copyright © 2019 malei. All rights reserved.
//

import UIKit

@objcMembers class JMTokenLabel: YYLabel {

    //headImageView相关
    private(set) var headImageView: UIImageView?
    var leftInset: CGFloat = 2
    var topInset: CGFloat = 1
    ///利用firstLineHeadIndent的空间添加头部图片，不使用attachment，因为会使得justified对齐方式在第一行失效,所以要记得设置
    private(set) var pragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()

    //truncationToken相关
    private(set) var hasToken: Bool
    var tokenForegroundColor: UIColor = UIColor.hex(hexValue: 0x4769A9)
    /// 给token添加手势时用这个属性获取view
    private(set) lazy var tokenLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    /// 记录要折叠的行数,使用token时用这个属性配置行数，为了不再刷新cell时，修改numberOfLines属性为零替换了原来的值，不用token使用原来的
    var foldLines: UInt = 2

    private var dayColor: UIColor = UIColor.hex(hexValue: 0x888888)
    private var nightColor: UIColor = UIColor.hex(hexValue: 0x333333)

    /// 唯一初始化方法
    ///
    /// - Parameters:
    ///   - headImageView: 段落前要加图片就给一个值
    ///   - hasToken: 段落后是否有“...展开”和“ 收起”
    init(headImageView: UIImageView?, hasToken: Bool) {
        self.hasToken = hasToken
        self.headImageView = headImageView
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: NSNotification.Name(rawValue: DKNightVersionThemeChangingNotificaiton), object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 用这个方法设置内容
    ///
    /// - Parameters:
    ///   - attrStr: 要设置的属性字符串，添加过属性后传入
    ///   - isFolding: 是否是折叠状态，根据这个状态决定“ 收起”或“...展开”,如果没有token，传任意值都无影响
    func setAttributedText(attrStr: NSMutableAttributedString, isFolding: Bool) {
        self.isFolding = isFolding
        let attr1 = self.setupHeadImage(attrStr: attrStr)
        let attr2 = self.setupToken(attrStr: attr1, isFolding: isFolding);
        if DKNightVersionManager.isNight() {
            attr2.addAttribute(NSAttributedString.Key.foregroundColor, value: nightColor, range: attr2.yy_rangeOfAll())
        } else {
            attr2.addAttribute(NSAttributedString.Key.foregroundColor, value: dayColor, range: attr2.yy_rangeOfAll())
        }
        //利用firstLineHeadIndent的空间添加头部图片，不使用attachment，因为会使得justified对齐方式在第一行失效
        attr2.addAttribute(NSAttributedString.Key.paragraphStyle, value: pragraphStyle, range: attr2.yy_rangeOfAll())
        attr2.addAttribute(NSAttributedString.Key.font, value: self.font!, range: attr2.yy_rangeOfAll())
        self.attributedText = attr2
    }

    func setDayAndNightColor(day: UIColor, night: UIColor) {
        self.dayColor = day
        self.nightColor = night
    }

    private var isFolding = false//themeDidChange要用到

}

extension JMTokenLabel {
    @objc private func themeDidChange() {
        if self.attributedText != nil {
            self.setAttributedText(attrStr: NSMutableAttributedString(attributedString: self.attributedText!), isFolding: self.isFolding)
        }
    }

    private func setupHeadImage(attrStr: NSMutableAttributedString) -> NSMutableAttributedString {
        if self.headImageView != nil {
            self.addSubview(headImageView!)
            headImageView!.frame = CGRect(origin: CGPoint(x: leftInset, y: topInset), size: headImageView!.intrinsicContentSize)
        }
        return attrStr
    }

    private func setupToken(attrStr: NSMutableAttributedString, isFolding: Bool) -> NSMutableAttributedString {
        if self.hasToken {
            if isFolding {
                self.numberOfLines = self.foldLines

                let tokenStr = NSMutableAttributedString(string: "...展开")
                tokenStr.addAttributes([NSAttributedString.Key.font:self.font!, NSAttributedString.Key.foregroundColor:tokenForegroundColor], range: tokenStr.yy_rangeOfAll())
                self.tokenLabel.attributedText = tokenStr
                self.tokenLabel.sizeToFit()
                let token = NSAttributedString.yy_attachmentString(withContent: tokenLabel, contentMode: .center, attachmentSize: tokenLabel.intrinsicContentSize, alignTo: self.font, alignment: .center)
                self.truncationToken = token
            } else {
                self.numberOfLines = 0

                let tokenStr = NSMutableAttributedString(string: " 收起")
                tokenStr.addAttributes([NSAttributedString.Key.font:self.font!, NSAttributedString.Key.foregroundColor:tokenForegroundColor], range: tokenStr.yy_rangeOfAll())
                self.tokenLabel.attributedText = tokenStr
                self.tokenLabel.sizeToFit()
                let token = NSAttributedString.yy_attachmentString(withContent: tokenLabel, contentMode: .center, attachmentSize: tokenLabel.intrinsicContentSize, alignTo: self.font, alignment: .center)
                attrStr.append(token)//展开后拼接“收起”token
            }
        }
        return attrStr
    }
}
