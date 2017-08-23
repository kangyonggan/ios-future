//
//  RehisterController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class RegisterController: UIViewController {
    
    let registerUrl = "m/register";
    let authCodeUrl = "m/sms/send";
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var authCodeInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var authCodeBtn: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    var isShowPassword = false;
    
    var timer: Timer?;
    var time = 0;
    
    let dictionaryDao = DictionaryDao();
    
    var loadingView: UIActivityIndicatorView!;
    
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
    
    // 注册
    @IBAction func register(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        let authCode = authCodeInput.text!;
        
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
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + registerUrl, data: ["username": username, "password":password, "authCode": authCode], timeout: 5, asyncCompletionHandler: registerCallback)
        
        
    }
    
    // 注册回调
    func registerCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
        if result.0 {
            // 删除老的token
            dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: AppConstants.KEY_TOKEN);
            
            // 保存token
            let dict = MyDictionary();
            dict.key = AppConstants.KEY_TOKEN;
            dict.value = result.2?["token"] as? String;
            dict.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
            dictionaryDao.save(dictionary: dict);
            
            // 跳转到注册成功界面
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "registerSuccessController");
                self.navigationController?.pushViewController(vc!, animated: true);
            }
        } else {
            DispatchQueue.main.async {
                ToastUtil.show(message: result.1, target: self.view);
            }
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
        self.registerBtn.isEnabled = false;
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + authCodeUrl, data: ["mobile": username, "type": "REGISTER"], timeout: 5, asyncCompletionHandler: authCodeCallback)
    }

    // 获取验证码回调
    func authCodeCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
            self.registerBtn.isEnabled = true;
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
        self.time += 1;
        self.authCodeBtn.setTitle("\(60-self.time)秒", for: UIControlState.normal);
            
        if (self.time > 60) {
            self.time = 0;
            self.authCodeBtn.isEnabled = true;
            self.authCodeBtn.backgroundColor = AppConstants.MASTER_COLOR;
            self.timer?.invalidate();
            self.authCodeBtn.setTitle("重新获取", for: UIControlState.normal);
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
        
        // 注册按钮
        registerBtn.layer.cornerRadius = 20;
        registerBtn.layer.masksToBounds = true;
        registerBtn.backgroundColor = UIColor.lightGray;
        
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
