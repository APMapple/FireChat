//
//  ConversationViewModel.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 11/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.messages.timestamp.dateValue()
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        return dateformatter.string(from: date)
    }
    
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
