//
//  Section.swift
//  future
//
//  Created by kangyonggan on 8/17/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

// 章节
class Section: NSObject {
    
    // 书籍代码
    var bookCode:Int?;
    
    // 章节代码
    var code: Int?;
    
    // 标题
    var title: String?
    
    // 内容
    var content: String?
    
    // 上一章节代码
    var prevSectionCode: Int?
    
    // 下一章节代码
    var nextSectionCode: Int?
}
