//
//  MessageType.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import Foundation

protocol SenderType {
    var senderId: String { get }
    var displayName: String { get }
}

enum MessageKind {
    case text(String)
    case photo
    case custom(Any?)
}

// for any messages implements
protocol MessageType {
    var sender: SenderType { get }
    var messageId: String { get }
    var sentDate: String { get }
    var kind: MessageKind { get }
    
}
