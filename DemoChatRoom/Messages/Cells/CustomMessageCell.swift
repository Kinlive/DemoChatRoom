//
//  CustomMessageCell.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

// here is self custom cell
class CustomMessageCell: BaseChatViewCell {
    
    var customView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func addSubviews() {
        // this will avoid other views like as avatarView
        super.addSubviews()
        containerImageView.addSubview(customView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attributes = layoutAttributes as? BaseMessageAttributes else { return }
        
        layoutCustomView(attributes: attributes)
    }
    
    override func configure(message: MessageType) {
        super.configure(message: message)
        guard case .custom(let anyPass) = message.kind, let text = anyPass as? String else { return }
        customView.setTitle(text, for: .normal)
        
    }
    
    private func layoutCustomView(attributes: BaseMessageAttributes) {
    
        let point = CGPoint(x: attributes.messageAlignment.textInset.left,
                            y: attributes.messageAlignment.textInset.top)
        customView.frame = CGRect(origin: point, size: attributes.messageSize - CGSize(width: attributes.messageAlignment.textInset.horizontal, height: attributes.messageAlignment.textInset.vertical))
        customView.setCorner(radius: 20)
        
    }
    
    @objc private func buttonAction() {
        print("You tap my buuuuuuuuutton!")
    }
}
