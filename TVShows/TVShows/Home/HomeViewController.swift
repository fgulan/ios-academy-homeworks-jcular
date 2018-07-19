//
//  HomeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Init -

    class func initFromStoryboard() -> HomeViewController {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        return homeStoryboard.instantiateInitialViewController() as! HomeViewController
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
