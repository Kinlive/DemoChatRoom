//
//  CustomInputAccessoryView.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/11.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func onPassButtonClicked(_ sender: UIButton, textView: UITextView)
    func onOptionsButtonClicked(_ sender: UIButton)
}

class CustomInputAccessoryView: UIView {
    
    @IBOutlet weak var typingTextView: UITextView!
    @IBOutlet weak var typingPlaceholderLabel: UILabel!
    
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var passButton: UIButton!
    
    var baseView: UIView!
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return textViewContentSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        initFromNib()
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        autoresizingMask = .flexibleHeight
        initFromNib()
        setupDefaults()
    }
    
    // MARK: - Methods [Private]
    private func setupDefaults() {
        
        typingTextView.delegate = self
        typingTextView.isScrollEnabled = false
        passButton.addTarget(self, action: #selector(onPassClicked), for: .touchUpInside)
        optionsButton.addTarget(self, action: #selector(onOptionsClicked), for: .touchUpInside)
        
    }
    
    private func initFromNib() {
      
      let className = type(of: self)
      let nibName = NSStringFromClass(className).components(separatedBy: ".").last
      baseView = UINib(nibName: nibName!, bundle: Bundle(for: className)).instantiate(withOwner: self, options: nil).first as? UIView
        baseView.frame = self.bounds
        baseView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor.darkGray.cgColor
      addSubview(baseView)
        
    }
    
    private func textViewContentSize() -> CGSize {
        let size = CGSize(width: typingTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let textSize = typingTextView.sizeThatFits(size)
        
        return CGSize(width: UIView.noIntrinsicMetric, height: textSize.height)
    }
    
    @objc private func onPassClicked() {
        delegate?.onPassButtonClicked(passButton, textView: typingTextView)
        typingTextView.text = ""
        typingPlaceholderLabel.isHidden = false
    }
    
    @objc private func onOptionsClicked() {
        delegate?.onOptionsButtonClicked(optionsButton)
    }

}


extension CustomInputAccessoryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        typingPlaceholderLabel.isHidden = !textView.text.isEmpty
        self.invalidateIntrinsicContentSize()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
}
