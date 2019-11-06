//
//  MessageBaseViewController.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/5.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class MessageBaseViewController: UIViewController {

    private let selfSender: MyUser = MyUser(senderId: "11111", displayName: "Kin")
    private let botSender: MyUser = MyUser(senderId: "22222", displayName: "ChatBot")
    
    lazy var messageCollectionView: MessageCollectionView = {
        let collection = MessageCollectionView(frame: view.frame, collectionViewLayout: messageLayout)
        collection.messageDataSource = self
        collection.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton(frame: CGRect(x: 100, y: view.frame.maxY - 100, width: 50, height: 50))
        sendButton.setTitle("傳送", for: .normal)
        sendButton.setTitleColor(.blue, for: .normal)
        sendButton.addTarget(self, action: #selector(onSendMessage), for: .touchUpInside)
        return sendButton
    }()
    
    var dataSources: [MessageType] = [] {
        didSet {
            prepareUpdateDisplay()
        }
    }
    
    lazy var messageLayout: CustomCollectionViewLayout = {
       let layout = CustomCollectionViewLayout()
        layout.messageLayoutDelegate = self
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(messageCollectionView)
        view.addSubview(sendButton)
    }

    
    var isPreviousUser: Bool = false
    
    @objc func onSendMessage() {
        let randomNumber = Int(arc4random_uniform(UInt32(randomMessage.count) - 1))
        let randomMsg = randomMessage[randomNumber]
        
        let randomSender: SenderType = isPreviousUser ? botSender : selfSender
        isPreviousUser = !isPreviousUser
        
        let message = MyMessage(kind: .text(randomMsg), sender: randomSender, messageId: Date().longDate(), sentDate: Date().prettyDate())
        
        dataSources.append(message)
    }
    
    func prepareUpdateDisplay() {
            
            messageCollectionView.performBatchUpdates({
                messageCollectionView.insertItems(at: [IndexPath(item: dataSources.count - 1, section: 0)])
                //chatCollectionView.reloadData()
    //            if dataSource.count >= 2 {
    //                chatCollectionView.reloadItems(at: [IndexPath(item: dataSource.count - 2, section: 0)])
    //            }
                
            }) { [weak self] (end) in
               self?.scrollToBottom(animated: true)
                
            }
        }
    
    public func scrollToBottom(animated: Bool = false) {
        let collectionViewContentHeight = messageCollectionView.contentSize.height
        
        messageCollectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.messageCollectionView.scrollRectToVisible(CGRect(x: 0.0, y: collectionViewContentHeight - 1.0, width: 1.0, height: 1.0), animated: animated)
        }
    }
    
}

// MARK: - UICollectionView delegate
extension MessageBaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? CustomCollectionViewLayout else { return .zero }
        return layout.sizeForItem(at: indexPath)
    }

    
}
// MARK: - UICollectionView dataSource
extension MessageBaseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageCollectionView.messageDataSource?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = messageCollectionView.messageDataSource,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseChatViewCell", for: indexPath) as? BaseChatViewCell else { return BaseChatViewCell() }
        let message = dataSource.message(at: indexPath, in: collectionView as! MessageCollectionView)
        cell.configure(message: message)
        
        return cell
    }
    
    
}

// MARK: - Message DataSource
extension MessageBaseViewController: MessageDataSource {
    func isFromUser(message: MessageType) -> Bool {
        return message.sender.displayName == selfSender.displayName
    }
    
    func message(at indexPath: IndexPath, in collectionView: MessageCollectionView) -> MessageType {
        return dataSources[indexPath.row]
    }
    
    func numberOfItems() -> Int {
        return dataSources.count
    }
    
    
}

// MARK: - Message layout delegate
extension MessageBaseViewController: MessageLayoutDelegate {
    func cellTopSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return CGSize(width: message.messageId.textWidth(), height: 30)
    }
    
    func messageTopSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        
        return CGSize(width: message.sender.displayName.textWidth(),
                      height: 30)
    }
    
    func messageLabelSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        var size: CGSize = .zero
        var textWidth = messageCollectionView.frame.width * 0.7
        
        
        switch message.kind {
        case .text(let text):
            let aWidth = text.textWidth()
            
            textWidth = min(textWidth, aWidth)
            
            let textHeight = max(text.height(withConstrainedWidth: textWidth, font: UIFont.systemFont(ofSize: 17)) + 5, 30)
            
            size = CGSize(width: textWidth, height: textHeight)
        default:
            break
        }
        
        return size
    }
    
    func messageBottomSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return CGSize(width: message.sentDate.textWidth(font: UIFont.systemFont(ofSize: 12)), height: 15)
    }
    
    func cellBottomSize(at indexPath: IndexPath, of message: MessageType) -> CGSize {
        return CGSize(width: "已讀".textWidth(font: UIFont.systemFont(ofSize: 12)), height: 15)
    }
    
}


let randomMessage: [String] = [
"1111111111111111111",
"2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222",
"3333333333333333333",
"4444444444444444444",
"55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555",
"6666666666666666666",
"7777777777777777777"
]

extension String {
    // this is get text total width on one line
    func textWidth(font: UIFont = .systemFont(ofSize: 17)) -> CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font : font]).width + 4
        
    }
}
