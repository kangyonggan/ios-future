//
//  ForgotController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class ForgotController: UIViewController {
    
    let forgotUrl = "m/forgot";
    let authCodeUrl = "m/sms/send";
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var authCodeInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var authCodeBtn: UIButton!
    
    @IBOutlet weak var nextStepBtn: UIButton!
    
    var isShowPassword = false;
    
    var timer: Timer?;
    var time = 0;
    
    var loadingView: UIActivityIndicatorView!;
    
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
        passwordInput.becomeFirstResponder();
    }
    
    // 密码框回车事件
    @IBAction func didEndInputPassword(_ sender: Any) {
        nextStepBtn.becomeFirstResponder();
    }
    
    // 监听修改用户名
    @IBAction func editUsername(_ sender: Any) {
        editAuthCode(sender);
    }
    
    // 监听修改密码
    @IBAction func editPassword(_ sender: Any) {
        editAuthCode(sender);
    }
    
    // 监听修改验证码
    @IBAction func editAuthCode(_ sender: Any) {
        let username = usernameInput.text!;
        let authCode = authCodeInput.text!;
        let password = passwordInput.text!;
        
        if !(username.isEmpty || authCode.isEmpty || password.isEmpty) {
            nextStepBtn.isEnabled = true;
            nextStepBtn.backgroundColor = AppConstants.MASTER_COLOR;
        } else {
            nextStepBtn.isEnabled = false;
            nextStepBtn.backgroundColor = UIColor.lightGray;
        }
    }
    
    // 获取验证码
    @IBAction func getAuthCode(_ sender: Any) {
        let username =  usernameInput.text!;
        if !StringUtil.isMobile(num: username) {
            ToastUtil.show(message: "请输入正确的手机号", target: view);
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + authCodeUrl, data: ["mobile": username, "type": "FORGOT"], timeout: 5, asyncCompletionHandler: authCodeCallback)
    }
    
    // 获取验证码回调
    func authCodeCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
        if result.0 {
            DispatchQueue.main.async {
                ToastUtil.show(message: "获取验证码成功", target: self.view);
                
                self.time = 0;
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateAuthCodeBtn), userInfo: nil, repeats: true);
                self.authCodeBtn.isEnabled = false;
                self.authCodeBtn.backgroundColor = UIColor.lightGray;
            }
        } else {
            DispatchQueue.main.async {
                ToastUtil.show(message: result.1, target: self.view);
            }
        }
    }
    
    // 更新获取验证码按钮
    func updateAuthCodeBtn() {
        time += 1;
        authCodeBtn.setTitle("\(60-time)秒", for: UIControlState.normal);
        
        if (time > 60) {
            time = 0;
            authCodeBtn.isEnabled = true;
            timer?.invalidate();
            authCodeBtn.setTitle("重新获取", for: UIControlState.normal);
            authCodeBtn.backgroundColor = AppConstants.MASTER_COLOR;
        }
    }
    
    // 下一步
    @IBAction func nextStep(_ sender: Any) {
        let username =  usernameInput.text!;
        let authCode = authCodeInput.text!;
        let password = passwordInput.text!;
        
        if username.characters.count != 11 {
            ToastUtil.show(message: "请输入正确的手机号", target: view);
            return;
        }
        
        if authCode.characters.count != 4 {
            ToastUtil.show(message: "验证码的长度必须是4位", target: view);
            return;
        }
        
        if password.characters.count < 8 || password.characters.count > 20 {
            ToastUtil.show(message: "密码长度为8-20位", target: view);
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        self.nextStepBtn.isEnabled = false;
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + forgotUrl, data: ["username": username, "authCode": authCode, "password": password], timeout: 5, asyncCompletionHandler: forgotCallback)
    }
    
    // 找回密码回调
    func forgotCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
            self.nextStepBtn.isEnabled = true;
        }
        
        let result = HttpUtil.parse(result: res);
        
        if result.0 {
            // 跳转到更新密码成功界面
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "updatePasswordSuccessController");
                self.navigationController?.pushViewController(vc!, animated: true);
            }
        } else {
            DispatchQueue.main.async {
                ToastUtil.show(message: result.1, target: self.view);
            }
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
        authCodeBtn.backgroundColor = AppConstants.MASTER_COLOR;
        
        // 下一步按钮
        nextStepBtn.layer.cornerRadius = 20;
        nextStepBtn.layer.masksToBounds = true;
        nextStepBtn.backgroundColor = UIColor.lightGray;
        
        // 焦点
//        usernameInput.becomeFirstResponder();
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
