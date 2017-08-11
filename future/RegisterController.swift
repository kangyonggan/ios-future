//
//  RehisterController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var authCodeInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var authCodeBtn: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    var isShowPassword = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
    }
    
    // 用户名框回车事件
    @IBAction func endInputUsername(_ sender: Any) {
        authCodeInput.becomeFirstResponder();
    }
    
    // 验证码框回车事件
    @IBAction func endInputAuthCode(_ sender: Any) {
        passwordInput.becomeFirstResponder();
    }
    
    // 密码框回车事件
    @IBAction func endInputPassword(_ sender: Any) {
        registerBtn.becomeFirstResponder();
    }
    
    // 监听用户名输入
    @IBAction func editUsername(_ sender: Any) {
        editPassword(sender);
    }
    
    // 监听验证码输入
    @IBAction func editAuthCode(_ sender: Any) {
        editPassword(sender);
    }
    
    // 监听密码输入
    @IBAction func editPassword(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        let authCode = authCodeInput.text!;
        
        if !(username.isEmpty || password.isEmpty || authCode.isEmpty) {
            registerBtn.isEnabled = true;
            registerBtn.backgroundColor = AppConstants.MASTER_COLOR;
        } else {
            registerBtn.isEnabled = false;
            registerBtn.backgroundColor = UIColor.lightGray;
        }
    }
    
    // 初始化界面
    func initView() {
        // 显示导航条
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(view: usernameInput);
        ViewUtil.addBorderBottom(view: authCodeInput);
        ViewUtil.addBorderBottom(view: passwordInput);
        
        // 输入框加左侧图标
        ViewUtil.addLeftIcon(textField: usernameInput, icon: "mobile");
        ViewUtil.addLeftIcon(textField: authCodeInput, icon: "authCode");
        ViewUtil.addLeftIcon(textField: passwordInput, icon: "password");
        
        // 密码框右侧图标
        let rightView = UIImageView(frame: CGRect(x: passwordInput.frame.width - 30, y: 0, width: 20, height: 20));
        rightView.image = UIImage(named: "eye");
        passwordInput.rightView = rightView;
        passwordInput.rightViewMode = UITextFieldViewMode.always;
        
        // 查看密码事件监听/////添加tapGuestureRecognizer手势
        rightView.isUserInteractionEnabled = true;
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)));
        rightView.addGestureRecognizer(tapGR)
        
        // 获取验证码按钮
        authCodeBtn.layer.cornerRadius = 5;
        authCodeBtn.layer.masksToBounds = true;
        
        // 注册按钮
        registerBtn.layer.cornerRadius = 20;
        registerBtn.layer.masksToBounds = true;
        registerBtn.backgroundColor = UIColor.lightGray;
        
        // 焦点
        usernameInput.becomeFirstResponder();
    }
    
    // 手势处理函数
    func tapHandler(sender: UITapGestureRecognizer) {
        if isShowPassword {
            (passwordInput.rightView as! UIImageView).image = UIImage(named: "eye");
            passwordInput.isSecureTextEntry = true;
        } else {
            (passwordInput.rightView as! UIImageView).image = UIImage(named: "eyeSelected");
            passwordInput.isSecureTextEntry = false;
        }
        
        isShowPassword = !isShowPassword;
    }
}
