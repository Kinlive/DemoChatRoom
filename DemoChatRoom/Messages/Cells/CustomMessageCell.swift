//
//  CustomMessageCell.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class CustomMessageCell: BaseChatViewCell {
    
    var customView: UIView!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attributes = layoutAttributes as? BaseMessageAttributes else { return }
        
        layoutCustomView(attributes: attributes)
    }
    
    
    private func layoutCustomView(attributes: BaseMessageAttributes) {
        containerImageView.addSubview(customView)
        
        
    }
}
