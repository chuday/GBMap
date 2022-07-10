//
//  LocationManagerService.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 10.07.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

final class LocationManagerService: NSObject {
    // MARK: Properties
    static let instance = LocationManagerService()
    
    let locationManager = CLLocationManager()
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    private override init() {
        super.init()
    }
}
