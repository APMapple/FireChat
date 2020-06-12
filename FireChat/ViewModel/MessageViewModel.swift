//
//  MessageViewModel.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 11/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import UIKit

struct MessageViewModel {
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : .systemPurple
    }
    
    var messageTextColor: UIColor
    {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard  let user = message.user else {
            return nil
        }
        return URL(string: user.profileImageUrl)
    }
    
    
    init(message: Message) {
        self.message = message
    }
    
}
