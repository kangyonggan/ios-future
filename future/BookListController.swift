//
//  BookSearchController.swift
//  future
//
//  Created by kangyonggan on 8/18/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookListController: UITableViewController {
    
    let lastSectionUrl = "m/book/lastSection";
    
    var bookList: [Book]!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
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
        let book = bookList[indexPath.row]
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + lastSectionUrl, params: ["bookCode": String(book.code!), "username": UserUtil.getUsername()]);
        
        if result.0 {
            let sec = result.2!["section"] as! NSDictionary;
            let section = Section();
            section.bookCode = sec["bookCode"] as? Int;
            section.code = sec["code"] as? Int
            section.content = sec["content"] as? String;
            section.title = sec["title"] as? String
            section.prevSectionCode = sec["prevSectionCode"] as? Int
            section.nextSectionCode = sec["nextSectionCode"] as? Int
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "sectionDetailController") as! SectionDetailController;
            vc.section = section;
            vc.isFavorite = result.2!["favorite"] as! Bool;
            self.navigationController?.pushViewController(vc, animated: false);
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
}
