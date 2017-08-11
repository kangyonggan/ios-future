//
//  ForgotController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ForgotController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var authCodeInput: UITextField!
    
    @IBOutlet weak var authCodeBtn: UIButton!
    
    @IBOutlet weak var nextStepBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 用户名框回车事件
    @IBAction func didEndInputUsername(_ sender: Any) {
        authCodeInput.becomeFirstResponder();
    }
    
    // 验证码框回车事件
    @IBAction func didEndInputAuthCode(_ sender: Any) {
        nextStepBtn.becomeFirstResponder();
    }
    
    // 监听修改用户名
    @IBAction func editUsername(_ sender: Any) {
        editAuthCode(sender);
    }
    
    // 监听修改验证码
    @IBAction func editAuthCode(_ sender: Any) {
        let username =  usernameInput.text!;
        let authCode = authCodeInput.text!;
        
        if !(username.isEmpty || authCode.isEmpty) {
            nextStepBtn.isEnabled = true;
            nextStepBtn.backgroundColor = AppConstants.MASTER_COLOR;
        } else {
            nextStepBtn.isEnabled = false;
            nextStepBtn.backgroundColor = UIColor.lightGray;
        }
    }
    
    // 初始化界面
    func initView() {
        // 显示导航条
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(view: usernameInput);
        ViewUtil.addBorderBottom(view: authCodeInput);
        
        // 输入框加左侧图标
        ViewUtil.addLeftIcon(textField: usernameInput, icon: "mobile");
        ViewUtil.addLeftIcon(textField: authCodeInput, icon: "authCode");
        
        // 获取验证码按钮
        authCodeBtn.layer.cornerRadius = 5;
        authCodeBtn.layer.masksToBounds = true;
        
        // 下一步按钮
        nextStepBtn.layer.cornerRadius = 20;
        nextStepBtn.layer.masksToBounds = true;
        nextStepBtn.backgroundColor = UIColor.lightGray;
        
        // 焦点
        usernameInput.becomeFirstResponder();
    }

}
