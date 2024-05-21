//
//  MapViewController.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Properties
    var segueKey: String!
    var address: Address?
    
    // MARK: - Outlets
    let locationManager: CLLocationManager = CLLocationManager()
    var mapView: MKMapView?
     
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocationRequest()
        configureMapView(segueKey: segueKey)
    }
    
    // MARK: - UI Configurations
    override func configureUI() {
        configureLocationManager()
        configureMapView(segueKey: segueKey)
    }
    
    fileprivate func configureMapView(segueKey key: String) {
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .follow
        
        if segueKey == "Add" {
            addLongPressGestureToMapView()
        }
        
        if segueKey == "Show" {
            let placeMark = MKPlacemark(coordinate: address!.coordinate)
            mapView?.addAnnotation(placeMark)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: (mapView?.userLocation.coordinate)!))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: address!.coordinate))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { [weak self] response, error in
                guard let self = self, let response = response else { return }
                
                if let error {
                    showAlert(error: error)
                    return
                }
                
                for route in response.routes {
                    self.mapView?.addOverlay(route.polyline)
                    self.mapView?.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
                }
            }
        }
    }
    
    fileprivate func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 5
    }
    
    // MARK: - Helper Methods
    fileprivate func getLocationRequest() {
        let status = locationManager.authorizationStatus
        
        switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                locationManager.requestWhenInUseAuthorization()
                break
            case .denied:
                showDialog()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                break
            default:
                return
        }
    }
    
    fileprivate func addLongPressGestureToMapView() {
        var longPressGesture: UILongPressGestureRecognizer?
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(gesturePressed(_:)))
        longPressGesture?.delegate = self
        longPressGesture?.minimumPressDuration = 2
        mapView?.addGestureRecognizer(longPressGesture!)
    }
    
    fileprivate func showYesOrNoAlert(coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "Attention", message: "Are you sure you want to add the address?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            self.performSegue(withIdentifier: "AddAddressSegue", sender: coordinate)
        }
        alert.addAction(yes)
        
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func gesturePressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView?.convert(location, toCoordinateFrom: mapView)
            
            showYesOrNoAlert(coordinate: coordinate!)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAddressSegue" {
            let dest = segue.destination as! AddressSaveViewController
            dest.coordinate = sender as? CLLocationCoordinate2D
        }
    }
}

// MARK: - LocationManagerDelegate Methods
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first?.coordinate)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .denied:
            showAlert(error: "To use the application, you must provide location permission, go to settings and allow location permission")
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView?.userTrackingMode = .follow
            break
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            return
        }
    }
}

// MARK: - MapViewDelegate Methods
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}
