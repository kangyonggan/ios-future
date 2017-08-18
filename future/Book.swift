//
//  Book.swift
//  future
//
//  Created by kangyonggan on 8/12/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 书籍
class Book: NSObject {
    
    // 书籍代码
    var code:Int?;
    
    // 名称
    var name:String?;
    
    // 作者
    var author:String?;
    
    // 封面图片地址
    var picUrl:String?;
    
    // 描述
    var descp:String?;
    
    // 分类代码
    var categoryCode:String?;
    
    // 分类名称
    var categoryName:String?;
    
    // 是否完结
    var isFinished:Bool?;
    
    // 是否推荐
    var isHot:Bool?;
    
    // 最新章节
    var newSection:(Int, String)?;
    
    // 正在阅读的章节
    var nowSection:(Int, String)?;
}
