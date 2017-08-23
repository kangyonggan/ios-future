//
//  BookThemeListController.swift
//  future
//
//  Created by kangyonggan on 8/20/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookThemeListController: UITableViewController{
    
    let CELL_ID = "themeCell";
    let themeKey = "theme";
    var themes = [(String, String)]();
    
    let dictionaryDao = DictionaryDao();
    
    var selectedValue: String!;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        let dict = dictionaryDao.findDictionaryBy(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: themeKey);
        if dict == nil {
            selectedValue = "#FFFFFF";
        } else {
            selectedValue = dict?.value;
        }
        
        themes = AppConstants.themes();
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! BookThemeCell;
        
        let theme = themes[indexPath.row];
        
        cell.initView(name: theme.0, isSelected: selectedValue == theme.1);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = themes[indexPath.row];
        
        let dict = Dictionary();
        dict.type = AppConstants.DICTIONERY_TYPE_DEFAULT;
        dict.key = themeKey;
        dict.value = theme.1;
        
        dictionaryDao.delete(type: AppConstants.DICTIONERY_TYPE_DEFAULT, key: themeKey);
        
        dictionaryDao.save(dictionary: dict);
        
        self.navigationController?.popViewController(animated: true);
        
    }
}
