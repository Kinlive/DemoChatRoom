//
//  MessageDataSource.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/5.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

protocol MessageDataSource: class {
    func isFromUser(message: MessageType) -> Bool
    func message(at indexPath: IndexPath, in collectionView: MessageCollectionView) -> MessageType
    func numberOfItems() -> Int
    
}


protocol MessageLayoutDelegate: class {
    func cellTopSize(at indexPath: IndexPath, of message: MessageType) -> CGSize
    
    func messageTopSize(at indexPath: IndexPath, of message: MessageType) -> CGSize
    
    func messageLabelSize(at indexPath: IndexPath, of message: MessageType) -> CGSize
    
    func messageBottomSize(at indexPath: IndexPath, of message: MessageType) -> CGSize
    
    func cellBottomSize(at indexPath: IndexPath, of message: MessageType) -> CGSize
}

