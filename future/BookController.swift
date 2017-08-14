//
//  ContactsController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ContactsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 添加
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItemStyle.done, target: nil, action: nil);
        
        // 导航条
        parent?.navigationItem.title = "通讯录";
    }
    
    func initView() {
    }
    
}
