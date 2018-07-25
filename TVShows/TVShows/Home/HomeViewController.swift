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

    // MARK: - IBOutlets -

    @IBOutlet private weak var _tableView: UITableView! {
        didSet {
            _tableView.delegate = self
            _tableView.dataSource = self
        }
    }

    // MARK: - Private properties -

    private var _loginUser: LoginData!
    private var _shows: [Show]?

    // MARK: - Init -

    public class func initFromStoryboard(with loginUser: LoginData) -> HomeViewController {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateInitialViewController() as! HomeViewController
        homeViewController._loginUser = loginUser
        homeViewController.title = "Shows"

        return homeViewController
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _loadShows()
    }

}

extension HomeViewController: Progressable, Alertable {

    // MARK: - Data loading -

    func _loadShows() {
        showProgressView()

        firstly {
            APIManager.getShows(with: _loginUser.token)
            }.done { [weak self] (shows: [Show]) in
                guard let `self` = self else { return }
                self._shows = shows
                self._tableView.reloadData()
            }.catch { [weak self] error in
                self?.showAlertView(title: "Failed to fetch shows",
                                    message: "Failed to fetch shows, please check your internet connection.")
            }.finally{ [weak self] in
                self?.hideProgress()
        }
    }

}

// MARK: - UITableViewDelegate -

extension HomeViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource -

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _shows?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shows = _shows else { return 0}
        return shows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShowTableViewCell",
            for: indexPath
        ) as! ShowTableViewCell

        if let shows = _shows {
            cell.configure(show: shows[indexPath.row])
        }

        return cell
    }

}
