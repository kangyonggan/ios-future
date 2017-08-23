//
//  SectionDetailController.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class SectionDetailController: UIViewController, UIWebViewDelegate  {
    
    let openCacheKey = "openCache";
    let fontSizeKey = "fontSize";
    let themeKey = "theme";
    
    let sectionUrl = "m/book/section";
    let sectionCacheUrl = "m/book/sectionCache";
    let sectionFavUrl = "m/book/sectionFav";
    let addFavoriteUrl = "m/book/addFavorite";
    let removeFavoriteUrl = "m/book/removeFavorite";
    let sectionsUrl = "m/book/sections";
    
    var section: Section!;
    var isFavorite: Bool!;
    
    var sections = [Section]();
    var bookName: String!;
    
    var msg: String!;
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    let dictionaryDao = DictionaryDao();
    
    var loadingView: UIActivityIndicatorView!;
    
    let sectionDao = SectionDao();
    
    var isRunTerminalTask = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        webView.delegate = self;
        updateContent();
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSectionDetail(notification:)), name: NSNotification.Name(rawValue: "updateSectionDetail"), object: nil)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
    }
    
    // 更新章节内容, 用于接收章节列表的通知
    func updateSectionDetail(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        self.section = userInfo["section"] as! Section;
        self.isFavorite = userInfo["isFavorite"] as! Bool;
        
        updateContent();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        updateSizeAndTheme();
    }
    
    // 修改主题和字体
    func updateSizeAndTheme() {
        let sizeDict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: fontSizeKey);
        
        var size = 22;
        if sizeDict != nil {
            let fSize = Float((sizeDict?.value)!);
            size = Int(fSize!);
        }
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontSize='\(size)px'");
        
        
        let themeDict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: themeKey);
        
        var theme = "#FFFFFF";
        if themeDict != nil {
            theme = (themeDict?.value)!;
        }
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.background='\(theme)'");
    
    }
    
    // 下一章
    @IBAction func nextSextion(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        if (section.nextSectionCode == 0) {
            ToastUtil.show(message: "已经是最后一章了", target: view);
            return;
        }
        
        // 先走缓存，如果缓存有，直接使用(如果是收藏中的书籍，同时异步更新最后阅读章节)
        // 如果缓存中没有，则调接口，如果开启了缓存，后台缓存后面100章
        let tSection = sectionDao.findSectionBy(code: section.nextSectionCode!);
        if tSection == nil {
            // 没缓存，走接口查询
            loadSection(code: section.nextSectionCode!)
         
            // 判断是否是自动缓存，如果是，则后台缓存后面100章
            let autoCacheDict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: openCacheKey);
            if autoCacheDict == nil || autoCacheDict?.value! == "1" {
                // 后台缓存100章，并标志“正在缓存”，防止重复调用后台缓存
                if !isRunTerminalTask {
                    isRunTerminalTask = true;
                    Just.post(AppConstants.DOMAIN + sectionCacheUrl, data: ["sectionCode": String(section.nextSectionCode!)], asyncCompletionHandler: sectionCacheCallback)
                }
            }
        } else {
            // 有缓存, 直接显示章节内容
            self.section = tSection;
            self.updateContent();
            
            // 如果是收藏中的书籍，同时异步更新最后阅读章节
            if isFavorite {
                Just.post(AppConstants.DOMAIN + sectionFavUrl, data: ["sectionCode": String(section.code!), "username": UserUtil.getUsername()], asyncCompletionHandler: nil)
            }
        }
    }
    
    // 缓存请求完成的回调
    func sectionCacheCallback(res: HTTPResult) {
        isRunTerminalTask = false;
        
        let result = HttpUtil.parse(result: res);
        if result.0 {
            var secs = [Section]();
            let resSections = result.2?["sections"] as! NSArray;
            for s in resSections {
                let ss = s as! NSDictionary
                let section = Section();
                section.bookCode = ss["bookCode"] as? Int;
                section.code = ss["code"] as? Int
                section.content = ss["content"] as? String;
                section.title = ss["title"] as? String
                section.prevSectionCode = ss["prevSectionCode"] as? Int
                section.nextSectionCode = ss["nextSectionCode"] as? Int
                
                secs.append(section);
            }
            
            sectionDao.delete(bookCode: self.section.bookCode!);
            sectionDao.save(sections: secs);
            
            DispatchQueue.main.async {
                ToastUtil.show(message: "后面100章节已经缓存", target: self.view);
            }
        } else {
            DispatchQueue.main.async {
                ToastUtil.show(message: "网络异常，无法自动缓存后面100章节", target: self.view);
            }
        }
    }
    
    // 上一章
    @IBAction func prevSection(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        if (section.prevSectionCode == 0) {
            ToastUtil.show(message: "已经是第一章了", target: view);
            return;
        }
        
        // 先走缓存，如果缓存有，直接使用(如果是收藏中的书籍，同时异步更新最后阅读章节)
        // 如果缓存中没有，则调接口
        let tSection = sectionDao.findSectionBy(code: section.prevSectionCode!);
        if tSection == nil {
            // 没缓存，走接口查询
            loadSection(code: section.prevSectionCode!)
            
        } else {
            // 有缓存, 直接显示章节内容
            self.section = tSection;
            self.updateContent();
            
            // 如果是收藏中的书籍，同时异步更新最后阅读章节
            if isFavorite {
                Just.post(AppConstants.DOMAIN + sectionFavUrl, data: ["sectionCode": String(section.code!), "username": UserUtil.getUsername()], asyncCompletionHandler: nil)
            }
        }
    }
    
    // 加载章节
    func loadSection(code: Int) {
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + sectionUrl, data: ["sectionCode": String(code), "username": UserUtil.getUsername()], timeout: 5, asyncCompletionHandler: sectionCallback)
    }
    
    // 加载章节的回调
    func sectionCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
        DispatchQueue.main.async {
            if result.0 {
                let sec = result.2!["section"] as! NSDictionary;
                self.isFavorite = result.2!["favorite"] as! Bool;
            
                let section = Section();
                section.bookCode = sec["bookCode"] as? Int;
                section.code = sec["code"] as? Int
                section.content = sec["content"] as? String;
                section.title = sec["title"] as? String
                section.prevSectionCode = sec["prevSectionCode"] as? Int
                section.nextSectionCode = sec["nextSectionCode"] as? Int
            
                self.section = section;
                self.updateContent();
            } else {
                ToastUtil.show(message: result.1, target: self.view);
            }
        }
    }
    
    func updateContent() {
        self.navigationItem.title = self.section.title;
        webView.loadHTMLString(self.section.content!, baseURL: nil);
        
        // 设置是否是收藏的图标
        if self.isFavorite {
            self.favoriteBtn.image = UIImage(named: "favorite");
        } else {
            self.favoriteBtn.image = UIImage(named: "disFavorite");
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        updateSizeAndTheme();
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextFillColor='#555555'");
    }
    
    // 设置主题字体
    @IBAction func setting(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookSettingController");
        self.navigationController?.pushViewController(vc!, animated: false);
    }
    
    // 收藏/取消收藏
    @IBAction func favoriteBook(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        var url: String!;
        var params: [String: String]!;
        if isFavorite {
            url = removeFavoriteUrl;
            msg = "已经取消收藏";
            
            params = ["bookCode": String(section.bookCode!), "username": UserUtil.getUsername()];
        } else {
            url = addFavoriteUrl;
            msg = "收藏成功";
            
            params = ["bookCode": String(section.bookCode!), "username": UserUtil.getUsername(), "lastSectionCode": String(section.code!)];
        }
    
        // 启动加载中菊花
        loadingView = ViewUtil.startLoading(view);
        
        // 使用异步请求
        Just.post(AppConstants.DOMAIN + url, data: params, timeout: 5, asyncCompletionHandler: favCallback)
    }
    
    // 收藏的回调
    func favCallback(res: HTTPResult) {
        
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
        DispatchQueue.main.async {
            if result.0 {
                if self.isFavorite {
                    self.favoriteBtn.image = UIImage(named: "disFavorite");
                } else {
                    self.favoriteBtn.image = UIImage(named: "favorite");
                }
                
                self.isFavorite = !self.isFavorite;
                ToastUtil.show(message: self.msg, target: self.view);
            } else {
                ToastUtil.show(message: result.1, target: self.view);
            }
        }
    }
    
    // 章节列表
    @IBAction func sectionList(_ sender: Any) {
        if loadingView != nil && loadingView.isAnimating {
            return;
        }
        if sections.isEmpty {
            // 启动加载中菊花
            loadingView = ViewUtil.startLoading(view);
            
            // 使用异步请求
            Just.post(AppConstants.DOMAIN + sectionsUrl, data: ["bookCode": String(section.bookCode!)], timeout: 5, asyncCompletionHandler: sectionsCallback)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "sectionListController") as! SectionListController;
            vc.sectionList = self.sections;
            vc.isFavorite = self.isFavorite;
            vc.currentSectionCode = self.section.code;
            vc.refreshNav(title: self.bookName);
            self.navigationController?.pushViewController(vc, animated: false);
        }
    }
    
    // 加载章节列表的回调
    func sectionsCallback(res: HTTPResult) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
        
        let result = HttpUtil.parse(result: res);
        
        DispatchQueue.main.async {
            if result.0 {
                self.bookName = result.2?["bookName"] as! String;
                let resSections = result.2?["sections"] as! NSArray;
                for s in resSections {
                    let ss = s as! NSDictionary
                    let section = Section();
                    section.bookCode = ss["bookCode"] as? Int;
                    section.code = ss["code"] as? Int
                    section.content = ss["content"] as? String;
                    section.title = ss["title"] as? String
                    section.prevSectionCode = ss["prevSectionCode"] as? Int
                    section.nextSectionCode = ss["nextSectionCode"] as? Int
                    
                    self.sections.append(section);
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "sectionListController") as! SectionListController;
                vc.sectionList = self.sections;
                vc.isFavorite = self.isFavorite;
                vc.currentSectionCode = self.section.code;
                vc.refreshNav(title: self.bookName);
                self.navigationController?.pushViewController(vc, animated: false);
            } else {
                ToastUtil.show(message: result.1, target: self.view);
            }
        }
    }
    
}
