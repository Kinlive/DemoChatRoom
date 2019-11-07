//
//  NewChatViewCell.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/1.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class BaseChatViewCell: UICollectionViewCell {
    
    var avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.setCorner(radius: 15)
        view.layer.masksToBounds = true
        return view
    }()
    
    var cellTopLabel: UILabel = {
       let label = UILabel()
        label.setCorner(radius: 12.5)
        label.backgroundColor = .systemPink
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var messageTopLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .systemBlue
        label.numberOfLines = 1
        return label
    }()
    
    var messageBottomLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .systemGreen
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var cellBottomLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .systemTeal
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var containerImageView: MessageContainerView = {
       let view = MessageContainerView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        
        return view
    }()
    
    // MARK: - Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubviews()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? BaseMessageAttributes else { return }
        
        layoutAvatarView(attributes: attributes)
        layoutCellTopLabel(attributes: attributes)
        layoutMessageTopLabel(attributes: attributes)
        layoutMessageContainerView(attributes: attributes)
        
        layoutMessageBottomLabel(attributes: attributes)
        layoutCellBottomLabel(attributes: attributes)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellTopLabel.text = nil
        messageTopLabel.text = nil
        messageBottomLabel.text = nil
        cellBottomLabel.text = nil
        
    }
    
    func configure(message: MessageType) {
        
        cellTopLabel.text = message.messageId
        messageTopLabel.text = message.sender.displayName
        
        messageBottomLabel.text = message.sentDate
        cellBottomLabel.text = "已讀"
    }
    
    func addSubviews() {
        
        contentView.addSubview(avatarView)
        contentView.addSubview(cellTopLabel)
        contentView.addSubview(messageTopLabel)
        contentView.addSubview(messageBottomLabel)
        contentView.addSubview(cellBottomLabel)
        contentView.addSubview(containerImageView)
        
    }
    
    // MARK: - Layout all subviews
    private func layoutAvatarView(attributes: BaseMessageAttributes) {
        
        var origin: CGPoint = .zero
        
        switch attributes.avatarPosition.horizontal {
        case .leading:
            origin.x = 0
            
        case .trailing:
            origin.x = contentView.frame.width - attributes.avatarSize.width
        }
        
        switch attributes.avatarPosition.vertical {
        case .cellTop:
            origin.y = 0
            
        case .messageTop:
            origin.y = attributes.avatarSize.height
            
        case .messageCenter:
            //origin.y = attributes.avatarSize.height + attributes.cellTopSize.height
            origin.y = attributes.cellTopSize.height + attributes.messageSize.height
        case .messageBottom:
            origin.y = attributes.avatarSize.height + attributes.cellTopSize.height + attributes.messageSize.height
            
        case .cellBottom:
            origin.y = contentView.frame.maxY - attributes.cellBottomSize.height
        }
        
        avatarView.frame = CGRect(origin: origin, size: attributes.avatarSize)
    }
    
    private func layoutCellTopLabel(attributes: BaseMessageAttributes) {
        cellTopLabel.textAlignment = attributes.cellTopAlignment.textAlignment
        
        var origin: CGPoint = .zero
        origin.x = contentView.frame.midX - attributes.cellTopSize.width * 0.5
        
        cellTopLabel.frame = CGRect(origin: origin, size: attributes.cellTopSize)
    }
    
    private func layoutMessageTopLabel(attributes: BaseMessageAttributes) {
        messageTopLabel.textAlignment = attributes.messageTopAlignment.textAlignment
        var origin = CGPoint(x: 0, y: cellTopLabel.frame.maxY)
        
        switch attributes.avatarPosition.horizontal {
        case .leading:
            origin.x = avatarView.frame.maxX
            
        case .trailing:
            origin.x = contentView.frame.width - attributes.avatarSize.width - attributes.messageTopSize.width
        }
        
        messageTopLabel.frame = CGRect(origin: origin, size: attributes.messageTopSize)
    }
    
    private func layoutMessageContainerView(attributes: BaseMessageAttributes) {
        containerImageView.applyMaskStyle(attributes: attributes)
        
        var origin = CGPoint(x: 0, y: messageTopLabel.frame.maxY)
        switch attributes.avatarPosition.horizontal {
        case .leading:
            origin.x = avatarView.frame.maxX
            
        case .trailing:
            origin.x = contentView.frame.width - attributes.avatarSize.width - attributes.messageSize.width
        }
        containerImageView.frame = CGRect(origin: origin, size: attributes.messageSize)
        
    }
    
    private func layoutMessageBottomLabel(attributes: BaseMessageAttributes) {
        messageBottomLabel.textAlignment = attributes.messageBottomAlignment.textAlignment
        var origin = CGPoint(x: 0, y: containerImageView.frame.maxY)
        
        // LINE style
        origin.y = containerImageView.frame.maxY - attributes.messageBottomSize.height * 2
        let paddingWithMessageHorizontal: CGFloat = 5
        
        switch attributes.avatarPosition.horizontal {
        case .leading:
            //origin.x = avatarView.frame.maxX
            // LINE style
            origin.x = containerImageView.frame.maxX + paddingWithMessageHorizontal
            
        case .trailing:
            //origin.x = contentView.frame.width - attributes.avatarSize.width - attributes.messageBottomSize.width
            // LINE style
            origin.x = containerImageView.frame.minX - attributes.messageBottomSize.width - paddingWithMessageHorizontal
        }
        messageBottomLabel.frame = CGRect(origin: origin, size: attributes.messageBottomSize)
    }
    
    private func layoutCellBottomLabel(attributes: BaseMessageAttributes) {
        cellBottomLabel.textAlignment = attributes.cellBottomAlignment.textAlignment
        var origin = CGPoint(x: 0, y: messageBottomLabel.frame.maxY)
        // LINE style
        origin.y = messageBottomLabel.frame.maxY
        switch attributes.avatarPosition.horizontal {
        case .leading:
            //origin.x = avatarView.frame.maxX
            // LINE style
            origin.x = messageBottomLabel.frame.minX
        case .trailing:
            //origin.x = contentView.frame.width - attributes.avatarSize.width - attributes.messageSize.width
            // LINE style
            origin.x = messageBottomLabel.frame.maxX - attributes.cellBottomSize.width
        }
        cellBottomLabel.frame = CGRect(origin: origin, size: attributes.cellBottomSize)
    }
    
}
