//
//  Extension+String.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension String {
    /// if you need get text's height just call it
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.height)
    }
  
    /// if you need get text's width just call it.
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
    }
    
    /// this is get text total width on one line
    func textWidth(font: UIFont = .systemFont(ofSize: 17)) -> CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font : font]).width
        
    }
}
