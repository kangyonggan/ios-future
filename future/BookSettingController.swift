//
//  BookSettingController.swift
//  future
//
//  Created by kangyonggan on 8/20/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookSettingController: UIViewController {
    
    let fontSizeKey = "fontSize";
    
    @IBOutlet weak var slider: UISlider!
    
    let dictionaryDao = DictionaryDao();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: fontSizeKey);
        
        if dict == nil {
            slider.setValue(22, animated: false);
        } else {
            slider.setValue(Float((dict?.value)!)!, animated: false);
        }
        
    }
    
    // 改变字体大小
    @IBAction func changeSize(_ sender: Any) {
        dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: fontSizeKey);
        
        let dict = MyDictionary();
        dict.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
        dict.key = fontSizeKey;
        dict.value = String(slider.value);
        
        dictionaryDao.save(dictionary: dict);
    }
    
}
