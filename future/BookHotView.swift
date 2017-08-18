//
//  BookHotView.swift
//  future
//
//  Created by kangyonggan on 8/13/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookHotView: UITableView, UITableViewDelegate, UITableViewDataSource {
    let bookHotUrl = "m/book/findHotBook";
    
    let CELL_ID = "hotCell";
    var bookList = [Book]();
    
    var p = 2;
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 95;
        self.register(BookHotCell.self, forCellReuseIdentifier: CELL_ID);
        
        // 下拉刷新
        self.refreshControl = UIRefreshControl();
        self.refreshControl?.addTarget(self, action: #selector(refreshBooks), for: .valueChanged);
        self.refreshControl?.attributedTitle = NSAttributedString(string: "松开刷新");
    }
    
    func refreshBooks() {
        self.refreshControl?.endRefreshing()
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + bookHotUrl, params: ["p": String(p)]);
        
        if result.0 {
            let books = result.2?["books"] as! NSArray;
            
            if books.count == 0 {
                ToastUtil.show(message: "没有更多推荐小说了");
                return;
            }
            
            for b in books {
                let bk = b as! NSDictionary
                let book = Book();
                book.code = bk["code"] as? Int;
                book.name = bk["name"] as? String;
                book.author = bk["author"] as? String;
                book.categoryCode = bk["categoryCode"] as? String;
                book.categoryName = bk["categoryName"] as? String;
                book.picUrl = bk["picUrl"] as? String;
                book.descp = bk["descp"] as? String;
                book.isFinished = bk["isFinished"] as? Bool;
                book.descp = bk["descp"] as? String;
                
                bookList.insert(book, at: 0);
            }
            p += 1;
            
            self.reloadData();
            
            ToastUtil.show(message: "刷新成功");
        } else {
            ToastUtil.show(message: result.1);
        }
        
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
        let book = bookList[indexPath.row];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showBook"), object: nil, userInfo: ["book": book]);
    }
    
}
