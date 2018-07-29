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

            _loadShows()
        }
    }

    // MARK: - Private properties -

    private var _loginUser: LoginData!
    private var _shows: [Show] = []

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
        
        let logoutItem = UIBarButtonItem.init(image: UIImage(named:
            "ic-logout"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(_didSelectLogout))
        navigationItem.leftBarButtonItem = logoutItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc private func _didSelectLogout() {
        UserDefaults.clearUserCredidentials()
        let loginViewController = LoginViewController.initFromStroyboard()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }

}

extension HomeViewController: Progressable, Alertable {

    // MARK: - Data loading -

    func _loadShows() {
        showProgressView()

        firstly {
            APIManager.getShows(withToken: _loginUser.token)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let show = _shows[indexPath.row]
        let showDetailsViewController = ShowDetailsViewController.initFromStoryboard(withToken: _loginUser.token, showID: show.id)
        navigationController?.show(showDetailsViewController, sender: self)
    }

}

// MARK: - UITableViewDataSource -

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (action, indexPath) in
            self?._shows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteButton]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShowTableViewCell",
            for: indexPath
        ) as! ShowTableViewCell

        cell.configure(show: _shows[indexPath.row])

        return cell
    }

}
