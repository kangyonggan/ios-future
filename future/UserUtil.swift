//
//  UserUtil.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

class UserUtil: NSObject {
    
    static let dictionaryDao = DictionaryDao();
    
    static func getUsername() -> String {
        let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: AppConstants.KEY_USERNAME);
        
        return dict?.value ?? "";
    }
    
}
