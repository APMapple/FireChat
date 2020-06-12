//
//  UserCell.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 10/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import UIKit
import Nuke

class UserCell: UITableViewCell {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private let profileImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .systemPurple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "Username"
        lb.textColor = .darkGray
        return lb
    }()
    
    private let fullnameLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "Fullname"
        lb.textColor = .lightGray
        return lb
    }()
    
    //MARK: - Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        
        profileImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImage.setDimensions(height: 56, width: 56)
        profileImage.layer.cornerRadius = 56 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        
        stack.centerY(inView: profileImage, leftAnchor: profileImage.rightAnchor,paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("int Not implemented")
    }
    
    //MARK: - Helper
    
    func configure() {
        guard let user = user else { return }

        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
        guard let url = URL(string: user.profileImageUrl) else {
            return
        }
        Nuke.loadImage(with: url, into: profileImage)
    }
}
