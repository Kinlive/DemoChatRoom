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
    
    //var incomingMessagePadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 10)
    //var outgoingMessagePadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 30)
    
    let bubbleImageIncomingPadding: UIEdgeInsets = UIEdgeInsets(top: 15, left: 24, bottom: 15, right: 17)
    let bubbleImageOutgoingPadding: UIEdgeInsets = UIEdgeInsets(top: 15, left: 17, bottom: 15, right: 24)
    
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
        attributes.messageAlignment = isFromUser ? LabelAlignment(textAlignment: .left, textInset: bubbleImageOutgoingPadding) : LabelAlignment(textAlignment: .left, textInset: bubbleImageIncomingPadding)
        attributes.messageBottomAlignment = isFromUser ? outgoingMessageBottomAlignment : incomingMessageBottomAlignment
        attributes.cellBottomAlignment = isFromUser ? outgotingCellBottomAlignment : incomingCellBottomAlignment
        
        // calculate size
        attributes.cellTopSize = cellTopSize(at: indexPath, of: message)
        attributes.messageTopSize = messageTopSize(at: indexPath, of: message)
        attributes.messageLabelSize = messageLabelSize(of: message)
        attributes.messageSize = messageContainerSize(at: indexPath, of: message)
        
        attributes.messageBottomSize = messageBottomSize(at: indexPath, of: message)
        attributes.cellBottomSize = cellBottomSize(at: indexPath, of: message)
        
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        
        let message = layout.messageDataSource.message(at: indexPath, in: layout.messageCollectionView)
        
        let cellTopSize = self.cellTopSize(at: indexPath, of: message)
        let messageTopSize = self.messageTopSize(at: indexPath, of: message)
        let messageSize = messageContainerSize(at: indexPath, of: message)
        let messageBottomSize = self.messageBottomSize(at: indexPath, of: message)
        let cellBottomSize = self.cellBottomSize(at: indexPath, of: message)
        
        let itemWidth = layout.messageCollectionView.frame.width - layout.messageCollectionView.contentInset.left - layout.messageCollectionView.contentInset.right
        let itemHeight = layout.messageCollectionView.contentInset.top + cellTopSize.height + messageTopSize.height + messageSize.height + messageBottomSize.height + cellBottomSize.height + layout.messageCollectionView.contentInset.bottom
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    
    // MARK: - Private calculate size for items each view
    private func cellTopSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return CGSize(width: message.messageId.textWidth(), height: 30)
    }
    
    private func messageTopSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        
        return CGSize(width: message.sender.displayName.textWidth(),
                      height: 30)
    }
    
    private func messageContainerSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        
        var size: CGSize = .zero
        
        switch message.kind {
        case .text:
            let labelSize = messageLabelSize(of: message)
            
            size = CGSize(width: labelSize.width + bubbleImageIncomingPadding.horizontal,
                          height: labelSize.height + bubbleImageIncomingPadding.vertical)
        default:
            break
        }
        
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
    
    private func messageBottomSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return CGSize(width: message.sentDate.textWidth(font: UIFont.systemFont(ofSize: 12)), height: 15)
    }
    
    private func cellBottomSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return CGSize(width: "已讀".textWidth(font: UIFont.systemFont(ofSize: 12)), height: 15)
    }

}

