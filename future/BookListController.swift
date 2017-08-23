//
//  BookSearchController.swift
//  future
//
//  Created by kangyonggan on 8/18/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class BookListController: UITableViewController {
    
    let lastSectionUrl = "m/book/lastSection";
    
    var bookList: [Book]!;
    
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
    }
    
    func refreshNav(title: String) {
        self.navigationItem.title = title;
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookCell;
        
        let book = bookList[indexPath.row]
        
        cell.initView(book: book);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        
        let book = bookList[indexPath.row]
        
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + lastSectionUrl, data: ["bookCode": String(book.code!), "username": UserUtil.getUsername()], timeout: 5, asyncCompletionHandler: lastSectionCallback)
        
    }
    
    // 回调
    func lastSectionCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
        if result.0 {
            let sec = result.2!["section"] as! NSDictionary;
            let section = Section();
            section.bookCode = sec["bookCode"] as? Int;
            section.code = sec["code"] as? Int
            section.content = sec["content"] as? String;
            section.title = sec["title"] as? String
            section.prevSectionCode = sec["prevSectionCode"] as? Int
            section.nextSectionCode = sec["nextSectionCode"] as? Int
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "sectionDetailController") as! SectionDetailController;
                vc.section = section;
                vc.isFavorite = result.2!["favorite"] as! Bool;
                self.navigationController?.pushViewController(vc, animated: false);
            }
        } else {
            DispatchQueue.main.async {
                ToastUtil.show(message: result.1, target: (self.parent?.view)!);
            }
        }
    }
    
}
