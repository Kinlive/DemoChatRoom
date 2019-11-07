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
        
        guard let attributes = attributes as? BaseMessageAttributes,
            let messageCollectionView = layout.collectionView as? MessageCollectionView,
            let dataSource = messageCollectionView.messageDataSource else { return }
        let indexPath = attributes.indexPath
        let message = dataSource.message(at: indexPath, in: messageCollectionView)
        //let isFromUser = dataSource.isFromUser(message: message)
        
        attributes.messageLabelSize = messageLabelSize(of: message)
        attributes.messageSize = messageContainerSize(at: indexPath, of: message)
    }
    
    override func messageContainerSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        
        var size: CGSize = .zero
        let labelSize = messageLabelSize(of: message)
                   
        size = CGSize(width: labelSize.width + bubbleImageIncomingPadding.horizontal,
                      height: labelSize.height + bubbleImageIncomingPadding.vertical)
        
        return size
    }
    
    private func messageLabelSize(of message: MessageType) -> CGSize {
        guard case .text(let text) = message.kind else { return .zero }
        let collectionView = layout.messageCollectionView
        let limitWidth = collectionView.frame.width * 0.6
        
        var textWidth: CGFloat = 0
        let aWidth = text.textWidth()
        let oneLineHeight: CGFloat = 25
        
        textWidth = min(limitWidth, aWidth)
        
        let textHeight = max(text.height(withConstrainedWidth: textWidth, font: UIFont.systemFont(ofSize: 17)) + 5, oneLineHeight)
        
        return CGSize(width: textWidth, height: textHeight)
    }
    
}
