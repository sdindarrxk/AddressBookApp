//
//  CommonErrors.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation

enum CommonErrors: Error {
    case emptyFields
    case incorrectPasswords
    case invalidPasswords
    case connectionProblem
    case databaseError
    case userAlreadyExists
    case generalError
}

extension CommonErrors: LocalizedError {
    var localizedDescription: String? {
        switch self {
        case .emptyFields:
            return NSLocalizedString("Fill in all fields", comment: "")
        case .incorrectPasswords:
            return NSLocalizedString("Password incorrect", comment: "")
        case .invalidPasswords:
            return NSLocalizedString("Invalid password", comment: "")
        case .connectionProblem:
            return NSLocalizedString("No internet connection", comment: "")
        case .databaseError:
            return NSLocalizedString("Database error has occurred", comment: "")
        case .userAlreadyExists:
            return NSLocalizedString("User already exist", comment: "")
        case .generalError:
            return NSLocalizedString("An error has occurred", comment: "")
        }
    }
}
