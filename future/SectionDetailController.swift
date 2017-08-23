//
//  SectionDetailController.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionDetailController: UIViewController, UIWebViewDelegate  {
    
    let fontSizeKey = "fontSize";
    let themeKey = "theme";
    
    let sectionUrl = "m/book/section";
    let addFavoriteUrl = "m/book/addFavorite";
    let removeFavoriteUrl = "m/book/removeFavorite";
    let sectionsUrl = "m/book/sections";
    
    var section: Section!;
    var isFavorite: Bool!;
    
    var sections = [Section]();
    var bookName: String!;
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    let dictionaryDao = DictionaryDao();
    
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
        if (section.nextSectionCode == 0) {
            ToastUtil.show(message: "已经是最后一章了", target: view);
            return;
        }
        
        loadSection(code: section.nextSectionCode!)
    }
    
    // 上一章
    @IBAction func prevSection(_ sender: Any) {
        if (section.prevSectionCode == 0) {
            ToastUtil.show(message: "已经是第一章了", target: view);
            return;
        }
        
        loadSection(code: section.prevSectionCode!)
    }
    
    // 加载章节
    func loadSection(code: Int) {
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + sectionUrl, params: ["sectionCode": String(code), "username": UserUtil.getUsername()]);
        
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
            updateContent();
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
    func updateContent() {
        self.navigationItem.title = section.title;
        webView.loadHTMLString(section.content!, baseURL: nil);
        
        // 设置是否是收藏的图标
        if isFavorite {
            favoriteBtn.image = UIImage(named: "favorite");
        } else {
            favoriteBtn.image = UIImage(named: "disFavorite");
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        updateSizeAndTheme();
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextFillColor='#555555'");
    }
    
    // 收藏/取消收藏
    @IBAction func favoriteBook(_ sender: Any) {
        var url: String!;
        
        var msg: String!;
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
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + url, params: params);
        
        if result.0 {
            if isFavorite {
                favoriteBtn.image = UIImage(named: "disFavorite");
            } else {
                favoriteBtn.image = UIImage(named: "favorite");
            }
            
            isFavorite = !isFavorite;
            ToastUtil.show(message: msg, target: view);
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
    // 章节列表
    @IBAction func sectionList(_ sender: Any) {
        if sections.isEmpty {
            let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + sectionsUrl, params: ["bookCode": String(section.bookCode!)]);
            
            if result.0 {
                bookName = result.2?["bookName"] as! String;
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
                    
                    sections.append(section);
                }
            } else {
                ToastUtil.show(message: result.1, target: view);
                return;
            }
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "sectionListController") as! SectionListController;
        vc.sectionList = sections;
        vc.currentSectionCode = section.code;
        vc.refreshNav(title: bookName);
        self.navigationController?.pushViewController(vc, animated: false);
    }
    
}
