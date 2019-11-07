//
//  MessageCollectionView.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/5.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class MessageCollectionView: UICollectionView {

    weak var messageDataSource: MessageDataSource?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        self.register(BaseChatViewCell.self, forCellWithReuseIdentifier: "BaseChatViewCell")
    }
    
}
