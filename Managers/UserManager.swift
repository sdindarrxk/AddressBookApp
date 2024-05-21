//
//  UserManager.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation
import Firebase

enum relationshipStatus {
    case noRelation
    case relation
    case requestReletion
}

final class UserManager {
    
    // MARK: - Properties
    fileprivate var db: Firestore
    fileprivate var storage: Storage
    static let shared: UserManager = UserManager()
    var users: [User]
    
    // MARK: - Init Method
    private init() {
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
    }
    
    // MARK: - Helper Methods
    func getUsers(searchText username: String, completion: @escaping ([User]?, Error?) -> Void) {
        db.collection("users").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { [weak self] snapshots, error in
            guard let self = self, let snap = snapshots else { return }
            guard !snap.documents.isEmpty else { return }
            
            if let error {
                completion(nil, error)
                return
            }
            
            for document in snap.documents {
                let user = User(data: document.data())
                if user.username == AuthManager.shared.getProfile()?.username { return }
                
                users.append(user)
            }
            
            completion(users, nil)
        }
    }
    
    func sendRequest(user: User, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requestProfiles").addDocument(data: user.toDictionary())
        
        db.collection("users").document(user.id).collection("requests").addDocument(data: AuthManager.shared.getProfile()!.toDictionary()) { error in
            if let error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func fetchRequest(username: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requests").addsnapshotsListener { snapshots, error in
            guard let snap = snapshots else { return }
            
            if let error {
                completion(error)
                return
            }
            
            snap.documentChanges.forEach { documentChange in
                if documentChange.type == .added {
                    users.append(documentChange.document.data())
                } else if documentChange.type == .removed {
                    users.remove(at: Int(documentChange.oldIndex))
                }
                
                completion(nil)
            }
        }
    }
    
    func compareRequest(username: String, completion: @escaping (relationshipStatus?, Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("shared_users").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { [weak self] snapshots, error in
            guard let self = self, let snap = snapshots else {
                completion(nil, error)
                return
            }
            
            if let error {
                completion(nil, error)
                return
            }
            
            if snap.documents.count > 0 {
                completion(.relation, nil)
                return
            }
        }
        
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requestProfiles").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username+"\u{f8ff}").getDocuments { [weak self] snapshots, error in
            guard let self = self, let snap = snapshots else {
                completion(nil, error)
                return
            }
            
            if let error {
                completion(nil, error)
                return
            }
            
            if snap.documents.count > 0 {
                completion(.requestReletion, nil)
            } else {
                completion(.noRelation, nil)
            }
        }
    }
    
    func addUserSharedUsers(user: User, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("shared_users").addDocument(data: user.toDictionary()) { [weak self] error in
            guard let self = self else { return }
            
            if let error {
                completion(error)
                return
            }
            
            self.db.collection("users").document(user.id).collection("shared_users").addDocument(data: AuthManager.shared.getProfile()!.toDictionary()) { [weak self] error in
                guard let self = self else { return }
                
                if let error {
                    completion(error)
                    return
                }
                
                self.deleteRequestProfile(user: user) { error in
                    if let error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
    }
    
    func deleteRequestProfile(user: User, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(user.id).collection("requestProfiles").whereField("id", in: [AuthManager.shared.getProfile()!.id]).getDocuments { [weak self] snapshots, error in
            guard let self = self, let snap = snapshots else { return }
            
            if let error {
                completion(error)
                return
            }
            
            let doc1 = snap.documents[0].documentID
            
            self.db.collection("users").document(user.id).collection("requestProfiles").document(doc1!).delete { error in
                if let error {
                    completion(error)
                    return
                }
                
                self.db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requests").whereField("id", in: [user.id]).getDocuments { [weak self] snapshots, error in
                    guard let self = self, let snap = snapshots else { return }
                    
                    if let error {
                        completion(error)
                        return
                    }
                    
                    let doc2 = snap.documents[0].documentID
                    
                    self.db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("requests").document(doc2!).delete() { error in
                        if let error {
                            completion(error)
                            return
                        }
                        
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func getSharedUsers( completion: @escaping ([User]?, Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("shared_users").getDocuments { snapshots, error in
            guard let snap = snapshots else {
                completion(nil, nil)
                return
            }
            
            if let error {
                completion(nil, error)
                return
            }
            
            for document in snap.documents {
                let user = User(data: document.data())
                users.append(user)
            }
            
            completion(users, nil)
        }
    }
}
