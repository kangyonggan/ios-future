//
//  ContactsController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just;

class BookController: UIViewController {
    // 查询所有分类的url
    let categoryUrl = "m/book/findAllCategory";
    
    // 查询站长推荐的url
    let hotUrl = "m/book/findHotBook";
    
    // 查询我的收藏的url
    let favUrl = "m/book/findFavorites";
    
    // 搜索小说的url
    let searchUrl = "m/book/searchBooks";
    
    @IBOutlet weak var searchInput: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var categoryCollectionView: CategoryCollectionView!
    
    @IBOutlet weak var hotCollectionView: HotCollectionView!
    
    @IBOutlet weak var favCollectionView: FavCollectionView!
    
    @IBOutlet weak var moreHotBtn: UIButton!
    
    @IBOutlet weak var moreFavBtn: UIButton!
    
    var loadingView: UIActivityIndicatorView!;
    
    // 九大分类数据
    var categoryList = [(String, String, Int)]();
    
    // 站长推荐
    var hotList = [Book]();
    
    // 我的收藏
    var favList = [Book]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initData();
        
        initView();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 导航条
        parent?.navigationItem.title = "小说城";
        
        reloadFavorite();
        
        reloadHot();
    }
    
    // 初始化数据
    func initData() {
        // 加载九大分类
        if categoryList.isEmpty {
            // 使用异步请求
            Just.post(AppConstants.DOMAIN + categoryUrl, timeout: 5, asyncCompletionHandler: categoryCallback)
            
        }
    }
    
    // 加载分类的回调
    func categoryCallback(res: HTTPResult) {
        let result = HttpUtil.parse(result: res);
        
        if result.0 {
            let categories = result.2?["categories"] as! NSArray;
            DispatchQueue.main.async {
                for c in categories {
                    let category = c as! NSDictionary
                    self.categoryList.append((category["code"] as! String, category["name"] as! String, category["bookCnt"] as! Int));
                }
                
                // 渲染
                self.categoryCollectionView.loadData(categories: self.categoryList);
            }
        }
    }
    
    func initView() {
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 搜索框
        searchInput.layer.borderWidth = 1;
        searchInput.layer.cornerRadius = 3;
        searchInput.layer.borderColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1).cgColor;
        ViewUtil.addLeftIcon(textField: searchInput, icon: "search", withSize: 25);
        
        // 搜索按钮
        searchBtn.layer.cornerRadius = 5;
        
        // 九大分类
        categoryCollectionView.viewController = self;
        
        // 站长推荐
        hotCollectionView.loadData(books: hotList);
        hotCollectionView.viewController = self;
        
        // 我的收藏
        favCollectionView.loadData(books: favList);
        favCollectionView.viewController = self;
    }
    
    // 重新加载我的收藏
    func reloadFavorite() {
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + favUrl, data: ["p": "1", "pageSize": "4", "username": UserUtil.getUsername()], timeout: 5, asyncCompletionHandler: favCallback)
    }
    
    // 获取我的收藏的回调
    func favCallback(res: HTTPResult) {
        let result = HttpUtil.parse(result: res);
        
        DispatchQueue.main.async {
            if result.0 {
                self.favList = [];
                
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
                    book.lastSectionCode = bk["lastSectionCode"] as? Int;
                    
                    self.favList.append(book);
                }
                
                if self.favList.count < 4 {
                    self.moreFavBtn.isEnabled = false;
                } else {
                    self.moreFavBtn.isEnabled = true;
                }
                
                self.favCollectionView.loadData(books: self.favList);
            }
        }
    }
    
    // 重新加载站长推荐
    func reloadHot() {
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + hotUrl, data: ["p": "1", "pageSize": "4"], timeout: 5, asyncCompletionHandler: hotCallback)
    }
    
    // 获取推荐列表的回调
    func hotCallback(res: HTTPResult) {
        let result = HttpUtil.parse(result: res);
        
        DispatchQueue.main.async {
            if result.0 {
                self.hotList = [];
                
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
                    
                    self.hotList.append(book);
                }
                
                if self.hotList.count < 4 {
                    self.moreHotBtn.isEnabled = false;
                } else {
                    self.moreHotBtn.isEnabled = true;
                }
                
                self.hotCollectionView.loadData(books: self.hotList);
            }
        }
    }
    
     // 搜索
    @IBAction func search(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        
        UIApplication.shared.keyWindow?.endEditing(true);
        
        let key = searchInput.text!;

        if key.isEmpty {
            ToastUtil.show(message: "请输入搜索内容！", target: view);
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + searchUrl, data: ["key": key], timeout: 5, asyncCompletionHandler: searchCallback)
    }
    
    // 搜索回调
    func searchCallback(res: HTTPResult) {
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
                ToastUtil.show(message: result.1, target: self.view);
            }
            return;
        }
        
        if resBooks.isEmpty {
            DispatchQueue.main.async {
                ToastUtil.show(message: "没有符合条件的小说", target: self.view);
            }
            return;
        }
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookListController") as! BookListController;
            vc.bookList = resBooks;
            vc.refreshNav(title: "搜索结果");
            self.parent?.navigationController?.pushViewController(vc, animated: false);
        }
    }
    
    // 更多推荐
    @IBAction func moreHot(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + hotUrl, data: ["p": "1", "pageSize": "50"], timeout: 5, asyncCompletionHandler: moreHotCallback)
    }
    
    // 查看更多推荐的回调
    func moreHotCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
            
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
                ToastUtil.show(message: result.1, target: self.view);
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookListController") as! BookListController;
            vc.bookList = resBooks;
            vc.refreshNav(title: "站长推荐");
            self.parent?.navigationController?.pushViewController(vc, animated: false);
        }
    }
    
    // 更多收藏
    @IBAction func moreFavorite(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + favUrl, data: ["p": "1", "pageSize": "50", "username": UserUtil.getUsername()], timeout: 5, asyncCompletionHandler: moreFavCallback)
    }
    
    // 更多收藏的回调
    func moreFavCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
            
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
                    book.lastSectionCode = bk["lastSectionCode"] as? Int;
                    
                    resBooks.append(book);
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookListController") as! BookListController;
                vc.bookList = resBooks;
                vc.refreshNav(title: "我的收藏");
                self.parent?.navigationController?.pushViewController(vc, animated: false);
                
            } else {
                ToastUtil.show(message: result.1, target: self.view);
            }
        }
    }
    
}
