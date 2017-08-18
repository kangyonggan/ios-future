//
//  BookSearchView.swift
//  future
//
//  Created by kangyonggan on 8/14/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        initView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initView() {
        // 搜索框
        let input = UITextField(frame: CGRect(x: 20, y: 15, width: self.frame.width - 100, height: 30));
        input.layer.borderWidth = 1;
        input.layer.cornerRadius = 5;
        input.layer.borderColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1).cgColor;
        input.placeholder = "请输入书名或作者名";
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        imageView.image = UIImage(named: "search");
        input.leftView = imageView;
        input.leftViewMode = UITextFieldViewMode.always;
        self.addSubview(input);
        
        // 搜索按钮
        let btn = UIButton(frame: CGRect(x: self.frame.width - 70, y: 15, width: 50, height: 30));
        btn.setTitle("搜索", for: .normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = AppConstants.MASTER_COLOR;
        btn.layer.cornerRadius = 5;
        
        self.addSubview(btn);
        
    }
    
}
