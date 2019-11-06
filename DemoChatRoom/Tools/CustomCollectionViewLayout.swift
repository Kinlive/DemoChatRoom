//
//  CustomCollectionViewLayout.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/4.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {

    class override var layoutAttributesClass: AnyClass {
        return CustomLayoutAttributes.self
    }
    
    lazy var messageDataSource: MessageDataSource = {
        return messageCollectionView.messageDataSource!
    }()
    
    lazy var messageCollectionView: MessageCollectionView = {
        return self.collectionView as! MessageCollectionView
    }()
    
    weak var messageLayoutDelegate: MessageLayoutDelegate?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [CustomLayoutAttributes] else { return nil }
        
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            // calculate each attributes rect.
            textCalculator.configure(attributes: attributes)
        }
        return attributesArray
    }
    
    
    lazy var textCalculator: TextMessageCalculator = {
        let calculator = TextMessageCalculator(layout: self)
        return calculator
    }()
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return textCalculator.sizeForItem(at: indexPath)
    }
}

