//
//  Favorite.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 收藏
class Favorite: NSObject {
    
    // 用户名（手机号）
    var username:String?;
    
    // 小说代码
    var bookCode:Int?;
    
    // 书名
    var bookName:String?;
    
    // 封面图片地址
    var picUrl:String?;
    
    // 最后阅读的章节代码
    var lastSectionCode:Int?;
    
    // 最后阅读的章节标题
    var lastSectionTitle:String?;
    
}
