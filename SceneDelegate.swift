//
//  SceneDelegate.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        NetworkMonitor.shared.startMonitoring()
        
        FirebaseApp.configure()
        
        if AuthManager.shared.isOnline() {
            let firstVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainMenu")
            window?.rootViewController = firstVC
        } else {
            let firstVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC")
            window?.rootViewController = firstVC
        }
    }
}
