//
//  MyMessage.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import Foundation

struct MyMessage: MessageType {
    
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: String
    
    var kind: MessageKind
    
    init(kind: MessageKind, sender: SenderType, messageId: String, sentDate: String) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
    }
}
