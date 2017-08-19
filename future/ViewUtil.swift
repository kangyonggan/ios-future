//
//  ViewUtil.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ViewUtil: NSObject {
    
    // 给输入框左侧添加图标
    static func addLeftIcon(textField: UITextField, icon: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20));
        imageView.image = UIImage(named: icon);
        textField.leftView = imageView;
        textField.leftViewMode = UITextFieldViewMode.always;
    }
    
    // 给输入框左侧添加图标
    static func addLeftIcon(textField: UITextField, icon: String, withSize: Int) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: withSize, height: withSize));
        imageView.image = UIImage(named: icon);
        textField.leftView = imageView;
        textField.leftViewMode = UITextFieldViewMode.always;
    }
    
    // 给控件加下边框，默认gray颜色
    static func addBorderBottom(view: UIView) {
        ViewUtil.addBorderBottom(view: view, color: UIColor.gray);
    }
    
    // 给控件加下边框，自己提供颜色
    static func addBorderBottom(view: UIView, color: UIColor) {
        let line = UIView(frame: CGRect(x: 0, y: view.frame.height - 1, width: view.frame.width, height: 1));
        line.backgroundColor = color;
        view.addSubview(line);
    }
    
    // 给控件加下边框，自己提供颜色，自己定义宽度
    static func addBorderBottom(view: UIView, color: UIColor, width: CGFloat) {
        let wid = view.frame.width * width;
        let line = UIView(frame: CGRect(x: (view.frame.width - wid) / 2, y: view.frame.height - 1, width: wid, height: 1));
        line.backgroundColor = color;
        view.addSubview(line);
    }
    
    // 获取加载中图标
    static func loadingView(center: CGPoint) -> UIActivityIndicatorView {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingView.color = AppConstants.MASTER_COLOR
        loadingView.center = center;
        
        return loadingView;
    }
    
    // 异步加载图片
    static func loadImage(string: String, imageView: UIImageView) {
        let url = URL(string: string)!;
        let request = URLRequest(url: url);
        
        let session = URLSession.shared;
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let img = UIImage(named: "defaultCover");
                imageView.image = img;
            }else{
                let img = UIImage(data:data!)
                imageView.image = img;
            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
}
