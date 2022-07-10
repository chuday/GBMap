//
//  UserViewController.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 07.07.2022.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    var viewModel: UserViewModel?
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        viewModel?.logout()
    }
    
}
