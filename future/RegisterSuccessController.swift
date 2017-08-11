//
//  RegisterSuccessController.swift
//  future
//
//  Created by kangyonggan on 8/11/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class RegisterSuccessController: UIViewController {
    
    @IBOutlet weak var userInfoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        
        // 完善个人资料按钮
        userInfoBtn.layer.cornerRadius = 20;
        userInfoBtn.layer.masksToBounds = true;
        
        // 隐藏返回按钮
        self.navigationItem.hidesBackButton = true;
    }

    // 去修改资料界面
    @IBAction func showUserInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "myTabBarController");
        self.navigationController?.pushViewController(vc!, animated: true);
    }
}

