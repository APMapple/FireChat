//
//  NewMessageController.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 10/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}


class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    private var users = [User]()
    private var filteredUsers = [User]()

    weak var delegate: NewMessageControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    //MARK: - API
    
    func fetchUsers(){
        showLoader(true)
        Service.fetchUsers { users in
            self.users = users
            self.showLoader(false)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helper
    func configureUI() {
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user"
        definesPresentationContext = false
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField{
            textfield.textColor = .systemPurple
            textfield.backgroundColor = .white
        }
    }
    
    //MARK: - Selector
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view Datesource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
       
        cell.user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
       
        return cell
    }
}

// MARK: - Table view Delegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }

        filteredUsers = users.filter({ (user) -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        tableView.reloadData()
    }
}
