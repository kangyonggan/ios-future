//
//  SettingController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        initView();
    }
    
    func initView() {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginController") as! LoginController;
        vc.isLogout = true;
        self.show(vc, sender: self);
    }
    
    
}

