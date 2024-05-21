//
//  AddressManager.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import Foundation
import Firebase
import Kingfisher

final class AddressManager {
   
    // MARK: - Properties
    static let shared: AddressManager = AddressManager()
    private var db: Firestore
    private var storage: Storage
   
    // MARK: - Init Methods
    private init() {
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
    }
    
    // MARK: - Helper Methods
    func saveAddress(address: Address, completion: @escaping (Error?) -> Void) {
        let ref = storage.reference(withPath: "users").child(AuthManager.shared.getProfile()!.id).child("address_photos/\(address.title)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = ref.putData(address.getPhotoData(), metadata: metadata) { metaData, error in
            if let error {
                completion(error)
                return
            }
            
            ref.downloadURL { url, error in
                if let error {
                    completion(error)
                    return
                }
                
                address.setPhotoUrl(path: url!.absoluteString)
                self.db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("addresses").document(address.id).setData(address.convertKeyValueArray()) { error in
                    if let error {
                        completion(CommonErrors.databaseError)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
    }
    
    func getAddresses(completion: @escaping (Address?, Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("addresses").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self, let snap = snapshot else { return }
            
            if let error {
                completion(nil, error)
                return
            }
            
            if !snap.documents.isEmpty {
                snap.documentChanges.forEach { change in
                    if difference.type == .added {
                        let address = Address(id: change.document.documentID, keyValue: change.document.data())
                        self.getPhotos(address: address) { image in
                            address.photo = image
                            completion(address, nil)
                        }
                    }
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func shareAddress(address: Address, to user: User, completion: @escaping (Error?) -> Void) {
        var owner = AuthManager.shared.getProfile()!.username
        address.owner = owner
        db.collection("users").document(user.id).collection("addresses").addDocument(data: address.convertKeyValueArray()) { error in
            if let error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    private func getPhotos(address: Address, completion: @escaping (UIImage?) -> Void) {
        let resource = ImageResource(downloadURL: URL(string: address.getPhotoUrl())!)
        
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        
        if ImageCache.default.isCached(forKey: address.getPhotoUrl()) {
            cache.retrieveImage(forKey: address.getPhotoUrl()) { result in
                switch result {
                case .success(let value):
                    completion(UIImage(cgImage: (value.image?.cgImage)!))
                    return
                case .failure:
                    completion(nil)
                    return
                }
            }
        } else {
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                do {
                    let image = try UIImage(cgImage: result.get().image.cgImage!)
                    completion(image)
                } catch {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func deleteAddress(id: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(AuthManager.shared.getProfile()!.id).collection("addresses").document(id).delete { error in
            if let error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
