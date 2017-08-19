//
//  HotCollectionView.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class HotCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let lastSectionUrl = "m/book/lastSection";
    let CELL_ID = "hotCell";
    var books: [Book]!;
    
    var viewController: UIViewController!;
    
    func loadData(books: [Book]) {
        self.delegate = self;
        self.dataSource = self;
        self.books = books;
        self.reloadData();
    }
    
    // collection view //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! HotCollectionCell;
        
        cell.initView(book: books[indexPath.row]);
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.row];
        
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
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sectionDetailController") as! SectionDetailController;
            vc.section = section;
            vc.isFavorite = result.2!["favorite"] as! Bool;
            viewController.navigationController?.pushViewController(vc, animated: false);
        } else {
            ToastUtil.show(message: result.1);
        }
    }
}
