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
    
    lazy private var messageLayout: ChatCollectionLayout = {
       let layout = ChatCollectionLayout(self)
        
        return layout
    }()
    
    var dataSource: [MessageType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMessageView()
        
    }
    
    open func initMessageView() {
        chatCollectionView.collectionViewLayout = messageLayout
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        chatCollectionView.register(UINib(nibName: "ChatViewCell", bundle: nil), forCellWithReuseIdentifier: "ChatViewCell")
        
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatViewCell", for: indexPath) as? ChatViewCell else { return ChatViewCell() }
        
        cell.setupMessage(messageType: dataSource[indexPath.row], at: indexPath)
        
        return UICollectionViewCell()
    }
    
}

extension ViewController: UICollectionViewDelegate { }

extension ViewController: ChatCollectionLayoutDelegate {
    func collectionLayout(_ layout: ChatCollectionLayout) -> [MessageType] {
        return dataSource
    }
}
