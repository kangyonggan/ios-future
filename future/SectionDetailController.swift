//
//  SectionDetailController.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionDetailController: UIViewController, UIWebViewDelegate  {
    
    let sectionUrl = "m/book/section";
    let addFavoriteUrl = "m/book/addFavorite";
    let removeFavoriteUrl = "m/book/removeFavorite";
    
    var section: Section!;
    var isFavorite: Bool!;
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        webView.delegate = self;
        initView()
    }
    
    func initView() {
        updateContent();
        
        // 左滑手势， 下一章
        let swipeNext = UISwipeGestureRecognizer(target: self, action: #selector(swipeNext(_:)));
        swipeNext.direction = .left;
        self.view.addGestureRecognizer(swipeNext);
        
        // 右滑手势， 上一章
        let swipePrev = UISwipeGestureRecognizer(target: self, action: #selector(swipePrev(_:)));
        swipePrev.direction = .right;
        self.view.addGestureRecognizer(swipePrev);
    }
    
    // 左滑，下一章
    func swipeNext(_ recognizer:UISwipeGestureRecognizer) {
        if (section.nextSectionCode == 0) {
            ToastUtil.show(message: "已经是最后一章了", target: view);
            return;
        }
        
        loadSection(code: section.nextSectionCode!)
    }
    
    // 右滑，上一章
    func swipePrev(_ recognizer:UISwipeGestureRecognizer) {
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
        webView.loadHTMLString("<div id='content'>\(section.content!)</div>", baseURL: nil);
        
        // 设置是否是收藏的图标
        if isFavorite {
            favoriteBtn.image = UIImage(named: "favorite");
        } else {
            favoriteBtn.image = UIImage(named: "disFavorite");
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('content').style.fontSize='36px'");
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('content').style.webkitTextSizeAdjust='200%'");
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
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeFavorite"), object: nil, userInfo: nil);
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
    
    
}
