//
//  SectionCell.swift
//  future
//
//  Created by kangyonggan on 8/17/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {
    
    func initView(section: Section) {
        textLabel?.text = section.title;
        textLabel?.textAlignment = .left;
    }
    
}
