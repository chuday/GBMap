//
//  UserViewModel.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 07.07.2022.
//

import Foundation

class UserViewModel {
    weak var appCoordinator: AppCoordinator?
    
    func logout() {
        appCoordinator?.goToLoginPage(isLogOut: true)
    }
}
