//
//  Extension+UIView.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/1.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension UIView {
    func setCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
}
