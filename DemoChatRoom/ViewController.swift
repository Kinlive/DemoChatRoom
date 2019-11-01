//
//  ViewController.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/10/31.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        
    }
    
    func initKeyinText() {
        // get keyboard frame.height
        passMessageButton.addTarget(self, action: #selector(passMessage), for: .touchUpInside)
        
        optionsButton.addTarget(self, action: #selector(passBotMessage), for: .touchUpInside)
        
    }
    
    @objc func passMessage() {
        let message = MyMessage(kind: .text(keyinTextField.text ?? ""), sender: selfSender, messageId: "", sentDate: Date().prettyDate())
        dataSource.append(message)
    }

    @objc func passBotMessage() {
        let message = MyMessage(kind: .text("BOt\(keyinTextField.text ?? "")"), sender: botSender, messageId: "", sentDate: Date().prettyDate())
        dataSource.append(message)
    }
    
    
    func prepareUpdateDisplay() {
        chatCollectionView.performBatchUpdates({
            
            chatCollectionView.insertItems(at: [IndexPath(item: dataSource.count - 1, section: 0)])
            chatCollectionView.reloadData()
//            if dataSource.count >= 2 {
//                chatCollectionView.reloadItems(at: [IndexPath(item: dataSource.count - 2, section: 0)])
//            }
            
        }) { [weak self] (end) in
            self?.scrollToBottom(animated: true)
        }
    }
    
    public func scrollToBottom(animated: Bool = false) {
        let collectionViewContentHeight = chatCollectionView.contentSize.height
        let keyinHeight = textInputBaseView.frame.height
        
        chatCollectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.chatCollectionView.scrollRectToVisible(CGRect(x: 0.0, y: collectionViewContentHeight - 1.0, width: 1.0, height: 1.0), animated: animated)
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


extension Date {
    func prettyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        
        return dateFormatter.string(from: self)
        
    }
}
