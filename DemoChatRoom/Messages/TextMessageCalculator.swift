//
//  TextMessageCalculator.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/4.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class TextMessageCalculator: BaseMessageCalculator {
    
    public var incomingMessageInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 30)
    public var outgoingMessageInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 5)
    
    override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        
    }
}
