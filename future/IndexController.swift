//
//  IndexController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class IndexController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 导航条
        self.parent?.navigationItem.title = "首页";
    }
    
    func initView() {
    }
    
}
