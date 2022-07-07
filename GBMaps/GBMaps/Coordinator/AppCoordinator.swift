//
//  AppCoordinator.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 06.07.2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigation: UINavigationController
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigation = navigationController
    }
    
    func start() {
        goToLoginPage()
    }
    
    func goToLoginPage(isLogOut: Bool = false) {
        
        if isLogOut {
            navigation.popViewController(animated: true)
            return
        }
        
        instantiateLoginViewController()
        
    }
    
    private func instantiateLoginViewController() {
        
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        
        let loginViewModel = LoginViewModel()
        loginViewModel.appCoordinator = self
        loginViewController.viewModel = loginViewModel
        navigation.pushViewController(loginViewController, animated: true)
        
    }
    
    func goToUserPage() {
        guard let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else { return }
        
        let userViewModel = UserViewModel()
        userViewModel.appCoordinator = self
        userViewController.viewModel = userViewModel
        navigation.pushViewController(userViewController, animated: true)
    }
    
}
