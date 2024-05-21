//
//  ProfileViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    var profilImage: UIImage?
    var user: User?
    
    // MARK: - Outlets
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var requestButton: UIButton!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getRequest()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        guard let user = user else { return }
        requestButton.isHidden = true
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
        mailLabel.text = user.email
    }
    
    // MARK: - Networking
    fileprivate func getRequest() {
        UserManager.shared.compareRequest(username: user!.username) { [weak self] state, error in
            guard let self = self, error == nil, let state = state else { return }
            self.requestButton.isHidden = false
            
            switch state {
                case .noRelation:
                    break
                case .relation:
                    self.requestButton.isEnabled = false
                    self.requestButton.setTitle("Use Registered", for: .disabled)
                case .requestReletion:
                    self.requestButton.isEnabled = false
                    self.requestButton.setTitle("Request Sent", for: .disabled)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func invite(_ sender: UIButton) {
        UserManager.shared.sendRequest(user: user!) { error in
            guard error == nil else { return }
            
            self.requestButton.isHidden = true
            self.requestButton.setTitle("Request Sent", for: .disabled)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
