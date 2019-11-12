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
        let collection = MessageCollectionView(frame: .zero, collectionViewLayout: messageLayout)
        collection.messageDataSource = self
        collection.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        collection.delegate = self
        collection.dataSource = self
        //當滾到最上方時會將鍵盤收起
        collection.keyboardDismissMode = .interactive
        collection.register(CustomMessageCell.self, forCellWithReuseIdentifier: "CustomMessageCell")
        return collection
    }()
    
    var dataSources: [MessageType] = [] {
        didSet {
            prepareUpdateDisplay()
        }
    }
    
    lazy var messageLayout: CustomCollectionViewLayout = {
       let layout = CustomCollectionViewLayout()
        //layout.messageLayoutDelegate = self
        return layout
    }()
    
    var messageAccessoryView: CustomInputAccessoryView = CustomInputAccessoryView()
    
    var shouldScrollToBottom: Bool = true
    
    override var inputAccessoryView: UIView? {
        messageAccessoryView.autoresizingMask = .flexibleHeight
        messageAccessoryView.backgroundColor = .systemBlue
        messageAccessoryView.delegate = self
        return messageAccessoryView
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override var canResignFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupRects()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            
            scrollToBottom(animated: false)
        }
       
    }
    
    open func configureSubviews() {
        view.addSubview(messageCollectionView)
    }
    
    open func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private var paddingGuide: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    private func setupRects() {
        // layout message collectionView
        messageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = messageCollectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: topLayoutGuide.length)
        let bottom = messageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            let leading = messageCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = messageCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, leading, trailing])
            
        } else {
            let leading = messageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = messageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
            NSLayoutConstraint.activate([top, bottom, leading, trailing])
            
        }
    }
    
    
    // mock sendButton use ---------------------------->
    var isPreviousUser: Bool = false
    
    @objc func onSendMessage() {
        let randomNumber = Int(arc4random_uniform(UInt32(randomMessage.count) - 1))
        let randomMsg = randomMessage[randomNumber]
        
        //let randomSender: SenderType = isPreviousUser ? botSender : selfSender
        //isPreviousUser = !isPreviousUser
        
        var message: MyMessage
            
        if randomNumber % 2 == 0 {
             message = MyMessage(kind: .text(randomMsg), sender: botSender, messageId: Date().longDate(), sentDate: Date().prettyDate())
        } else {
            message = MyMessage(kind: .custom("Test for Custom pass"), sender: botSender, messageId: Date().longDate(), sentDate: Date().prettyDate())
        }
        
        dataSources.append(message)
    }
    // <---------------------------------- mock
    
    @objc func sendMessage() {
        let message = MyMessage(kind: .text(messageAccessoryView.typingTextView.text ?? ""), sender: selfSender, messageId: Date().longDate(), sentDate: Date().prettyDate())
        dataSources.append(message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.onSendMessage()
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        adjustContentForKeyboard(shown: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {

        adjustContentForKeyboard(shown: false, notification: notification)
    }
    
    func adjustContentForKeyboard(shown: Bool, notification: Notification) {
        
        let frameEnd = notification.keyboardFrame()
        
        let keyboardHeight = shown ? frameEnd.height : messageAccessoryView.frame.size.height
//
//        messageCollectionView.contentInset.bottom = keyboardHeight
//        if keyboardHeight > 100 {
//            scrollToBottom()
//        }
        
        if messageCollectionView.contentInset.bottom == keyboardHeight {
            return
        }
     
        let distanceFromBottom = bottomOffset().y - messageCollectionView.contentOffset.y
     
        var insets = messageCollectionView.contentInset
        insets.bottom = keyboardHeight
     
        UIView.animate(withDuration: 0.3, animations: {
            self.messageCollectionView.contentInset = insets
            self.messageCollectionView.scrollIndicatorInsets = insets
            
            if distanceFromBottom < 10 {
                self.messageCollectionView.contentOffset = self.bottomOffset()
            }
        }) { end in
            
            //self.scrollToBottom(animated: true)
        }
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
        view.layoutIfNeeded()
        messageCollectionView.setContentOffset(bottomOffset(), animated: animated)
        
//        let collectionViewContentHeight = messageCollectionView.contentSize.height
//
//        messageCollectionView.performBatchUpdates(nil) { [weak self] _ in
//            self?.messageCollectionView.scrollRectToVisible(CGRect(x: 0.0, y: collectionViewContentHeight - 1.0, width: 1.0, height: 1.0), animated: animated)
//        }
    }
    
    func bottomOffset() -> CGPoint {
        return CGPoint(x: 0,
                       y: max(-messageCollectionView.contentInset.top,
                              messageCollectionView.contentSize.height - (messageCollectionView.bounds.height - messageCollectionView.contentInset.bottom))
                        )
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
        guard let dataSource = messageCollectionView.messageDataSource
            else { fatalError("MessageDataSource not be nil") }
        guard let collectionView = collectionView as? MessageCollectionView else { fatalError("Not a MessageCollectionView") }
        
        let message = dataSource.message(at: indexPath, in: collectionView)
        
        switch message.kind {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextMessageCell", for: indexPath) as! TextMessageCell
            cell.configure(message: message)
            return cell
        
        case .custom:
            return customCell(for: message, at: indexPath, in: messageCollectionView)
            
        default: break
        }
        
        return BaseChatViewCell()
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
    
    func customCell(for message: MessageType, at indexPath: IndexPath, in collectionView: MessageCollectionView) -> BaseChatViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMessageCell", for: indexPath) as? CustomMessageCell else { return BaseChatViewCell() }
        cell.configure(message: message)
        return cell
    }
    
    
    func customCellCalculator(for message: MessageType, at indexPath: IndexPath, in collectionView: MessageCollectionView) -> BaseMessageCalculator {
        return CustomMessageCalculator(layout: messageLayout)
    }
    
}

// MARK: - extension with CustomInputAccessoryView delegate
extension MessageBaseViewController: CustomInputAccessoryViewDelegate {
    func onPassButtonClicked(_ sender: UIButton, textView: UITextView) {
        sendMessage()
        // FIXME: - will warning for First responder warning on rejected resignFirstResponder when being removed from hierarchy.
        textView.becomeFirstResponder()
        textView.resignFirstResponder()
    }
    
    func onOptionsButtonClicked(_ sender: UIButton) {
        
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

