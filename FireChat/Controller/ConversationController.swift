//
//  ConversationController.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 09/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ConversationController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    private let reuseIdentifier = "conversationCell"
    private var conversations = [Conversation]()
    
    private var conversationsDictionary = [String : Conversation]()
    
    private let newMessage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 56, width: 56)
        button.layer.cornerRadius = 56/2
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        fetchConverstions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavigationBar(withTitle: "Message", preferesLargeTitle: true)
    }
    
    @objc func showProfile() {
        let controller = ProfileController(style: .insetGrouped)
        controller.deleagte = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginscreen()
        } else {
            
        }
    }
    
    func fetchConverstions() {
        showLoader(true)
        Service.fetchConversation { (conversations) in
            self.conversations = conversations
            conversations.forEach { (conversation) in
                let message = conversation.messages
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationsDictionary.values)
            self.showLoader(false)
            self.tableView .reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessage)
        newMessage.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 24)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(Conversationcell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func configureNavigationBar(withTitle: String, preferesLargeTitle: Bool) {
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearence.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        navigationController?.navigationBar.prefersLargeTitles = preferesLargeTitle
        navigationItem.title = withTitle
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func presentLoginscreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginscreen()
        } catch {
            print("error sign out")
        }
    }
    
    func showConversation(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - selector
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
}

extension ConversationController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Conversationcell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    
}

extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showConversation(forUser: user)
    }
}

extension ConversationController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        dismiss(animated: true, completion: nil)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}

//MARK: - ProfileControllerDelegate

extension ConversationController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}


//MARK: - AuthenticationDelegate

extension ConversationController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchConverstions()
    }
}

