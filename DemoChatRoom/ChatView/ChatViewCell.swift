//
//  ChatViewCell.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

// TODO: - add cellsModel

class ChatViewCell: UICollectionViewCell {

    // MARK: - Base with stack views
    @IBOutlet weak var leftStackView: UIStackView!
    
    @IBOutlet weak var middleStackView: UIStackView!
    
    @IBOutlet weak var rightStackView: UIStackView!
    
    // MARK: - Subviews of stackViews
    
    // Left stackView's subviews
    @IBOutlet weak var leftAvatarView: UIView!
    @IBOutlet weak var leftEmptyView: UIView!
    
    // Middle stackView's subviews
    @IBOutlet weak var cellTopView: UIView!
    @IBOutlet weak var cellTopLabel: UILabel!
    
    @IBOutlet weak var messageTopView: UIView!
    @IBOutlet weak var messageTopLabel: UILabel!
    
    @IBOutlet weak var messageContentView: UIView!
    @IBOutlet weak var messageContentImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageBottomView: UIView!
    @IBOutlet weak var messageBottomLabel: UILabel!
    
    @IBOutlet weak var cellBottomView: UIView!
    @IBOutlet weak var cellBottomLabel: UILabel!
    
    // Right stackView's subviews
    @IBOutlet weak var rightAvatarView: UIView!
    @IBOutlet weak var rightEmptyView: UIView!
    
    private var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var messageType: MessageType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    func setupMessage(messageType: MessageType, at indexPath: IndexPath) {
        self.messageType = messageType
        self.indexPath = indexPath
        handleMessage()
    }
    
    private func handleMessage() {
        guard let message = self.messageType else { return }
        
        messageTopLabel.text    = message.sender.displayName
        messageBottomLabel.text = message.sentDate
        cellTopLabel.text       = message.messageId
        
        handleDisplay(sender: message.sender)
        
        switch message.kind {
        case .text(let message):
            messageLabel.text = message
            
        default:
            break
        }
    }
    
    private func handleDisplay(sender: SenderType) {
        
        let senderIsUser = sender.senderId == "11111"
        
        messageTopLabel.textAlignment = senderIsUser ? .right : .left
        messageLabel.textAlignment = senderIsUser ? .right : .left
        messageBottomLabel.textAlignment = senderIsUser ? .right : .left
        cellBottomLabel.textAlignment = senderIsUser ? .right : .left
        
        leftAvatarView.backgroundColor = senderIsUser ? .clear : .green
        rightAvatarView.backgroundColor = senderIsUser ? .orange : .clear
        
        leftAvatarView.setCorner(radius: leftAvatarView.frame.height * 0.5)
        rightAvatarView.setCorner(radius: rightAvatarView.frame.height * 0.5)
    }
    
}
