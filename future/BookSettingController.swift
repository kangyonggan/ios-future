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
    let openCacheKey = "openCache";
    let themeKey = "theme";
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var themeLabel: UILabel!
    
    @IBOutlet weak var cacheSwitch: UISwitch!
    
    let dictionaryDao = DictionaryDao();
    
    var themes = [(String, String)]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        themes = AppConstants.themes();
        
        // 初始化字体大小控件
        let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: fontSizeKey);
        
        if dict == nil {
            slider.setValue(22, animated: false);
        } else {
            slider.setValue(Float((dict?.value)!)!, animated: false);
        }
        
        // 初始化开关
        let cacheDict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: openCacheKey);
        if cacheDict == nil {
            cacheSwitch.isOn = true;
        } else {
            if cacheDict?.value == "1" {
                cacheSwitch.isOn = true;
            } else {
                cacheSwitch.isOn = false;
            }
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
        
        let dict = Dictionary();
        dict.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
        dict.key = fontSizeKey;
        dict.value = String(slider.value);
        
        dictionaryDao.save(dictionary: dict);
    }
    
    // 开启缓存
    @IBAction func openCache(_ sender: Any) {
        let isOn = (sender as? UISwitch)?.isOn;
        
        dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: openCacheKey);
        
        let dict = Dictionary();
        dict.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
        dict.key = openCacheKey;
        dict.value = isOn! ? "1" : "0";
        
        dictionaryDao.save(dictionary: dict);
    }
}
