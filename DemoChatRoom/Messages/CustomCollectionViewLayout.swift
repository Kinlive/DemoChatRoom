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
        
        return BaseMessageAttributes.self
    }
    
    lazy var messageDataSource: MessageDataSource = {
        return messageCollectionView.messageDataSource!
    }()
    
    lazy var messageCollectionView: MessageCollectionView = {
        return self.collectionView as! MessageCollectionView
    }()
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [BaseMessageAttributes] else { return nil }
        
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            // calculate each attributes rect.
            //textCalculator.configure(attributes: attributes)
            let indexPath = attributes.indexPath
            let message = messageDataSource.message(at: indexPath, in: messageCollectionView)
            
            let calculator = calculatorWith(message: message, at: indexPath)
            calculator.configure(attributes: attributes)
        }
        return attributesArray
    }
    
    
    lazy var textCalculator: TextMessageCalculator = {
        let calculator = TextMessageCalculator(layout: self)
        return calculator
    }()
    
    lazy var customCalculator: CustomMessageCalculator = {
        let calculator = CustomMessageCalculator(layout: self)
        return calculator
    }()
    
    func calculatorWith(message: MessageType, at indexPath: IndexPath) -> BaseMessageCalculator {
        switch message.kind {
        case .text:
            return textCalculator
        
        case .custom:
            return messageDataSource.customCellCalculator(for: message, at: indexPath, in: messageCollectionView)
            
        default: return textCalculator
        }
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let message = messageDataSource.message(at: indexPath, in: messageCollectionView)
        switch message.kind {
        case .custom:
            return customCalculator.sizeForItem(at: indexPath)
        default: break
        }
        return textCalculator.sizeForItem(at: indexPath)
    }
}

