//
//  RegisterViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Outlets
    @IBOutlet var usernameTextField: CommonTextField!
    @IBOutlet var mailTextField: CommonTextField!
    @IBOutlet var nameTextField: CommonTextField!
    @IBOutlet var passwordTextField: CommonTextField!
    @IBOutlet var passwordSecondTextField: CommonTextField!
    @IBOutlet var registerButton: CommonButton!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        configureIndicator()
        checkConnection()
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
        guard mailTextField.text != "", usernameTextField.text != "", nameTextField.text != "", passwordTextField.text != "", passwordSecondTextField.text != "" else {
            showAlert(error: CommonErrors.emptyFields)
            return
        }
        
        guard passwordTextField.text == passwordSecondTextField.text else {
            showAlert(error: CommonErrors.incorrectPasswords)
            return
        }
        
        guard passwordTextField.text!.count >= 6 else {
            showAlert(error: CommonErrors.invalidPasswords)
            return
        }
        
        indicator.startAnimating()
        
        AuthManager.shared.register(mail: mailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, fullName: nameTextField.text!) { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.showAlert(error: error.localizedDescription)
                self.indicator.stopAnimating()
                return
            }
            
            self.indicator.stopAnimating()
            self.performSegue(withIdentifier: "RegisterMainSegue", sender: nil)
        }
    }
}
