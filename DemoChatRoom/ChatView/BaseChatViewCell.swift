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
        
        return view
    }()
    
    var cellTopLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var messageTopLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var messageLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var messageBottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var cellBottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var containerImageView: UIImageView = {
       let view = UIImageView()
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    private func addSubviews() {
        contentView.addSubview(avatarView)
        contentView.addSubview(cellTopLabel)
        contentView.addSubview(messageTopLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(messageBottomLabel)
        contentView.addSubview(cellBottomLabel)
        contentView.addSubview(containerImageView)
    }
    
    func layoutAvatarView() {
        
    }
    
    func layoutCellTopLabel() {
        
    }
    
    func layoutMessageTopLabel() {
        
    }
    
    func layoutMessageLabel() {
        
    }
    
    func layoutMessageBottomLabel() {
        
    }
    
    func layoutCellBottomLabel() {
        
    }
    
    func layoutContainerImageView() {
        
    }
    
}
