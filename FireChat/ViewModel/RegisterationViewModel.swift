//
//  RegisterationViewModel.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 10/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import Foundation

protocol authenticationProtocol {
    var formIsValid: Bool { get }
}

struct RegisterationViewModel: authenticationProtocol {
    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
}
