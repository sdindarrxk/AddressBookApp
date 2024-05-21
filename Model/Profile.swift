//
//  Profile.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation

struct Profile: Codable {
    var id: String
    var username: String
    var fullname: String
    var email: String
    var online: Bool
}
