//
//  JMBaseViewController.swift
//  news
//
//  Created by zhouweijie on 2019/5/7.
//  Copyright © 2019 malei. All rights reserved.
//

import UIKit

class JMBaseViewController: UIViewController {
    
    var noDataTipView: JMNoDataTipView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.controllerInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controllerAddSubViews()
        self.controllerPlaceSubViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //防止push到别的不透明navigationBar控制器，回来navigationBar不透明了
        self.setNavigationBarCleaer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        JMTracker.endLogPageView("")
    }

    func setNavigationBarCleaer() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }

    func setCustomBackImage(imageName: String, nightImageName: String?) {
        let backImage = UIImageView(image: UIImage(named: imageName))
        if nightImageName != nil {
            backImage.dk_imagePicker = DKImagePickerWithNames([imageName, nightImageName!])
        }
        backImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backAction))
        backImage.addGestureRecognizer(tap)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImage)
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 重写这个方法在里面初始化数据，不要再调用，JMBaseViewController会在init(nibName:, budle:)方法中调用
    func controllerInitialization() {
    }
    
    /// 重写这个方法在里面addSubView，不要再调用，JMBaseViewController会在viewDidLoad方法中调用
    func controllerAddSubViews() {
    }
    
    /// 重写这个方法在里面布局子视图，不要再调用，JMBaseViewController会在viewDidLoad方法中调用
    func controllerPlaceSubViews() {
    }

}
