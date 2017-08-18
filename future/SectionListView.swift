//
//  SectionListView.swift
//  future
//
//  Created by kangyonggan on 8/17/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit

class SectionListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    let bookSectionsUrl = "m/book/findBookSections";
    
    let CELL_ID = "sectionCell";
    var sectionList = [Section]();
    var book: Book?;
    
    var p = 2;
    
    var isCanPull = true;
    //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!;
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self;
        self.dataSource = self;
        self.register(SectionCell.self, forCellReuseIdentifier: CELL_ID);
    }
    
    // 上拉刷新
    func refreshSections() {
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + bookSectionsUrl, params: ["code": String(book!.code!), "p": String(p)]);
        
        if result.0 {
            let sections = result.2?["sections"] as! NSArray;
            
            if sections.count == 0 {
                ToastUtil.show(message: "没有更多推荐小说了");
                return;
            }
            
            for s in sections {
                let ss = s as! NSDictionary
                let section = Section();
                section.code = ss["code"] as? Int;
                section.title = ss["title"] as? String;
                section.content = ss["content"] as? String;
                section.prevSectionCode = ss["prevSectionCode"] as? Int;
                section.nextSectionCode = ss["nextSectionCode"] as? Int;
                section.bookCode = ss["bookCode"] as? Int;
                
                sectionList.append(section);
            }
            p += 1;
            
            self.reloadData();
            
            ToastUtil.show(message: "加载成功");
        } else {
            ToastUtil.show(message: result.1);
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func initView(book: Book, sections: [Section]) {
        self.book = book;
        self.sectionList = sections;
        
        // 上拉view
        self.tableFooterView = ViewUtil.loadView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: 50));
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) as! SectionCell;
        cell.initView(section: sectionList[indexPath.row]);
        
        if isCanPull && indexPath.row == sectionList.count - 1 {
            loadMore();
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sectionList[indexPath.row];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showSection"), object: nil, userInfo: ["section": section]);
    }
    
    //加载更多数据
    func loadMore(){
        isCanPull = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SectionListView.timeout), userInfo: nil, repeats: true);
    }
    
    //计时器时间到
    func timeout() {
        refreshSections();
        
        isCanPull = true;
        
        timer.invalidate()
        timer = nil
    }
}

