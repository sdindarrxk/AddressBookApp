//
//  AddressSaveViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit
import CoreLocation
import MapKit

class AddressSaveViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var coordinate: CLLocationCoordinate2D!
    private var addressMark: MKPlacemark!
    private var photo: UIImage?
    
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var addressTitleTextField: CommonTextField!
    @IBOutlet var addressDescriptionTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    var photoController: UIImagePickerController!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }
    
    // MARK: - UI Configurations
    fileprivate func configureUI() {
        saveButton.layer.cornerRadius = 10
        photoController.delegate = self
        configureMapView()
    }
    
    fileprivate func configureMapView() {
        addressMark = MKPlacemark(coordinate: coordinate)
        mapView.addAnnotation(addressMark)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
    }
    
    // MARK: - Actions
    @IBAction func setPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.present(photoController, animated: true, completion: nil)
        } else {
            showAlert(error: "Your device not suppported camera")
        }
    }
    
    @IBAction func saveAddress() {
        let addressTitleText = addressTitleTextField.text
        let addressDescriptionText = addressDescriptionTextView.text
        
        guard addressTitleText != "" else {
            showAlert(error: CommonErrors.emptyFields)
            return
        }
        
        if photo == nil {
            photo = UIImage(named: "DefaultAddressImage")
        }
        
        let address = Address(id: UUID().uuidString, title: addressTitleText, desc: addressDescriptionText, photo: photo!, coordinate: coordinate)
        AddressManager.shared.saveAddress(address: address) { error in
            if let error {
                showAlert(error: error)
            }
            
            self.performSegue(withIdentifier: "goBackAddressList", sender: nil)
        }
    }
}

// MARK: - ImagePickerControllerDelegate Methods
extension AddressSaveViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        photo = info[.originalImage] as? UIImage
        photoButton.setImage(photo, for: .normal)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
