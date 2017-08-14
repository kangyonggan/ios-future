//
//  BookHotself.swift
//  future
//
//  Created by kangyonggan on 8/13/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit


class BookHotCell: UITableViewCell {
    
    func initView(bookList: [Book], row: Int, tableView: UITableView) {
        
        // 清空子view，防止重叠
        while self.subviews.last != nil {
            self.subviews.last?.removeFromSuperview();
        }
        
        // 宽度不知道为什么会变化，那就写死！
        let cellFrame = self.frame;
        let newFrame = CGRect(x: cellFrame.maxX, y: cellFrame.maxY, width: tableView.frame.width, height: tableView.rowHeight);
        self.frame = newFrame;
        
        // 左边图片
        let img = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 75));
        img.image = UIImage(named: bookList[row].picUrl!);
        
        self.addSubview(img);
        
        
        // 右上
        let titleLabel = UILabel(frame: CGRect(x: 80, y: 10, width: self.frame.width - 80, height: 20));
        titleLabel.text = bookList[row].name;
        titleLabel.textColor = UIColor.darkText;
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: 0.2)
        self.addSubview(titleLabel);
        
        // 右中
        let descLabel = UILabel(frame: CGRect(x: 80, y: 25, width: self.frame.width - 80, height: 50));
        descLabel.text = bookList[row].desc;
        descLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8);
        descLabel.font = UIFont.systemFont(ofSize: 12);
        descLabel.numberOfLines = 2;
        
        self.addSubview(descLabel);
        
        // 右下左
        let authorLabel = UILabel(frame: CGRect(x: 80, y: 70, width: 100, height: 15));
        authorLabel.text = bookList[row].author;
        authorLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8);
        authorLabel.font = UIFont.systemFont(ofSize: 13);
        self.addSubview(authorLabel);
        
        // 右下右右
        let statusLabel = UILabel(frame: CGRect(x: self.frame.width - 35, y: 70, width: 30, height: 15));
        if bookList[row].isFinished! {
            statusLabel.text = "完结";
            statusLabel.backgroundColor = UIColor(red: 30/255, green: 87/255, blue: 55/255, alpha: 1);
        } else {
            statusLabel.text = "连载";
            statusLabel.backgroundColor = UIColor(red: 240/255, green: 65/255, blue: 85/255, alpha: 1);
        }
        statusLabel.textColor = UIColor.white;
        statusLabel.font = UIFont.systemFont(ofSize: 13);
        statusLabel.layer.masksToBounds = true;
        statusLabel.layer.cornerRadius = 5;
        statusLabel.textAlignment = .center;
        self.addSubview(statusLabel);
        
        // 右下右左
        let categoryLabel = UILabel(frame: CGRect(x: self.frame.width - 70, y: 70, width: 30, height: 15));
        categoryLabel.text = bookList[row].categories?.1;
        categoryLabel.textColor = AppConstants.MASTER_COLOR;
        categoryLabel.font = UIFont.systemFont(ofSize: 13);
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = AppConstants.MASTER_COLOR.cgColor;
        categoryLabel.layer.masksToBounds = true;
        categoryLabel.layer.cornerRadius = 5;
        categoryLabel.textAlignment = .center;
        self.addSubview(categoryLabel);
        
        // 底线
        let line = UIView(frame: CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1));
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1);
        self.addSubview(line);
    }
    
}
