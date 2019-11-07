//
//  MessageContainerView.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/6.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class MessageContainerView: UIImageView {

    private var imageMask: UIImageView = UIImageView()
    
    override var frame: CGRect {
        didSet {
            
            sizeMaskToView()
        }
    }
    
    private func sizeMaskToView() {
        imageMask.frame = bounds
    }
    
    func applyMaskStyle(attributes: CustomLayoutAttributes) {
        
        let incoming = UIImage.bubbleOfIncoming(insets: attributes.messageAlignment.textInset)
        let outgoing = UIImage.bubbleOfOutgoing(insets: attributes.messageAlignment.textInset)
        
        switch attributes.avatarPosition.horizontal {
        case .leading:
            imageMask.image = incoming
        case .trailing:
            imageMask.image = outgoing
        }
        sizeMaskToView()

        mask = imageMask
        switch attributes.avatarPosition.horizontal {
        case .leading:
            image = incoming.withRenderingMode(.alwaysTemplate)
        case .trailing:
            image = outgoing.withRenderingMode(.alwaysTemplate)
        }
        tintColor = .systemTeal
    }
}
