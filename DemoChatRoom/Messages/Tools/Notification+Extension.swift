//
//  Notification+Extension.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/11.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension Notification {
    func keyboardFrame() -> CGRect {
        guard let keyboardFrame = self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return .zero }
        let keyboardRect = keyboardFrame.cgRectValue
        return keyboardRect
    }
}
