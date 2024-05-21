//
//  UserDefaults+.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation

extension UserDefaults {
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws {
        do {
            let data = try JSONEncoder().encode(object)
            set(data, forKey: forKey)
        } catch {
            
        }
    }
    
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object? {
        guard let data = data(forKey: forKey) else {throw CommonErrors.databaseError}
        do {
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            throw CommonErrors.databaseError
        }
    }
}
