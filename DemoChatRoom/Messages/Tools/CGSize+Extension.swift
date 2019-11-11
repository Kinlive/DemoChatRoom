//
//  Extension+CGSize.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/7.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width,
                      height: lhs.height + rhs.height)
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: abs(lhs.width - rhs.width),
                      height: abs(lhs.height - rhs.height))
    }
}
