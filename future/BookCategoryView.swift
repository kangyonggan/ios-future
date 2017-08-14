//
//  BookCategoryView.swift
//  future
//
//  Created by kangyonggan on 8/12/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookCategoryView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initView(categories: [(String, String, Int)]) {
        for i in 0..<categories.count {
            let colIndex = i % 3;
            let rowIndex = i / 3;
            
            let btn = UIButton(frame: CGRect(x: CGFloat(colIndex) * frame.width / 3, y: CGFloat(rowIndex * 58), width: frame.width / 3, height: 58));
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13);
            btn.setTitle(categories[i].1, for: .normal);
            btn.setTitleColor(UIColor.black, for: .normal);
            
            let label = UILabel(frame: CGRect(x: 0, y: 38, width: btn.frame.width, height: 15));
            label.text = "\(categories[i].2)本";
            label.textAlignment = .center;
            label.textColor = UIColor.lightGray;
            label.font = UIFont.systemFont(ofSize: 10);
            btn.addSubview(label);
            
            // 下线
            let line = UIView(frame: CGRect(x: 0, y: btn.frame.height, width: btn.frame.width, height: 1));
            line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1);
            btn.addSubview(line);
            
            // 右线
            if colIndex != 2 {
                let line = UIView(frame: CGRect(x: btn.frame.width, y: 0, width: 1, height: btn.frame.height));
                line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1);
                btn.addSubview(line);
            }
            
            
            addSubview(btn)
        }
        
    }
    
    
}
