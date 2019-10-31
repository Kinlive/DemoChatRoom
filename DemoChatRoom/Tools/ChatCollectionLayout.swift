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
}

class ChatCollectionLayout: BaseCollectionViewFlowLayout {

    public private(set) var dataSource: [MessageType] = []
    public private(set) var messageFont: UIFont = .systemFont(ofSize: 15)
    
    public private(set) weak var delegate: ChatCollectionLayoutDelegate?
    
    override init() {
        super.init()
    }
    
    convenience init(_ layoutDelegate: ChatCollectionLayoutDelegate) {
        self.init()
        
        self.delegate = layoutDelegate
        dataSource = layoutDelegate.collectionLayout(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("do not use init(coder:) please programming.")
    }
    
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        
        let data = dataSource[indexPath.row]
        let dataSize = calculateItemSize(with: data.kind)
        
        return CGRect(x: 0, y: columnYoffset, width: dataSize.width, height: dataSize.height)
    }
    
    
    private func calculateItemSize(with kind: MessageKind) -> CGSize {
        var size: CGSize = .zero
        let itemWidth = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        // leftStackView width , contentlabel left/right padding, rightStackViewWidth.
        let messageContentWidth = collectionView!.bounds.width - 40 - 10 - 40
        // middle stackViews subviews height.
        let othersHeights: CGFloat = 25 * 4
        
        switch kind {
        case .text(let text):
            let textHeight = text.height(withConstrainedWidth: messageContentWidth, font: messageFont)
            size = CGSize(width: itemWidth, height: textHeight + othersHeights)
            
        case .photo:
            break
        case .custom(let anything):
            break
        }
        
        return size
    }
    
    public func updateDataSource() {
        if let delegate = delegate {
            self.dataSource = delegate.collectionLayout(self)
        }
    }
    
}
