//
//  LoginViewModel.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 07.07.2022.
//

import Foundation

class LoginViewModel {
    weak var appCoordinator: AppCoordinator?
    
    func goToUserScreen() {
        appCoordinator?.goToUserPage()
    }
}
