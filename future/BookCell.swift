//
//  BookSearchCell.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var coverImage: UIImageView!
    
    func initView(book: Book) {
        ViewUtil.loadImage(string: AppConstants.DOMAIN + book.picUrl!, imageView: coverImage)
        
        nameLabel.text = book.name;
        authorLabel.text = book.author;
        descLabel.text = book.descp;
        if book.isFinished! {
            statusLabel.text = "完结";
        } else {
            statusLabel.text = "连载";
        }
        
        statusLabel.layer.borderColor = AppConstants.MASTER_COLOR.cgColor;
        statusLabel.layer.borderWidth = 1;
        statusLabel.layer.cornerRadius = 3;
    }
    
    
}
