//
//  MyController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class MyController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var safeBtn: UIButton!
    
    @IBOutlet weak var questionBtn: UIButton!
    
    @IBOutlet weak var surveyBtn: UIButton!
    
    @IBOutlet weak var onlineBtn: UIButton!
    
    @IBOutlet weak var settingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 导航条
        parent!.navigationItem.title = "我的";
    }
    
    // 设置
    func showSetting(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingController");
        parent?.navigationController?.pushViewController(vc!, animated: true);
    }
    
    func initView() {
        
        // 头像
        imageView.layer.cornerRadius = 15;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = AppConstants.ASSIST_COLOR.cgColor;
        imageView.layer.masksToBounds = true;
        
        // 顶部容器
        topContainerView.layer.cornerRadius = 5;
        topContainerView.layer.masksToBounds = true;
        let color = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1);
        
        // 下划线
        ViewUtil.addBorderBottom(view: safeBtn, color: color, width: 1);
        ViewUtil.addBorderBottom(view: questionBtn, color: color, width: 1);
        ViewUtil.addBorderBottom(view: surveyBtn, color: color, width: 1);
        ViewUtil.addBorderBottom(view: onlineBtn, color: color, width: 1);
        
        
    }
    
}
