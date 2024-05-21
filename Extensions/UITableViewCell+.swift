//
//  UITableViewCell+.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation

extension UITableViewCell {
    // MARK: - Identifier Methods
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nibName: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
