//
//  sectionController.swift
//  future
//
//  Created by kangyonggan on 8/17/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just;

class SectionController: UIViewController, UIWebViewDelegate {
    
    let sectionUrl = "m/book/findBookSection";
    
    var section: Section!;
    
    @IBOutlet weak var webView: UIWebView!
    
    var isCanPull = true;
    var loadingView: UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        webView.delegate = self;
        
        initView();
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('content').style.fontSize='28px'");
    }
    
    func initView() {
        // 导航条
        self.navigationItem.title = section.title;
        
//        loadingView = ViewUtil.loadView(frame: CGRect(x: webView.frame.width / 2 - 25, y: webView.frame.height / 2 - 25, width: 50, height: 50));
//        webView.addSubview(loadingView);

        loadSection();
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SectionController.stopLoad(notification:)), name: NSNotification.Name(rawValue: "stopLoad"), object: nil)
        
    }
    
    
    func loadSection() {
        if !isCanPull {
            return;
        }
        
        isCanPull = false
//        Just.post(AppConstants.DOMAIN + sectionUrl, data: ["code": String(section.code!)]) { res in
//            self.isCanPull = true;
//            if res.ok {
//                NSLog("ok");
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLoad"), object: nil, userInfo: nil);
//                self.webView.loadHTMLString("<div id='content'>爱上大声地</div>", baseURL: nil);
//            } else {
//                NSLog("not ok");
//            }
//        }
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + sectionUrl, params: ["code": String(section.code!)]);
        
        if result.0 {
            let s = result.2?["section"] as! NSDictionary;
            let content = s["content"] as! String;
            webView.loadHTMLString("<div id='content'>\(content)</div>", baseURL: nil);
        } else {
            ToastUtil.show(message: result.1);
        }
        
//        timer.invalidate()
//        timer = nil
    }
    
    func stopLoad(notification: Notification) {
        loadingView.removeFromSuperview();
    }
}
