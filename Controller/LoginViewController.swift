//
//  LoginViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class LoginViewController: UIViewController {
        
    // MARK: - Outlets
    @IBOutlet var mailTextField: CommonTextField!
    @IBOutlet var passwordTextField: CommonTextField!
    @IBOutlet var loginButton: CommonButton!
    @IBOutlet var registerButton: CommonButton!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       checkConnection()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        configureIndicator()
    }
    
    fileprivate func configureIndicator() {
        self.view.addSubview(indicator)
        indicator.color = UIColor(named: "PrimaryColor")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    // MARK: - Actions
    @IBAction func registerButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard mailTextField.text != "", passwordTextField.text != "" else {
            showError(error: CommonErrors.emptyFields)
            return
        }
        
        indicator.startAnimating()
        
        AuthManager.shared.login(email: mailTextInput.text!, password: passTextInput.text!) { [weak self] _, error in
            guard let self = self else { return }
            
            self.indicator.stopAnimating()
            if let error {
                showAlert(error: error)
                return
            }
            
            self.performSegue(withIdentifier: "MainSegue", sender: nil)
        }
    }
}
