//
//  AuthManager.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation
import Firebase

final class AuthManager {
    
    // MARK: - Properties
    static let shared = AuthManager()
    private let db: Firestore
    let def = UserDefaults.standard
    
    
    // MARK: - Init Methods
    private init() {
        self.db = Firestore.firestore()
    }
    
    // MARK: - Helper Methods
    func register(mail: String, password: String, username: String, fullName: String, completion: @escaping (Error?) -> Void) {
        let profileID = UUID().uuidString
        let userProfile = User(id: profileID, username: username, fullname: fullName, email: mail)
        
        checkUser(username: userProfile.username) { [weak self] isExists, error in
            guard let self = self else { return }
            if let error {
                completion(error)
                return
            }
            
            if isExists! {
                completion(CommonErrors.userAlreadyExists)
                return
            } else {
                self.registerAction(profile: userProfile, password: password) { error in
                    if let error {
                        completion(error)
                        return
                    }
                    
                    self.setProfile(profile: userProfile)
                    completion(nil)
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] resultData, error in
            guard let self = self else { return }
            
            if let error {
                completion(nil, error)
                return
            }
            
            self.getProfileData(mail: email) { profile, error in
                if let error {
                    completion(nil, error)
                    return
                }
                
                self.setProfile(profile: profile!)
                completion(resultData, nil)
            }
        }
    }
    
    func isOnline() -> Bool {
        do {
            if try def.getObject(forKey: "profile", castTo: User.self) {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    private func setProfile(profile: User) {
        do {
            try def.setObject(profile, forKey: "profile")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getProfile() -> User? {
        do {
            let profile = try def.getObject(forKey: "profile", castTo: User.self)
            return profile
        } catch {
            return nil
        }
    }
    
    
    func closeProfile(completion: @escaping (Error?) -> Void) {
        def.removeObject(forKey: "profile")
        
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func registerAction(profile: User, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: profile.email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error {
                completion(error)
                return
            }
            
            self.saveAccount(profile: profile) { error in
                if let error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    private func saveAccount(profile: User, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(profile.id).setData(profile.toDictionary()) { error in
            if let error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    private func getProfileData(mail: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("users").whereField("email", isEqualTo: mail).getDocuments { snapshots, error in
            guard let snap = snapshots else { return }
            
            if let error {
                completion(nil, error)
                return
            }
            
            let document = snap.documents[0]
            
            let profile = User(id: document.get("id") as! String, username: document.get("username") as! String, fullname: document.get("fullname") as! String, email: document.get("email") as! String)
            completion(profile, nil)
        }
    }
    
    private func checkUser(username: String, completion: @escaping (Bool?, Error?) -> Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { snapshots, error in
            guard let snap = snapshots else { return }
            
            if let error {
                completion(nil, CommonErrors.databaseError)
                return
            }
            
            if snap.documents.count > 0 {
                completion(true, nil)
                return
            }
            
            completion(false, nil)
        }
    }
}
