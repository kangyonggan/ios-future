//
//  UpdatePasswordController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class UpdatePasswordController: UIViewController {
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 密码框回车事件
    @IBAction func endInputPassword(_ sender: Any) {
        finishBtn.becomeFirstResponder();
    }
    
    // 监听修改密码
    @IBAction func editPassword(_ sender: Any) {
        let password =  passwordInput.text!;
        
        if !(password.isEmpty) {
            finishBtn.isEnabled = true;
            finishBtn.backgroundColor = AppConstants.MASTER_COLOR;
        } else {
            finishBtn.isEnabled = false;
            finishBtn.backgroundColor = UIColor.lightGray;
        }
    }
    
    // 初始化界面
    func initView() {
        // 显示导航条
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(view: passwordInput);
        
        // 输入框加左侧图标
        ViewUtil.addLeftIcon(textField: passwordInput, icon: "password");
        
        // 完成按钮
        finishBtn.layer.cornerRadius = 20;
        finishBtn.layer.masksToBounds = true;
        finishBtn.backgroundColor = UIColor.lightGray;
        
        // 焦点
        passwordInput.becomeFirstResponder();

    }
    
}
