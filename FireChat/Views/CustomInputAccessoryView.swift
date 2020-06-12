//
//  CustomInputAccessoryView.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 10/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String )
}


class CustomInputAccessoryView: UIView {
    //MARK: - Properties
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    
    private let messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        button.setTitleColor(.systemPurple, for: .normal)
        return button
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        backgroundColor = .white
        
        autoresizingMask = .flexibleHeight
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputTextView)
        
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeholder)
        placeholder.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeholder.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Helper
    
    func clearMessageText() {
        messageInputTextView.text = nil
        placeholder.isHidden = false
    }
    
    //MARK: - Selector
    
    @objc func handleSendMessage() {
        guard let text = messageInputTextView.text else { return }
        delegate?.inputView(self, wantsToSend: text)
    }
    
    @objc func handleTextInputChange() {
        placeholder.isHidden = !self.messageInputTextView.text.isEmpty
    }
}
