//
//  CategoryCollectionView.swift
//  future
//
//  Created by kangyonggan on 8/18/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class CategoryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categoryUrl = "m/book/category";
    let CELL_ID = "categoryCell";
    var categories: [(String, String, Int)]!;
    
    var viewController: UIViewController!;
    
    var loadingView: UIActivityIndicatorView!;
    
    var category: (String, String, Int)!;
    
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
        
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        
        category = categories[indexPath.row];
        
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(self);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + categoryUrl, data: ["code": category.0, "p": "1"], timeout: 5, asyncCompletionHandler: listCallback)
    }

    // 回调
    func listCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
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
            DispatchQueue.main.async {
                ToastUtil.show(message: result.1, target: self);
            }
            return;
        }
        
        if resBooks.isEmpty {
            DispatchQueue.main.async {
                ToastUtil.show(message: "没有此分类的小说", target: self);
            }
            return;
        }
        
        DispatchQueue.main.async {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bookListController") as! BookListController;
            vc.bookList = resBooks;
            vc.refreshNav(title: self.category.1);
            self.viewController.navigationController?.pushViewController(vc, animated: false);
        }
    }
    
}
