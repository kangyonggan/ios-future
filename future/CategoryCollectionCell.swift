//
//  CategoryCollectionCell.swift
//  future
//
//  Created by kangyonggan on 8/18/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bookCntLabel: UILabel!
    
    func initView(category: (String, String, Int)) {
        nameLabel.text = category.1
        bookCntLabel.text =  "\(category.2) 本";
    }
    
}
