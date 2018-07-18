//
//  HomeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private properties -

    private var _loginUser: LoginData!

    // MARK: - Init -

    public class func initFromStoryboard(with loginUser: LoginData) -> HomeViewController {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateInitialViewController() as! HomeViewController
        homeViewController._loginUser = loginUser

        return homeViewController
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
