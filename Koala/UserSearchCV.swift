//
//  SearchUsersCV.swift
//  Koala
//
//  Created by Erik Batista on 8/28/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import Foundation
import UIKit

class SearchUsersCV: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var collectionView: UICollectionView!
    
    let profileImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.backgroundColor = .magenta
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 111, height: 111)
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UserSearchCVCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        self.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width)
        return CGSize(width: width, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
