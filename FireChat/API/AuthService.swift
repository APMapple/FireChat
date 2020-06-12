//
//  AuthService.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 10/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct RegisterationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credential: RegisterationCredentials, completion: ((Error?) -> Void)?) {
        
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let err = error {
                print("error upload\(err.localizedDescription)")
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
                    if let err = error {
                        print("error fail to create user\(err.localizedDescription)")
                        completion!(error)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    let data = [ "email" : credential.email,
                                 "fullname" : credential.fullname,
                                 "profileImageUrl" : profileImageUrl,
                                 "uid" : uid,
                                 "username" : credential.username
                        ] as [String : Any]
                    
                    Firestore.firestore().collection("user").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
}
