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
    let themeKey = "theme";
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var themeLabel: UILabel!
    
    let dictionaryDao = DictionaryDao();
    
    var themes = [(String, String)]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        themes = AppConstants.themes();
        
        let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: fontSizeKey);
        
        if dict == nil {
            slider.setValue(22, animated: false);
        } else {
            slider.setValue(Float((dict?.value)!)!, animated: false);
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        updateThemeLabel();
    }
    
    func updateThemeLabel() {
        let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: themeKey);
        
        if dict != nil {
            for theme in themes {
                if theme.1 == dict?.value {
                    themeLabel.text = theme.0;
                    break;
                }
            }
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
