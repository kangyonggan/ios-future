//
//  OtherController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class OtherController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 导航条
        self.parent?.navigationItem.title = "综合";
    }
    
    func initView() {
    }
    
}
