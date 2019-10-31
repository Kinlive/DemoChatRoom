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
    @IBOutlet weak var messagTopLabel: UILabel!
    
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
        
    }

    func setupMessage(messageType: MessageType, at indexPath: IndexPath) {
        self.messageType = messageType
        self.indexPath = indexPath
        handleMessage()
    }
    
    private func handleMessage() {
        guard let message = self.messageType else { return }
        
        messagTopLabel.text     = message.sender.displayName
        messageBottomLabel.text = message.sentDate
        cellTopLabel.text       = message.messageId
        
        switch message.kind {
        case .text(let message):
            messageLabel.text = message
            
        default:
            break
        }
    }
    
}
