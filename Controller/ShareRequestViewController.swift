//
//  ShareRequestViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class ShareRequestViewController: UIViewController {
    
    // MARK: - Properties
    var users: [User]?
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        configureTableView()
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func positiveAction(_ sender: UIButton) {
        sender.isEnabled  = false
        let touchPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let buttonIndex = tableView.indexPathForRow(at: touchPoint)
        
        users?.append(users[buttonIndex!.row]) { [weak self] error in
            guard let self = self else { return }
            if let error {
                showAlert(error: error)
            }
            
            sender.isEnabled = true
            self.tableView.reloadData()
        }
    }
    
    @IBAction func negativeAction(_ sender: UIButton) {
        sender.isEnabled = false
        let touchPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let buttonIndex = tableView.indexPathForRow(at: touchPoint)
        
        UserManager.shared.deleteRequestProfile(user: users[buttonIndex!.row]) { [weak self] error in
            guard let self = self else { return }
            if let error {
                showAlert(error: error)
            }
            
            sender.isEnabled = true
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate Methods
extension ShareRequestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShareRequestTableViewCell.identifier, for: indexPath) as? ShareRequestTableViewCell else { fatalError("Error dequeue cell") }
        cell.cellData = user
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, boolValue in
            boolValue(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
