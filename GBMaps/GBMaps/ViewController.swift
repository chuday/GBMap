//
//  ViewController.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 28.06.2022.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let coordinate = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    var route: GMSPolyline?
    var locationManager: CLLocationManager?
    var routePath: GMSMutablePath?
    
    override func viewDidLoad() {
        configureMap()
        configureLocationManager()
    }
    
    @IBAction func didTapAddMarker(_ sender: UIButton) {
        if marker == nil {
            mapView.animate(toLocation: coordinate)
            
            addMarker()
        } else {
            removeMarker()
        }
    }
    
    @IBAction func didTapUpdateLocaton(_ sender: UIButton) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }
    
    private func configureLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        marker?.title = "Marker"
        marker?.snippet = "This is new marker"
        marker?.map = mapView
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        
        let manualMarker = GMSMarker(position: coordinate)
        manualMarker.map = mapView
        
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        
        geoCoder?.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { places, error in
            print(places?.last)
        })
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        mapView.animate(to: position)
        
        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


