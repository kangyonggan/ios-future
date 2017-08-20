//
//  ToastUtil.swift
//  future
//
//  Created by kangyonggan on 8/11/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation
//import Toaster;
import Toast_Swift;

class ToastUtil: NSObject {
    
    // 提示信息
    static func show(message: String, target: UIView) {
//        Toast(text: message).show();
        target.makeToast(message, duration: 2, position: CGPoint(x: target.center.x, y: target.center.y + 200))
    }
    
}
