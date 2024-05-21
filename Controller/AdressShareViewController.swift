//
//  AdressShareViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class AdressShareViewController: UIViewController {
    
    // MARK: - Properties
    var registeredUsers: [User] = [User]()
    var address: Address?
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getUsers()
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
    
    private func configureIndicator() {
        self.view.addSubview(indicator)
        indicator.color = UIColor(named: "PrimaryColor")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    // MARK: - Networking
    fileprivate func getUsers() {
        indicator.startAnimating()
        UserManager.shared.getSharedUsers { [weak self] users, error in
            guard let self = self, error == nil else { return }
            self.indicator.stopAnimating()
            
            guard let users = users else { return }
            
            self.registeredUsers = users
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension AdressShareViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = registeredUsers[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = user.username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = registeredUsers[indexPath.row]
        
        indicator.startAnimating()
        
        AddressManager.shared.shareAddress(address: address!, toUser: user) { [weak self] error in
            guard let self = self, error == nil else { return }
            self.indicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
