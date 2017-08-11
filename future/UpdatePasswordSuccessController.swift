//
//  UpdatePasswordController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class UpdatePasswordSuccessController: UIViewController {
    
    @IBOutlet weak var reloginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }

    // 初始化界面
    func initView() {
        // 重新登录按钮
        reloginBtn.layer.cornerRadius = 20;
        reloginBtn.layer.masksToBounds = true;
        
        // 隐藏返回按钮
        self.navigationItem.hidesBackButton = true;

    }
    
    // 重新登录
    @IBAction func relogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginController") as! LoginController;
        vc.isLogout = true;
        self.show(vc, sender: self);
    }
}
