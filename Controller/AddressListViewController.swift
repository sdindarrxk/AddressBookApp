//
//  AddressListViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class AddressListViewController: UIViewController {
    
    // MARK: - Properties
    var users: [User] = UserManager.shared.users
    private let dbManager: AddressManager = AddressManager.shared
    private var addresses: [Address]  = [Address]()
    private var firstStart: Bool = true
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setRequest()
        indicator.hidesWhenStopped = true
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstStart {
            tableView.isHidden = true
            indicator.startAnimating()
            dbManager.getAddresses { [weak self] address, error in
                guard let self = self else { return }
                
                if let error {
                    self.showAlert(error: error)
                    self.tableView.isHidden = false
                    self.indicator.stopAnimating()
                    self.firstStart = false
                    return
                }
                
                if let address {
                    self.addresses.append(address)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.firstStart = false
                    return
                }
                self.indicator.stopAnimating()
                self.firstStart = false
            }
        }
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        configureTableView()
    }
    
    fileprivate func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setRequest() {
        UserManager.shared.fetchRequest(username: AuthManager.shared.getProfile()!.username) { error in
            gurad error == nil else { return }
            
            self.tabBarController?.tabBar.items![3].badgeValue = users.count > 0 ? String(users.count): nil
        }
    }
    
    // MARK: - Actions
    @IBAction func gotoMapViewAddAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddAddress", sender: ["Add"])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderData = sender as? Address {
            let dest = segue.destination as! AdressShareViewController
            dest.address = senderData
            return
        }
        
        if let sendarData = sender as? [Any] {
            let key = sendarData[0] as? String
            
            switch key {
                case "Add":
                    let dest = segue.destination as! MapViewController
                    dest.segueKey = "Add"
                    break
                case "Show":
                    let dest = segue.destination as! MapViewController
                    dest.segueKey = "Show"
                    dest.address = sendarData[1] as? Address
                    break
                default:
                    break
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let address = addresses[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressListTableViewCell.identifiers, for: indexPath) as? AddressListTableViewCell else { fatalError("Error dequeue cell") }
        cell.cellData = address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let address = addresses[indexPath.row]
        
        performSegue(withIdentifier: "AddAddress", sender: ["Show", address])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let address = addresses[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, boolValue in
            boolValue(true)
            
            AddressManager.shared.deleteAddress(id: address.id) { error in
                guard error == nil else { return }
                self.addresses.remove(at: indexPath.row)
                self.users.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        let share = UIContextualAction(style: .normal, title: "Share") { _, _, boolValue in
            boolValue(true)
            
            self.performSegue(withIdentifier: "ShareAddress", sender: address)
        }
        
        share.backgroundColor = UIColor(named: "PrimaryColor")
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}
