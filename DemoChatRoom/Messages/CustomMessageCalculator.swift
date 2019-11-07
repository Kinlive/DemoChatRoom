//
//  CustomMessageCalculator.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class CustomMessageCalculator: BaseMessageCalculator {
    
    
    override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        
        guard let attributes = attributes as? BaseMessageAttributes,
            let messageCollectionView = layout.collectionView as? MessageCollectionView,
            let dataSource = messageCollectionView.messageDataSource else { return }
        
        let indexPath = attributes.indexPath
        let message = dataSource.message(at: indexPath, in: messageCollectionView)
        
        attributes.messageSize = messageContainerSize(at: indexPath, of: message)
        
    }
    
    override func messageContainerSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return customMessageSize(at: indexPath, of: message) + CGSize(width: bubbleImageIncomingPadding.horizontal, height: bubbleImageIncomingPadding.vertical)
    }
    
    
    private func customMessageSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        
        return .zero
    }
    
}
