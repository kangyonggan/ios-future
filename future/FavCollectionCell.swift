//
//  FavCollectionCell.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class FavCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func initView(book: Book) {
        ViewUtil.loadImage(string: AppConstants.DOMAIN + book.picUrl!, imageView: imageView);
        
        // 书名
        nameLabel.text = book.name;
    }
}

