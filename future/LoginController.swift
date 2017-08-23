//
//  ViewController.swift
//  future
//
//  Created by kangyonggan on 8/9/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class LoginController: UIViewController {
    
    let loginUrl = "m/login";

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    var isLogout: Bool = false;
    
    var isShowPassword = false;
    
    let dictionaryDao = DictionaryDao();
    
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initView();
        
        tryLogin();
    }
    
    // 尝试登录
    func tryLogin() {
        if !isLogout {
            // 取出本地token，尝试直接登录
            let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: AppConstants.KEY_TOKEN);
            
            if dict == nil {
                // 本地token不存在
                launchAnimation();
            } else {
                let result =  HttpUtil.sendPost(url: AppConstants.DOMAIN + loginUrl, params: ["token": dict!.value!]);
                if result.0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "myTabBarController");
                    self.navigationController?.pushViewController(vc!, animated: false);
                }
            }
        } else {
            // 删除老的token
            dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: AppConstants.KEY_TOKEN);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // 隐藏导航条
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    // 用户名框回车事件
    @IBAction func endInputUsername(_ sender: Any) {
        passwordInput.becomeFirstResponder();
    }
    
    // 密码框回车事件
    @IBAction func endInputPassword(_ sender: Any) {
        // TODO 或者直接登录
        loginBtn.becomeFirstResponder();
    }
    
    // 用户名框修改事件
    @IBAction func editUsername(_ sender: Any) {
        editPassword(sender);
    }
    
    // 密码框修改事件
    @IBAction func editPassword(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        
        if !(username.isEmpty || password.isEmpty) {
            loginBtn.isEnabled = true;
        } else {
            loginBtn.isEnabled = false;
        }
    }
    
    // 登录
    @IBAction func login(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        
        if !StringUtil.isMobile(num: username) {
            ToastUtil.show(message: "请输入正确的手机号", target: view);
            return;
        }
        
        if password.characters.count < 8 || password.characters.count > 20 {
            ToastUtil.show(message: "密码长度为8-20位", target: view);
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        loginBtn.isEnabled = false;
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + loginUrl, data: ["username": username, "password":password], timeout: 5, asyncCompletionHandler: loginCallback)
    }
    
    // 登录请求回调
    func loginCallback(res: HTTPResult) {
        // 在主线程中操作UI，使菊花停止
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
            self.loginBtn.isEnabled = true;
        }
        
        let result = HttpUtil.parse(result: res);
        
        if result.0 {
            // 删除老的token
            dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: AppConstants.KEY_TOKEN);
            
            // 保存token
            let dict = Dictionary();
            dict.key = AppConstants.KEY_TOKEN;
            dict.value = result.2?["token"] as? String;
            dict.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
            dictionaryDao.save(dictionary: dict);
            
            // 保存手机号
            let mobile = Dictionary();
            mobile.key = AppConstants.KEY_USERNAME;
            mobile.value = usernameInput.text!;
            mobile.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
            dictionaryDao.save(dictionary: mobile);
            
            // 在主线程中操作UI，跳转界面
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "myTabBarController");
                self.navigationController?.pushViewController(vc!, animated: true);
            }
        } else {
            // 在主线程中操作UI，提示用户
            DispatchQueue.main.async {
                ToastUtil.show(message: result.1, target: self.view);
            }
        }
    }
    
    // 初始化界面
    func initView() {
        // 修改返回按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 图片
        imageView.layer.cornerRadius = 25;
        imageView.layer.masksToBounds = true;
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(view: usernameInput);
        ViewUtil.addBorderBottom(view: passwordInput);
        
        // 输入框加左侧图标
        ViewUtil.addLeftIcon(textField: usernameInput, icon: "mobile");
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
        
        // 登录按钮
        loginBtn.layer.cornerRadius = 20;
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = UIColor.gray.cgColor;
        loginBtn.layer.masksToBounds = true;
        
        // 忘记密码和注册之间的竖线
        let line = UIView(frame: CGRect(x: bottomView.frame.width / 2, y: 0, width: 1, height: bottomView.frame.height));
        line.backgroundColor = UIColor.gray;
        bottomView.addSubview(line);
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

    // 播放启动画面动画
    private func launchAnimation() {
        // 获取启动视图
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "launch")
        let launchview = vc.view!
        let delegate = UIApplication.shared.delegate
        delegate?.window!!.addSubview(launchview)
        // 如果没有导航栏，直接添加到当前的view即可
        self.view.addSubview(launchview)
        
        // 播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
                       animations: {
                        launchview.alpha = 0.0
                        let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
                        launchview.layer.transform = transform
        }) { (finished) in
            launchview.removeFromSuperview()
        }
    }
}

