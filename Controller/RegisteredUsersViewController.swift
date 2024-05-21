//
//  RegisteredUsersViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class RegisteredUsersViewController: UIViewController {
    
    // MARK: - Properties
    var users: [User] = .init()
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRegistereds()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        configureTableView()
        configureIndicator()
    }
    
    fileprivate func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }
    
    fileprivate func configureIndicator() {
        self.view.addSubview(indicator)
        indicator.color = UIColor(named: "PrimaryColor")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    // MARK: - Networking
    private func getRegistereds() {
        indicator.startAnimating()
        UserManager.shared.getSharedUsers { [weak self] usersData, error in
            guard let self = self, let users = usersData else { return }
            
            if let error {
                showAlert(error: error)
                return
            }
            
            self.indicator.stopAnimating()
            self.tableView.isHidden = false
            self.users = users
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension RegisteredUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = user.username
        
        return cell
    }
}
