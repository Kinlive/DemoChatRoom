//
//  BaseMessageCalculator.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/4.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

struct AvatarPosition: Equatable {
    enum Horizontal {
        case leading
        case trailing
    }
    enum Vertical {
        case cellTop
        case messageTop
        case messageCenter
        case messageBottom
        case cellBottom
    }
    
    var horizontal: Horizontal
    var vertical: Vertical
    
    init(_ horizontal: Horizontal, vertical: Vertical = .messageCenter) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
}

extension AvatarPosition {
    static func ==(lhs: AvatarPosition, rhs: AvatarPosition) -> Bool {
        return lhs.horizontal == rhs.horizontal &&
            lhs.vertical == rhs.vertical
        
    }
}

struct LabelAlignment: Equatable {
    var textAlignment: NSTextAlignment
    var textInset: UIEdgeInsets
    
    init(textAlignment: NSTextAlignment = .center, textInset: UIEdgeInsets) {
        self.textAlignment = textAlignment
        self.textInset = textInset
    }
}

extension LabelAlignment {
    static func ==(lhs: LabelAlignment, rhs: LabelAlignment) -> Bool {
        return lhs.textAlignment == rhs.textAlignment &&
            lhs.textInset == rhs.textInset
    }
}

extension UIEdgeInsets {
    init(top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        self.init()
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
}

// MARK: - BaseMessage calculator
class BaseMessageCalculator {
    
    var incomingAvatarSize: CGSize = CGSize(width: 30, height: 30)
    var outgoingAvatarSize: CGSize = CGSize(width: 30, height: 30)
    
    var incomingAvatarPosition: AvatarPosition = AvatarPosition(.leading, vertical: .messageCenter)
    var outgoingAvatarPosition: AvatarPosition = AvatarPosition(.trailing, vertical: .messageCenter)
    
    var incomingCellTopAlignment = LabelAlignment(textAlignment: .center, textInset: .init(left: 42))
    var outgoingCellTopAlignment = LabelAlignment(textAlignment: .center, textInset: .init(right: 42))
    
    var incomingMessageTopAlignment = LabelAlignment(textAlignment: .left, textInset: .init(left: 42))
    var outgoingMessageTopAlignment = LabelAlignment(textAlignment: .right, textInset: .init(right: 42))
    
    var incomingMessagePadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 13, bottom: 5, right: 30)
    var outgoingMessagePadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 13)
    
    var incomingMessageBottomAlignment = LabelAlignment(textAlignment: .left, textInset: .init(left: 42))
    var outgoingMessageBottomAlignment = LabelAlignment(textAlignment: .right, textInset: .init(right: 42))
    
    var incomingCellBottomAlignment = LabelAlignment(textAlignment: .left, textInset: .init(left: 42))
    var outgotingCellBottomAlignment = LabelAlignment(textAlignment: .right, textInset: .init(right: 42))
    
    private var layout: CustomCollectionViewLayout
    
    init(layout: CustomCollectionViewLayout) {
        self.layout = layout
    }
    
    
    func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? CustomLayoutAttributes else { return }
        guard let messageCollectionView = layout.collectionView as? MessageCollectionView,
            let dataSource = messageCollectionView.messageDataSource else { return }
        
        let indexPath = attributes.indexPath
        let message = dataSource.message(at: indexPath, in: messageCollectionView)
        let isFromUser = dataSource.isFromUser(message: message)
        
        attributes.avatarPosition = isFromUser ? outgoingAvatarPosition : incomingAvatarPosition
        attributes.avatarSize = isFromUser ? outgoingAvatarSize : incomingAvatarSize
        
        attributes.cellTopAlignment = isFromUser ? outgoingCellTopAlignment : incomingCellTopAlignment
        attributes.messageTopAlignment = isFromUser ? outgoingMessageTopAlignment : incomingMessageTopAlignment
        attributes.messageAlignment = isFromUser ? LabelAlignment(textAlignment: .left, textInset: outgoingMessagePadding) : LabelAlignment(textAlignment: .left, textInset: incomingMessagePadding)
        attributes.messageBottomAlignment = isFromUser ? outgoingMessageBottomAlignment : incomingMessageBottomAlignment
        attributes.cellBottomAlignment = isFromUser ? outgotingCellBottomAlignment : incomingCellBottomAlignment
        
        if let messageLayoutDelegate = layout.messageLayoutDelegate {
            attributes.cellTopSize = messageLayoutDelegate.cellTopSize(at: indexPath, of: message)
            attributes.messageTopSize = messageLayoutDelegate.messageTopSize(at: indexPath, of: message)
            attributes.messageSize = messageLayoutDelegate.messageLabelSize(at: indexPath, of: message)
            
            attributes.messageBottomSize = messageLayoutDelegate.messageBottomSize(at: indexPath, of: message)
            attributes.cellBottomSize = messageLayoutDelegate.cellBottomSize(at: indexPath, of: message)
        }
        
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let messageLayoutDelegate = layout.messageLayoutDelegate else { return .zero }
        let message = layout.messageDataSource.message(at: indexPath, in: layout.messageCollectionView)
        
        let cellTopSize = messageLayoutDelegate.cellTopSize(at: indexPath, of: message)
        let messageTopSize = messageLayoutDelegate.messageTopSize(at: indexPath, of: message)
        let messageSize = messageLayoutDelegate.messageLabelSize(at: indexPath, of: message)
        let messageBottomSize = messageLayoutDelegate.messageBottomSize(at: indexPath, of: message)
        let cellBottomSize = messageLayoutDelegate.cellBottomSize(at: indexPath, of: message)
        
        let itemWidth = layout.messageCollectionView.frame.width - layout.messageCollectionView.contentInset.left - layout.messageCollectionView.contentInset.right
        let itemHeight = layout.messageCollectionView.contentInset.top + cellTopSize.height + messageTopSize.height + messageSize.height + messageBottomSize.height + cellBottomSize.height + layout.messageCollectionView.contentInset.bottom
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
