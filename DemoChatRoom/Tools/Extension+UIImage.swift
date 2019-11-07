//
//  Extension+UIImage.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension UIImage {
    static func bubbleOfIncoming(insets: UIEdgeInsets) -> UIImage {
        let incoming = UIImage(named: "bubble_received")!
            .resizableImage(withCapInsets:
                UIEdgeInsets(top: insets.top,
                             left: insets.left,
                             bottom: insets.bottom,
                             right: insets.right),
                            resizingMode: .stretch)
        
        return incoming
    }
    
    
    static func bubbleOfOutgoing(insets: UIEdgeInsets) -> UIImage {
        let outgoing = UIImage(named: "bubble_sent")!
        .resizableImage(withCapInsets:
            UIEdgeInsets(top: insets.top,
                         left: insets.left,
                         bottom: insets.bottom,
                         right: insets.right),
                        resizingMode: .stretch)
        return outgoing
    }
    
}
