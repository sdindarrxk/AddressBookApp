//
//  SettingsViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
    var users: [User] = UserManager.shared.users
    let user: User? = AuthManager.shared.getProfile()
    
    // MARK: - Outlets
    @IBOutlet var profileCell: ProfileTableViewCell!
    @IBOutlet var istekLbl: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profileCell.configureCell(with: user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if users.count > 0 {
            istekLbl.text?.append("(\(users.count) Yeni Paylaşım İsteği)")
        } else {
            istekLbl.text = "Paylaşım istekleri"
        }
    }
    
    // MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }
        
        switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "gotoRegistereds", sender: nil)
                break
            case 1:
                self.performSegue(withIdentifier: "gotoShareRequests", sender: nil)
                break
            case 2:
                AuthManager.shared.closeProfile { error in
                    guard error == nil else { return }
                    self.performSegue(withIdentifier: "GoToLoginScreen", sender: nil)
                }
                break
            default:
                break
        }
    }
}
