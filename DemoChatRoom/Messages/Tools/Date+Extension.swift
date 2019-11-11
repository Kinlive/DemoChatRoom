//
//  Date+Extension.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/8.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import Foundation

extension Date {
    func prettyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        
        return dateFormatter.string(from: self)
        
    }
    
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
