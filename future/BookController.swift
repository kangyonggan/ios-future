//
//  ContactsController.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    var bookList = [Book]();
    
    var bookCategories = [(String, String, Int)]();
    
    var frame: CGRect!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        showStore("");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 导航条
        parent?.navigationItem.title = "图书馆";
    }
    
    // 搜索
    @IBAction func showSearch(_ sender: Any) {
        clearView();
        updateBtnStatus(index: 3);
    }
    
    // 推荐
    @IBAction func showHot(_ sender: Any) {
        clearView();
        updateBtnStatus(index: 2);
        
        let view = BookHotView(frame: frame);
        
        view.initView(books: bookList);
        
        containerView.addSubview(view);
    }
    
    // 分类
    @IBAction func showCategory(_ sender: Any) {
        clearView();
        updateBtnStatus(index: 1);
        
        let view = BookCategoryView(frame: frame);
        
        if bookCategories.count == 0 {
            bookCategories.append(("xuanhuan", "玄幻", 28368));
            bookCategories.append(("xiuzhen", "修真", 58621));
            bookCategories.append(("dushi", "都市", 221154));
            bookCategories.append(("lishi", "历史", 28368));
            bookCategories.append(("wnagyou", "网游", 11726));
            bookCategories.append(("kehuan", "科幻", 94626));
            bookCategories.append(("yanqing", "言情", 3684));
            bookCategories.append(("qita", "其他", 3938627));
        }
        
        view.initView(categories: bookCategories);
        
        containerView.addSubview(view);
    }
    
    // 收藏
    @IBAction func showStore(_ sender: Any) {
        clearView();
        updateBtnStatus(index: 0);
        
        let collectionView = BookCollectionView(frame: frame);
        
        // 防止每次都去请求接口
        if bookList.count == 0 {
            for i in 0...24 {
                let book = Book();
                book.picUrl = "1196s";
                book.author = "康永敢";
                book.name = "逆天邪神-\(i)";
                book.desc = "伴随着魂导科技的进步，斗罗大陆上的人类征服了海洋，又发现了两片大陆。魂兽也随着人类魂师的猎杀无度走向灭亡，沉睡无数年的魂兽之王在星斗大森林最后的净土苏醒，它要带领仅存的族人";
                book.categories = ("xuanhuan", "玄幻");
                book.isFinished = false;
                
                bookList.append(book);
            }
        }
        
        collectionView.load(books: bookList);
        containerView.addSubview(collectionView);
    }
    
    // 清空容器所有内容
    func clearView() {
        let views = containerView.subviews;
        for view in views {
            view.removeFromSuperview();
        }
        
    }
    
    // 更新顶部按钮状态
    func updateBtnStatus(index: Int) {
        let views = topView.subviews;
        for i in 0..<views.count {
            let btn = views[i] as? UIButton;
            if index == i {
                btn?.setTitleColor(AppConstants.MASTER_COLOR, for: .normal);
                btn?.isEnabled = false;
            } else {
                btn?.setTitleColor(UIColor.darkText, for: .normal);
                btn?.isEnabled = true;
            }
        }
    }
    
    func initView() {
        frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height - 60);
        
        // 顶部按钮分割线
        for i in 1...3 {
            let line = UIView(frame: CGRect(x: topView.frame.width / 4 * CGFloat(i), y: topView.frame.height * 0.3, width: 1, height: topView.frame.height * 0.4));
            line.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9);
            topView.addSubview(line);
        }
    }
    
}
