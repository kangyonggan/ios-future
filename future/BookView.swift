//
//  BookView.swift
//  future
//
//  Created by kangyonggan on 8/17/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookView: UIView {
    let bookSectionsUrl = "m/book/findBookSections";
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initView(book: Book) {
        // 左边图片
        let img = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 75));
        let url = URL(string: AppConstants.DOMAIN + book.picUrl!);
        let data = try! Data(contentsOf: url!);
        img.image = UIImage(data: data);
        
        self.addSubview(img);
        
        
        // 右上
        let titleLabel = UILabel(frame: CGRect(x: 80, y: 10, width: self.frame.width - 80, height: 20));
        titleLabel.text = book.name;
        titleLabel.textColor = UIColor.darkText;
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: 0.2)
        self.addSubview(titleLabel);
        
        // 右中
        let descLabel = UILabel(frame: CGRect(x: 80, y: 25, width: self.frame.width - 80, height: 50));
        descLabel.text = book.descp;
        descLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8);
        descLabel.font = UIFont.systemFont(ofSize: 12);
        descLabel.numberOfLines = 2;
        
        self.addSubview(descLabel);
        
        // 右下左
        let authorLabel = UILabel(frame: CGRect(x: 80, y: 70, width: 100, height: 15));
        authorLabel.text = book.author;
        authorLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8);
        authorLabel.font = UIFont.systemFont(ofSize: 13);
        self.addSubview(authorLabel);
        
        
        // 右下右右
        let statusLabel = UILabel(frame: CGRect(x: self.frame.width - 35, y: 70, width: 30, height: 15));
        if book.isFinished! {
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
        categoryLabel.text = book.categoryName;
        categoryLabel.textColor = AppConstants.MASTER_COLOR;
        categoryLabel.font = UIFont.systemFont(ofSize: 13);
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = AppConstants.MASTER_COLOR.cgColor;
        categoryLabel.layer.masksToBounds = true;
        categoryLabel.layer.cornerRadius = 5;
        categoryLabel.textAlignment = .center;
        self.addSubview(categoryLabel);
        
        // 最新章节
        let newSectionBtn = UIButton(frame: CGRect(x: 10, y: 95, width: frame.width - 10, height: 20));
        newSectionBtn.setTitle("最新：第一千八百三十六章：以彼之道还施彼身", for: .normal);
        newSectionBtn.titleLabel?.textAlignment = .left;
        newSectionBtn.setTitleColor(AppConstants.MASTER_COLOR, for: .normal)
        newSectionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        newSectionBtn.addTarget(self, action: #selector(showNewSection), for: .touchUpInside)
        
        self.addSubview(newSectionBtn);
        
        // 最后阅读的章节
        let lastSectionBtn = UIButton(frame: CGRect(x: 10, y: 120, width: frame.width - 10, height: 20));
        lastSectionBtn.setTitle("上次：第一千八百三十六章：以彼之道还施彼身", for: .normal);
        lastSectionBtn.titleLabel?.textAlignment = .left;
        lastSectionBtn.setTitleColor(AppConstants.MASTER_COLOR, for: .normal)
        lastSectionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        lastSectionBtn.addTarget(self, action: #selector(showLastSection), for: .touchUpInside)
        self.addSubview(lastSectionBtn);
        
        // 底线
        let line = UIView(frame: CGRect(x: 0, y: 145, width: frame.width, height: 1));
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1);
        self.addSubview(line);
        
        // 章节列表
        let listView = SectionListView(frame: CGRect(x: 0, y: 150, width: frame.width, height: frame.height - 150));
        var sectionList = [Section]();
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + bookSectionsUrl, params: ["code": String(book.code!), "p": "1"]);
        
        if result.0 {
            let sections = result.2?["sections"] as! NSArray;
            for s in sections {
                let ss = s as! NSDictionary
                let section = Section();
                section.code = ss["code"] as? Int;
                section.title = ss["title"] as? String;
                section.content = ss["content"] as? String;
                section.prevSectionCode = ss["prevSectionCode"] as? Int;
                section.nextSectionCode = ss["nextSectionCode"] as? Int;
                section.bookCode = ss["bookCode"] as? Int;
                
                sectionList.append(section);
            }
        } else {
            ToastUtil.show(message: result.1);
        }
        
        listView.initView(book: book, sections: sectionList);
        self.addSubview(listView);
    }
    
    // 最新章节
    func showNewSection(){
        print("showNewSection")
    }
    
    // 最后章节
    func showLastSection(){
        print("showLastSection")
    }
    
}
