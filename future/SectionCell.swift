//
//  SectionCell.swift
//  future
//
//  Created by kangyonggan on 8/20/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {
    
    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var sectionNameLabel: UILabel!
    
    func initView(name: String, isSelected: Bool) {
        sectionNameLabel.text = name;
        
        if !isSelected {
            leftImage.isHidden = true;
        } else {
            leftImage.isHidden = false;
        }
    }
    
}
