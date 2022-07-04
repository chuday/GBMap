//
//  MapsViewController.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 04.07.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager?
    let realmService = RealmService()
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var markers: [GMSMarker]?
    let zoom: Float = 15
    
    var recUpdateLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLocationManager()
        self.configureMap()
    }
    
    private func configureMap() {
        self.locationManager?.requestLocation()
        
        if let coordinate = self.locationManager?.location?.coordinate {
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: self.zoom)
            self.mapView.camera = camera
            self.addMarker(coordinate)
            self.mapView.isMyLocationEnabled = true
        }
    }
    
    private func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.startMonitoringSignificantLocationChanges()
        self.locationManager?.requestAlwaysAuthorization()
    }
    
    private func addMarker(_ position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.title = "New marker"
        marker.map = self.mapView
        self.markers?.append(marker)
    }
    
    private func showError() {
        
        let alert = UIAlertController(title: "Ошибка", message: "Остановите слежение и нажмите ОК", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.clearPathLocation()
            self.loadLastPlaces()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    private func clearPathLocation() {
        
        self.routePath?.removeAllCoordinates()
        self.locationManager?.startMonitoringSignificantLocationChanges()
        self.locationManager?.stopUpdatingLocation()
        self.recUpdateLocation = false
    }
    
    private func loadLastPlaces() {
        
        if let coornidates = self.realmService.read(object: CoordinateModel.self) as? [CoordinateModel] {
            self.route?.map = nil
            self.route = GMSPolyline()
            self.routePath = GMSMutablePath()
            
            for coornidate in coornidates {
                self.routePath?.add(CLLocationCoordinate2DMake(coornidate.latitude, coornidate.longitude))
            }
            
            self.route?.path = self.routePath
            self.route?.map = self.mapView
            
            let bounds = GMSCoordinateBounds(path: self.routePath!)
            let update = GMSCameraUpdate.fit(bounds)
            self.mapView.animate(with: update)
        }
    }
    
    @IBAction func didTapTrackButton(_ sender: UIButton) {
        
        if self.recUpdateLocation {
            self.locationManager?.stopUpdatingLocation()
        } else {
            self.locationManager?.startUpdatingLocation()
        }
        self.recUpdateLocation.toggle()
    }
    
    @IBAction func didTapCurrentButton(_ sender: UIButton) {
        
        self.configureMap()
    }
    
    @IBAction func didTapNewTrackButton(_ sender: UIButton) {
        
        self.route?.map = nil
        self.route = GMSPolyline()
        self.routePath = GMSMutablePath()
        self.route?.map = self.mapView
        self.locationManager?.startUpdatingLocation()
        self.recUpdateLocation = true
    }
    
    @IBAction func didTapStopButton(_ sender: UIButton) {
        
        guard let path = self.routePath else { return }
        
        var items: [CLLocationCoordinate2D] = []
        for i in 0..<path.count() {
            let coordinate = path.coordinate(at: i)
            items.append(coordinate)
        }
        
        let coordinats = items.map { CoordinateModel(data: $0) }
        
        self.realmService.delete(object: CoordinateModel.self)
        self.realmService.add(models: coordinats)
        
        self.clearPathLocation()
    }
    
    @IBAction func didTapPreviousRouteButton(_ sender: UIButton) {
        
        if self.recUpdateLocation {
            self.showError()
        } else {
            self.loadLastPlaces()
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        self.routePath?.add(location.coordinate)
        self.route?.path = self.routePath
        
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: self.zoom)
        self.mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
