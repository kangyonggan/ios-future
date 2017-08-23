//
//  ContactsController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

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
            let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + categoryUrl);
            
            if result.0 {
                let categories = result.2?["categories"] as! NSArray;
                for c in categories {
                    let category = c as! NSDictionary
                    categoryList.append((category["code"] as! String, category["name"] as! String, category["bookCnt"] as! Int));
                }
            } else {
                ToastUtil.show(message: result.1, target: view);
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
        categoryCollectionView.loadData(categories: categoryList);
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
        loadFavorite();
        favCollectionView.loadData(books: favList);
    }
    
    // 重新加载站长推荐
    func reloadHot() {
        loadHot();
        hotCollectionView.loadData(books: hotList);
    }
    
    // 加载站长推荐
    func loadHot() {
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + hotUrl, params: ["p": "1", "pageSize": "4"]);
        
        if result.0 {
            
            hotList = [];
            
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
                
                hotList.append(book);
            }
            
            if hotList.count < 4 {
                moreHotBtn.isEnabled = false;
            } else {
                moreHotBtn.isEnabled = true;
            }
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
    // 加载我的收藏
    func loadFavorite() {
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + favUrl, params: ["p": "1", "pageSize": "4", "username": UserUtil.getUsername()]);
        if result.0 {
            
            favList = [];
            
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
                
                favList.append(book);
            }
            
            if favList.count < 4 {
                moreFavBtn.isEnabled = false;
            } else {
                moreFavBtn.isEnabled = true;
            }
            
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
     // 搜索
    @IBAction func search(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true);
        
        let key = searchInput.text!;

        if key.isEmpty {
            ToastUtil.show(message: "请输入搜索内容！", target: view);
            return;
        }
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + searchUrl, params: ["key": key]);
        
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
            ToastUtil.show(message: result.1, target: view);
            return;
        }
        
        if resBooks.isEmpty {
            ToastUtil.show(message: "没有符合条件的小说", target: view);
            return;
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookListController") as! BookListController;
        vc.bookList = resBooks;
        vc.refreshNav(title: "搜索结果");
        parent?.navigationController?.pushViewController(vc, animated: false);
    }
    
    // 更多推荐
    @IBAction func moreHot(_ sender: Any) {
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + hotUrl, params: ["p": "1", "pageSize": "50"]);
        
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
            ToastUtil.show(message: result.1, target: view);
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookListController") as! BookListController;
        vc.bookList = resBooks;
        vc.refreshNav(title: "站长推荐");
        parent?.navigationController?.pushViewController(vc, animated: false);
    }
    
    // 更多收藏
    @IBAction func moreFavorite(_ sender: Any) {
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + favUrl, params: ["p": "1", "pageSize": "50", "username": UserUtil.getUsername()]);
        
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
            parent?.navigationController?.pushViewController(vc, animated: false);
            
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
    
}
