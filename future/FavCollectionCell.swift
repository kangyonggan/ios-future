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
    
    func initView(favorite: Favorite) {
        // 封面 异步加载
        ViewUtil.loadImage(string: AppConstants.DOMAIN + favorite.picUrl!, imageView: imageView);
        
        // 书名
        nameLabel.text = favorite.bookName;
    }
}

