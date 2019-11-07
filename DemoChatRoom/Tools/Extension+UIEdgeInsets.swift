//
//  Extension+UIEdgeInsets.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    var horizontal: CGFloat { return left + right }
    var vertical  : CGFloat { return top + bottom }
    
    init(top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        self.init()
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
    
    
}

