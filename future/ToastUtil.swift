//
//  ToastUtil.swift
//  future
//
//  Created by kangyonggan on 8/11/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation
import Toaster;

class ToastUtil: NSObject {
    
    // 提示信息
    static func show(message: String) {
        Toast(text: message).show();
    }
    
}
