//
//  BaseMessageAttributes.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/4.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class BaseMessageAttributes: UICollectionViewLayoutAttributes {

    public var avatarSize: CGSize = .zero
    public var avatarPosition: AvatarPosition = .init(.leading)
    
    public var cellTopSize: CGSize = .zero
    public var cellTopAlignment = LabelAlignment(textInset: .zero)
    
    public var messageTopSize: CGSize = .zero
    public var messageTopAlignment = LabelAlignment(textInset: .zero)
    
    public var messageSize: CGSize = .zero
    public var messageAlignment = LabelAlignment(textInset: .zero)
    public var messageLabelSize: CGSize = .zero
    
    public var messageBottomSize: CGSize = .zero
    public var messageBottomAlignment = LabelAlignment(textInset: .zero)
    
    public var cellBottomSize: CGSize = .zero
    public var cellBottomAlignment = LabelAlignment(textInset: .zero)
    
    public var containerImageViewSize: CGSize = .zero
    public var containerAlignment = LabelAlignment(textInset: .zero)
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! BaseMessageAttributes
        // copy all custom properties of attributes
        // ...
        copy.avatarSize = avatarSize
        copy.avatarPosition = avatarPosition
        copy.cellTopSize = cellTopSize
        copy.cellTopAlignment = cellTopAlignment
        copy.messageTopSize = messageTopSize
        copy.messageTopAlignment = messageTopAlignment
        copy.messageAlignment = messageAlignment
        copy.messageSize = messageSize
        copy.messageLabelSize = messageLabelSize
        copy.messageBottomSize = messageBottomSize
        copy.messageBottomAlignment = messageBottomAlignment
        copy.cellBottomSize = cellBottomSize
        copy.cellBottomAlignment = cellBottomAlignment
        copy.containerAlignment = containerAlignment
        copy.containerImageViewSize = containerImageViewSize
        
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? BaseMessageAttributes {
            // && compare other customs properties is equal with attributes.
            return super.isEqual(attributes) &&
            attributes.avatarPosition == avatarPosition &&
            attributes.avatarSize == avatarSize &&
            attributes.cellTopAlignment == cellTopAlignment &&
            attributes.cellTopSize == cellTopSize &&
            attributes.messageTopAlignment == messageTopAlignment &&
            attributes.messageTopSize == messageTopSize &&
            attributes.messageAlignment == messageAlignment &&
            attributes.messageLabelSize == messageLabelSize &&
            attributes.messageBottomAlignment == messageBottomAlignment &&
            attributes.messageBottomSize == messageBottomSize &&
            attributes.cellBottomAlignment == cellBottomAlignment &&
            attributes.cellBottomSize == cellBottomSize &&
            attributes.containerImageViewSize == containerImageViewSize &&
            attributes.containerAlignment == containerAlignment
            
        } else {
            return false
        }
    }
}
