//
//  UIViewController+.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation
import UIKit

extension UIViewController {
    public func showAlert(titles: String..., message: String) {
        let alert = UIAlertController(title: titles[0], message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: titles[1], style: .default)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    public func showAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        
        self.present(alert, animated: true)
    }
    
    public func checkConnection() {
        if !NetworkMonitor.shared.isConnected {
            showAlert(error: CommonErrors.connectionProblem)
        }
    }
}
