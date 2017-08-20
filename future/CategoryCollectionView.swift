//
//  CategoryCollectionView.swift
//  future
//
//  Created by kangyonggan on 8/18/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class CategoryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categoryUrl = "m/book/category";
    let CELL_ID = "categoryCell";
    var categories: [(String, String, Int)]!;
    
    var viewController: UIViewController!;
    
    func loadData(categories: [(String, String, Int)]) {
        self.delegate = self;
        self.dataSource = self;
        self.categories = categories;
        self.reloadData();
    }
    
    // collection view //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! CategoryCollectionCell;
        
        cell.initView(category: categories[indexPath.row]);
        
        
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row];
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + categoryUrl, params: ["code": category.0, "p": "1"]);
        
        var resBooks = [Book]();
        if result.0 {
            let books = result.2?["books"] as! NSArray;
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
                
                resBooks.append(book);
            }
        } else {
            ToastUtil.show(message: result.1, target: self);
            return;
        }
        
        if resBooks.isEmpty {
            ToastUtil.show(message: "没有此分类的小说", target: self);
            return;
        }
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bookListController") as! BookListController;
        vc.bookList = resBooks;
        vc.refreshNav(title: category.1);
        viewController.navigationController?.pushViewController(vc, animated: false);
    }

    
}
