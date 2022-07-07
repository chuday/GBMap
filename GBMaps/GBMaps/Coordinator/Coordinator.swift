//
//  Coordinator.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 06.07.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigation: UINavigationController { get set }
    func start()
    
}
