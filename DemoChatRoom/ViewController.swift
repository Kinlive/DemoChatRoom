//
//  ViewController.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageSafeAreaBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatCollectionView: UICollectionView!
    
    @IBOutlet weak var textInputBaseView: UIView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var keyinTextField: UITextField!
    @IBOutlet weak var passMessageButton: UIButton!
    
    lazy private var messageLayout: ChatCollectionLayout = {
       let layout = ChatCollectionLayout(self)
        
        return layout
    }()
    
    var dataSource: [MessageType] = [] {
        didSet {
            prepareUpdateDisplay()
        }
    }
    private let selfSender: MyUser = MyUser(senderId: "11111", displayName: "Kin")
    private let botSender: MyUser = MyUser(senderId: "22222", displayName: "ChatBot")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMessageView()
        initKeyinText()
    }
    
    open func initMessageView() {
        chatCollectionView.collectionViewLayout = messageLayout
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        chatCollectionView.register(UINib(nibName: "ChatViewCell", bundle: nil), forCellWithReuseIdentifier: "ChatViewCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMessageBackground(recognizer:)))
        chatCollectionView.addGestureRecognizer(tap)
    }
    
    @objc func tapMessageBackground(recognizer: UITapGestureRecognizer) {
        keyinTextField.endEditing(true)
    }
    
    func initKeyinText() {
        // get keyboard frame.height
        passMessageButton.addTarget(self, action: #selector(passMessage), for: .touchUpInside)
        
        optionsButton.addTarget(self, action: #selector(passBotMessage), for: .touchUpInside)
        
        // add observe
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func passMessage() {
        keyinTextField.endEditing(true)
        let message = MyMessage(kind: .text(keyinTextField.text ?? ""), sender: selfSender, messageId: Date().longDate(), sentDate: Date().prettyDate())
        dataSource.append(message)
    }

    @objc func passBotMessage() {
        //keyinTextField.endEditing(true)
        let message = MyMessage(kind: .text("BOt\(keyinTextField.text ?? "")"), sender: botSender, messageId: Date().longDate(), sentDate: Date().prettyDate())
        dataSource.append(message)
    }
    
    
    func prepareUpdateDisplay() {
        
        chatCollectionView.performBatchUpdates({
            chatCollectionView.insertItems(at: [IndexPath(item: dataSource.count - 1, section: 0)])
            //chatCollectionView.reloadData()
//            if dataSource.count >= 2 {
//                chatCollectionView.reloadItems(at: [IndexPath(item: dataSource.count - 2, section: 0)])
//            }
            
        }) { [weak self] (end) in
           self?.scrollToBottom(animated: true)
            
        }
    }
    
    public func scrollToBottom(animated: Bool = false) {
        let collectionViewContentHeight = chatCollectionView.contentSize.height
        
        chatCollectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.chatCollectionView.scrollRectToVisible(CGRect(x: 0.0, y: collectionViewContentHeight - 1.0, width: 1.0, height: 1.0), animated: animated)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRect = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRect.height
        
        if #available(iOS 11.0, *) {
            messageSafeAreaBottomConstraint.constant = -keyboardHeight + view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
            messageSafeAreaBottomConstraint.constant = -keyboardHeight + bottomLayoutGuide.length
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (end) in
            self.scrollToBottom(animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        messageSafeAreaBottomConstraint.constant = 0
       UIView.animate(withDuration: 0.3) {
           self.view.layoutIfNeeded()
       }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatViewCell", for: indexPath) as? ChatViewCell else { return ChatViewCell() }
        
        cell.setupMessage(messageType: dataSource[indexPath.row], at: indexPath)
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate { }

extension ViewController: ChatCollectionLayoutDelegate {
    func layoutWithKeyInHeight(_ layout: ChatCollectionLayout) -> CGFloat {
        return textInputBaseView.frame.height
    }
    
    func collectionLayout(_ layout: ChatCollectionLayout) -> [MessageType] {
        return dataSource
    }
}
