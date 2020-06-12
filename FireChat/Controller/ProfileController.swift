//
//  ProfileController.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 11/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//

import UIKit
import Firebase
import Alertift

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController {
    
    //MARK: - Properties
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    private lazy var footerView = ProfileFooterView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100))
    
    weak var deleagte: ProfileControllerDelegate?
    
    private var user: User? {
        didSet {
            headerView.user = user
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - API
    func fetchUser() {
        showLoader(true)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Service.fetchUser(withUid: uid) { (user) in
            self.showLoader(false)
            self.user = user
        }
    }
    
    //MARK: - Helper
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = footerView
        footerView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
    }
    
    //MARK: - Selector
    
    
}


//MARK: - data source
extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


//MARK: - delegate
extension ProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileController: ProfileFooterViewDelegate {
    func handleLogout() {
        
        Alertift.actionSheet(title: "Logout", message: "Are you sure you want to logout?")
        .action(.default("Logout")) {
                self.deleagte?.handleLogout()
                self.dismiss(animated: true, completion: nil)
        }
        .action(.cancel("Cancel")){
            
        }
        .show(on: self)
    }
}
