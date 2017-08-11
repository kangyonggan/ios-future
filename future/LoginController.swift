//
//  ViewController.swift
//  future
//
//  Created by kangyonggan on 8/9/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Toaster
import Just

class LoginController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    var isLogout: Bool = false;
    
    let dictionaryDao = DictionaryDao();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initView();
        
        if !isLogout {
            // 取出本地token，尝试直接登录
            let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_COMMON, key: AppConstants.KEY_TOKEN);
            
            if dict == nil {
                // 本地token不存在
                launchAnimation();
            } else {
                let result = login(username: "", password: "", token: dict!.value!);
                if result.0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "myTabBarController");
                    self.navigationController?.pushViewController(vc!, animated: false);
                }
            }
        } else {
            // 删除老的token
            dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_COMMON, key: AppConstants.KEY_TOKEN);
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
        
        let result = login(username: username, password: password, token: "");
        
        if result.0 {
            // 删除老的token
            dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_COMMON, key: AppConstants.KEY_TOKEN);
            
            // 保存token
            let dict = MyDictionary();
            dict.key = AppConstants.KEY_TOKEN;
            dict.value = result.2;
            dict.type = AppConstants.DICTIONERY_TYPE_COMMON;
            dictionaryDao.save(dictionary: dict);
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "myTabBarController");
            self.navigationController?.pushViewController(vc!, animated: true);
        } else {
            Toast(text: result.1).show();
            
        }
        
    }
    
    // 登录请求
    func login(username: String, password: String, token: String) -> (Bool, String, String) {
        var res = (false, "", "");
        
        let result = Just.post("http://127.0.0.1:8080/m/login", data: ["username": username, "password":password, "token": token]);
        
        if result.ok {
            let response = result.json as! NSDictionary;
            let respCo = response["respCo"] as! String;
            let respMsg = response["respMsg"] as! String;
            let token = response["token"] as! String;
            
            res.1 = respMsg;
            res.2 = token;
            
            if respCo == "0000" {
                res.0 = true;
            }
        } else {
            res.1 = "通讯异常，请稍后再试";
        }
        
        return res;
    }
    
    // 初始化界面
    func initView() {
        // 修改返回按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        // 图片
        imageView.layer.cornerRadius = 25;
        imageView.layer.masksToBounds = true;
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(view: usernameInput);
        ViewUtil.addBorderBottom(view: passwordInput);
        
        // 输入框加左侧图标
        ViewUtil.addLeftIcon(textField: usernameInput, icon: "mobile");
        ViewUtil.addLeftIcon(textField: passwordInput, icon: "password");
        
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

