//
//  ProfileFooterView.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 11/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import UIKit
import Firebase

protocol ProfileFooterViewDelegate: class{
    func handleLogout()
}


class  ProfileFooterView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProfileFooterViewDelegate?
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper

    //MARK: - Selector
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }

}
