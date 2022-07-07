//
//  LoginViewController.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 06.07.2022.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.autocorrectionType = .no
        }
    }
    
    let realmService = RealmService()
    
    @IBAction func didTapInputButton(_ sender: UIButton) {
        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else { return }
        
        if let users = self.realmService.read(object: UserModel.self, filter: "login == '\(login)'") as? [UserModel],
           let user = users.first,
           user.password == password {
            viewModel?.goToUserScreen()
        } else {
            self.showLoginError()
        }
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {

        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else { return }
        
        if let users = self.realmService.read(object: UserModel.self, filter: "login == '\(login)'") as? [UserModel],
           let user = users.first {
            print("Пользователю \(user.login) будет изменен пароль")
        }
        
        let user = UserModel(login: login, password: password)
        self.realmService.add(model: user)
        
        viewModel?.goToUserScreen()
    }
    
    private func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введите корректные данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
