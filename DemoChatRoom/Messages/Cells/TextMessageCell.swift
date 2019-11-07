//
//  TextMessageCell.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class TextMessageCell: BaseChatViewCell {
    
    var messageLabel: UILabel = {
       let label = UILabel()
        //label.backgroundColor = .systemTeal
        label.numberOfLines = 0
        return label
    }()
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? BaseMessageAttributes else { return }
        
        layoutMessageLabel(attributes: attributes)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
    
    override func configure(message: MessageType) {
        super.configure(message: message)
        guard case .text(let text) = message.kind else { return }
        messageLabel.text = text
        
    }
    
    override func addSubviews() {
        super.addSubviews()
        containerImageView.addSubview(messageLabel)
        
    }
    
    private func layoutMessageLabel(attributes: BaseMessageAttributes) {
        
        messageLabel.textAlignment = attributes.messageAlignment.textAlignment
        
        let labelOrigin = CGPoint(x: attributes.messageAlignment.textInset.left,
                                  y: attributes.messageAlignment.textInset.top)
        messageLabel.frame = CGRect(origin: labelOrigin, size: attributes.messageLabelSize)
    }
}
