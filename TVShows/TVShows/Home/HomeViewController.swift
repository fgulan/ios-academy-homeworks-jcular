//
//  HomeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {

    // MARK: - Private properties -

    private var _loginUser: LoginData!
    private var _shows: [Show]?

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        firstly {
            APIManager.getShows(with: _loginUser.token)
        }.done { [weak self] (shows: [Show]) in
            guard let `self` = self else { return }
            self._shows = shows
            self._tableView.reloadData()
        }.catch { error in
            print(error)
        }
    }

}
