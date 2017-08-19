//
//  AppConstants.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class AppConstants: NSObject {
    
    // 基地址
        static let DOMAIN = "https://kangyonggan.com/";
//    static let DOMAIN = "http://10.10.10.100:8080/";
//    static let DOMAIN = "http://127.0.0.1:8080/";
    
    // 字典默认类型
    static let DICTIONERY_TYPE_DEFAULT = "default";
    
    // 登录token存放在库中的key
    static let KEY_TOKEN = "KEY_TOKEN";
    
    // 用户名存放在库中的key
    static let KEY_USERNAME = "KEY_USERNAME";
    
    // 主色
    static let MASTER_COLOR = UIColor(red: 255/255, green: 85/255, blue: 55/255, alpha: 1);
    
    // 辅色
    static let ASSIST_COLOR = UIColor(red: 245/255, green: 80/255, blue: 50/255, alpha: 1);
}
