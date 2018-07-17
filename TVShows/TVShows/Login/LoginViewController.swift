//
//  LoginViewController.swift
//  TVShows
//
//  Created by Jure Cular on 08/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var rememberMeCheckmark: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius = 5.0
    }

    @IBAction func didPressRememberMeCheckmark(_ sender: Any) {
        rememberMeCheckmark.isSelected = !rememberMeCheckmark.isSelected
    }

}
