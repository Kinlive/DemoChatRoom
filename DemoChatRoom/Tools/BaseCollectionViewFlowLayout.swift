//
//  CustomFlowLayout.swift
//  DemoSignature
//
//  Created by Thinkpower on 2019/10/23.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class BaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var columnsYoffset: [CGFloat] = []
    private var contentSize: CGSize = .zero
    var messageInputViewsHeight: CGFloat = 0
    
    private(set) var totalItemsInSection: Int = 0
    
    //var totalColumns = 0
    var interItemSpacing: CGFloat = 8
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + messageInputViewsHeight)
        // 60 means keyin baseView's height
    }
    
    override func prepare() {
        
        layoutMap.removeAll()
        
        totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
        columnsYoffset = Array(repeating: 0, count: totalItemsInSection)
        
        guard totalItemsInSection > 0
            //, totalColumns > 0
            else { return }
        calculateItemSize()
        
        var itemIndex = 0
        var contentSizeHeight: CGFloat = 0
        
        while itemIndex < totalItemsInSection {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let columnIndex = columnIndexForItemAt(indexPath: indexPath)
            
            let attributeRect = calculateItemFrame(indexPath: indexPath, columnIndex: columnIndex, columnYoffset: columnsYoffset[columnIndex])
            let targetLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            targetLayoutAttribute.frame = attributeRect
            
            contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
            columnsYoffset[columnIndex] = attributeRect.maxY + interItemSpacing
            layoutMap[indexPath] = targetLayoutAttribute
            
            itemIndex += 1
            
        }
        
        contentSize = CGSize(width: collectionView!.bounds.width - contentInsets.left - contentInsets.right,
                             height: contentSizeHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for (_, layoutAttributes) in layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    
    // Abstract Methods
    func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        return indexPath.item % totalItemsInSection
    }
    
    func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        return .zero
    }
    
    func calculateItemSize() { }

}
