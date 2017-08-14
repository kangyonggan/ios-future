//
//  BookHotView.swift
//  future
//
//  Created by kangyonggan on 8/13/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookHotView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_ID = "hotCell";
    var bookList = [Book]();
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 95;
        self.register(BookHotCell.self, forCellReuseIdentifier: CELL_ID);
        
        
        // 下拉刷新
        self.refreshControl = UIRefreshControl();
        self.refreshControl?.addTarget(self, action: #selector(refreshBooks), for: .valueChanged);
        self.refreshControl?.attributedTitle = NSAttributedString(string: "松手刷新");
    }
    
    func refreshBooks() {
        NSLog("refresh...");
        NSLog("refresh ok");
        self.refreshControl?.endRefreshing()
        
        for i in 0...24 {
            let book = Book();
            book.picUrl = "1196s";
            book.author = "康勇敢";
            book.name = "阿萨德的-\(i)";
            book.desc = "伴随着魂导科技的进步，斗罗大陆上的人类征服了海洋，又发现了两片大陆。魂兽也随着人类魂师的猎杀无度走向灭亡，沉睡无数年的魂兽之王在星斗大森林最后的净土苏醒，它要带领仅存的族人";
            book.categories = ("xiuzhen", "修真");
            book.isFinished = true;
            
            bookList.insert(book, at: 0);
        }
        
        self.reloadData();
        
        ToastUtil.show(message: "刷新成功");
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initView(books: [Book]) {
        self.bookList = books;
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) as! BookHotCell;
        cell.initView(bookList: bookList, row: indexPath.row, tableView: self);
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("selected")
    }
    
}
