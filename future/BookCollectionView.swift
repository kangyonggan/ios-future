//
//  BookCollectionView.swift
//  future
//
//  Created by kangyonggan on 8/12/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class BookCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let CELL_ID = "bookCell";
    var bookList = [Book]();
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout();
        super.init(frame: frame, collectionViewLayout: myLayout);
        
        initView(layout: myLayout);
    }
    
    func initView(layout: UICollectionViewFlowLayout) {
        
        
        layout.minimumLineSpacing = 25;
        layout.itemSize = CGSize(width: 80, height: 100);
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10);
        
        self.backgroundColor = UIColor.white;
        self.delegate = self;
        self.dataSource = self;
        self.register(BookCollectionCell.self, forCellWithReuseIdentifier: CELL_ID)
    }
    
    func load(books: [Book]) {
        self.bookList = books;
        self.reloadData();
    }
    
    // collection view //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! BookCollectionCell;
        
        cell.book = bookList[indexPath.row];
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 100));
        imageView.image = UIImage(named: cell.book!.picUrl!);
        
        cell.backgroundView = imageView;
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionCell;
        NSLog("选择书籍：\(cell.book!.name!)");
    }
}
