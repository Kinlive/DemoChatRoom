//
//  ChatCollectionLayout.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

protocol ChatCollectionLayoutDelegate: class {
    func collectionLayout(_ layout: ChatCollectionLayout) -> [MessageType]
    func layoutWithKeyInHeight(_ layout: ChatCollectionLayout) -> CGFloat
}

class ChatCollectionLayout: BaseCollectionViewFlowLayout {

    public var dataSource: [MessageType] {
        get {
            return delegate?.collectionLayout(self) ?? []
        }
    }
    public private(set) var messageFont: UIFont = .systemFont(ofSize: 17)
    
    public private(set) weak var delegate: ChatCollectionLayoutDelegate?
    
    override init() {
        super.init()
    }
    
    convenience init(_ layoutDelegate: ChatCollectionLayoutDelegate) {
        self.init()
        //totalColumns = 0
        self.delegate = layoutDelegate
        self.messageInputViewsHeight = layoutDelegate.layoutWithKeyInHeight(self)
        //dataSource = layoutDelegate.collectionLayout(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("do not use init(coder:) please programming.")
    }
    
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        
        let data = dataSource[indexPath.row]
        let dataSize = calculateItemSize(with: data.kind)
        
        return CGRect(x: 0, y: dataSize.height * CGFloat(indexPath.row), width: dataSize.width, height: dataSize.height)
    }
    
    
    private func calculateItemSize(with kind: MessageKind) -> CGSize {
        var size: CGSize = .zero
        let itemWidth = collectionView!.frame.width - contentInsets.left - contentInsets.right
        // leftStackView width , contentlabel left/right padding, rightStackViewWidth.
        let messageContentWidth = itemWidth - 40 - 10 - 40 - 20
        // middle stackViews subviews height, and paddings.
        let othersHeights: CGFloat = 25 * 4 + 10 + contentInsets.top + contentInsets.bottom
        
        switch kind {
        case .text(let text):
            let textHeight = text.height(withConstrainedWidth: messageContentWidth, font: messageFont)
            size = CGSize(width: itemWidth, height: textHeight + othersHeights)
            
        case .photo:
            break
        case .custom:
            break
        }
        
        return size
    }
    
}
