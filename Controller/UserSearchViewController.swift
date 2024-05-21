//
//  UserSearchViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class UserSearchViewController: UIViewController {
    
    // MARK: - Properties
    private var users: [User] = .init()
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        configureTableView()
        searchBar.delegate = self
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let data = sender as? User else { return }
        
        if let vc = segue.destination as? ProfileViewController {
            vc.user = data
        }
    }
}

// MARK: - TableViewDelegate & TableViewDataSource Methods
extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userList", for: indexPath)
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user..fullname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = users[indexPath.row]
        performSegue(withIdentifier: "gotoProfileScreen", sender: user)
    }
}

// MARK: - SearchBarDelegate Methods
extension UserSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { 
            tableView.isHidden = true
            return
        }
        
        tableView.isHidden = false
        let lowText = searchText.lowercased()
        
        UserManager.shared.getUsers(searchText: lowText) { [weak self] users, error in
            guard let self = self, let users = users else { return }
            
            if let error {
                showAlert(error: error)
                return
            }
            
            self.users = users
            self.tableView.reloadData()
        }
    }
}
