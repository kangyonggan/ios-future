//
//  SectionListController.swift
//  future
//
//  Created by kangyonggan on 8/20/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionListController: UITableViewController {
    
    let sectionUrl = "m/book/section";
    var sectionList: [Section]!;
    var currentSectionCode: Int!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func refreshNav(title: String) {
        self.navigationItem.title = title;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // 跳转到当前章节的cell
        let row = clacSectionRow();
        let indexPath = IndexPath(row: row, section: 0);
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true);
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as! SectionCell;
        
        let section = sectionList[indexPath.row];
        
        cell.initView(name: section.title!, isSelected: currentSectionCode == section.code);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sectionList[indexPath.row]
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + sectionUrl, params: ["sectionCode": String(section.code!), "username": UserUtil.getUsername()]);
        
        if result.0 {
            let sec = result.2!["section"] as! NSDictionary;
            let isFavorite = result.2!["favorite"] as! Bool;
            
            let section = Section();
            section.bookCode = sec["bookCode"] as? Int;
            section.code = sec["code"] as? Int
            section.content = sec["content"] as? String;
            section.title = sec["title"] as? String
            section.prevSectionCode = sec["prevSectionCode"] as? Int
            section.nextSectionCode = sec["nextSectionCode"] as? Int
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSectionDetail"), object: nil, userInfo: ["section": section, "isFavorite": isFavorite]);
            
            self.navigationController?.popViewController(animated: true);
        } else {
            ToastUtil.show(message: result.1, target: view);
        }
    }
    
    // 计算当前章节所在的行
    func clacSectionRow() -> Int {
        var row = 0;
        for section in sectionList {
            if section.code == currentSectionCode {
                return row;
            }
            row += 1;
        }
        
        return -1;
    }
    
}
