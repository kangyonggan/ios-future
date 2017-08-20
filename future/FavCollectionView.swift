//
//  FavCollectionView.swift
//  future
//
//  Created by kangyonggan on 8/19/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class FavCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let sectionUrl = "m/book/section";
    
    var viewController: UIViewController!;
    
    let CELL_ID = "favCell";
    var favorites: [Favorite]!;
    var label: UILabel?;
    
    func loadData(favorites: [Favorite]) {
        self.delegate = self;
        self.dataSource = self;
        self.favorites = favorites;
        if favorites.isEmpty {
            label = UILabel(frame: CGRect(x: frame.width / 2 - 80, y: frame.height / 2 - 10, width: 160, height: 40));
            label?.text = "没有收藏的小说";
            label?.textAlignment = .center;
            label?.textColor = AppConstants.MASTER_COLOR;
            label?.font = UIFont.systemFont(ofSize: 12);
        
            for subView in subviews {
                subView.removeFromSuperview();
            }
            
            addSubview(label!);
        } else {
            label?.removeFromSuperview();
            self.reloadData();
        }
    }
    
    // collection view //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! FavCollectionCell;
        
        cell.initView(favorite: favorites[indexPath.row]);
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row];
        
        let result = HttpUtil.sendPost(url: AppConstants.DOMAIN + sectionUrl, params: ["sectionCode": String(favorite.lastSectionCode!), "username": UserUtil.getUsername()]);
        
        if result.0 {
            let sec = result.2!["section"] as! NSDictionary;
            
            let section = Section();
            section.bookCode = sec["bookCode"] as? Int;
            section.code = sec["code"] as? Int
            section.content = sec["content"] as? String;
            section.title = sec["title"] as? String
            section.prevSectionCode = sec["prevSectionCode"] as? Int
            section.nextSectionCode = sec["nextSectionCode"] as? Int
            
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sectionDetailController") as! SectionDetailController;
            vc.section = section;
            vc.isFavorite = result.2!["favorite"] as! Bool;
            
            viewController.navigationController?.pushViewController(vc, animated: false);
        } else {
            ToastUtil.show(message: result.1, target: self);
        }
    }
}
