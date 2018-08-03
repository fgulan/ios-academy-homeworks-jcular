//
//  HomeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit
import KeychainAccess

class HomeViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _collectionView: UICollectionView! {
        didSet {
            _collectionView.delegate = self
            _collectionView.dataSource = self
            _loadShows(withToken: _loginUser.token)

            _collectionView.refreshControl = _refreshControl
            _refreshControl.tintColor = UIColor.ts.pink
            _refreshControl.addTarget(self, action: #selector(_refreashData), for: .valueChanged)
        }
    }

    // MARK: - Private properties -

    private var _loginUser: LoginData!
    private var _shows: [Show] = []
    private var _switchLayoutItem: UIBarButtonItem!

    private let _refreshControl = UIRefreshControl()
    
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

        _setupNavigationBar()
    }

    private func _setupNavigationBar() {
        let logoutButtonImage = UIImage(named:
            "ic-logout")?.withRenderingMode(.alwaysOriginal)
        let logoutItem = UIBarButtonItem(image: logoutButtonImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(_didSelectLogout))
        navigationItem.leftBarButtonItem = logoutItem

        _switchLayoutItem = UIBarButtonItem(image: nil,
                                            style: .plain,
                                            target: self,
                                            action: #selector(_didSelectSwitchLayout))
        _setImageForSwitchLayoutBarButton()
        navigationItem.rightBarButtonItem = _switchLayoutItem
    }

    @objc private func _didSelectLogout() {
        let keychain = Keychain(service: "hr.jcular.TVShows")
        keychain["email"] = nil
        keychain["password"] = nil
        let loginViewController = LoginViewController.initFromStroyboard()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }

    @objc private func _didSelectSwitchLayout() {
        UserDefaults.ts.shouldUseGrid = !UserDefaults.ts.shouldUseGrid
        _setImageForSwitchLayoutBarButton()
        _collectionView.reloadData()
    }

    private func _setImageForSwitchLayoutBarButton() {
        let shouldUseGridLayout = UserDefaults.ts.shouldUseGrid
        let layoutImageName = shouldUseGridLayout ? "ic-gridview" : "ic-listview"
        let layoutButtonImage = UIImage(named:
            layoutImageName)?.withRenderingMode(.alwaysOriginal)
        _switchLayoutItem.image = layoutButtonImage
    }

}

extension HomeViewController: Progressable, Alertable {

    // MARK: - Data loading -

    @objc private func _refreashData() {
        _loadShows(withToken: _loginUser.token)
    }

    func _loadShows(withToken token: String) {
        showProgressView()

        firstly {
            APIManager.getShows(withToken: token)
            }.done { [weak self] (shows: [Show]) in
                guard let `self` = self else { return }
                self._shows = shows
                self._collectionView.reloadData()
                if self._refreshControl.isRefreshing {
                    self._refreshControl.endRefreshing()
                }
            }.catch { [weak self] error in
                self?.showAlertView(title: "Failed to fetch shows",
                                    message: "Failed to fetch shows, please check your internet connection.")
            }.finally{ [weak self] in
                self?.hideProgress()
        }
    }

}

// MARK: - UICollectionViewDelegate -

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _collectionView.deselectItem(at: indexPath, animated: true)

        let show = _shows[indexPath.row]
        let showDetailsViewController = ShowDetailsViewController.initFromStoryboard(withToken: _loginUser.token, showID: show.id)
        navigationController?.show(showDetailsViewController, sender: self)
    }

}

// MARK: - UICollectionViewDataSource -

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _shows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UserDefaults.ts.shouldUseGrid {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ShowGridCollectionViewCell",
                for: indexPath
            ) as! ShowGridCollectionViewCell

            cell.configure(show: _shows[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ShowListCollectionViewCell",
                for: indexPath
                ) as! ShowListCollectionViewCell

            cell.configure(show: _shows[indexPath.row])
            return cell
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout -
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UserDefaults.ts.shouldUseGrid {
            let cellWidth = view.frame.size.width / 2 - 10
            let cellHeight = cellWidth * 4/3

            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellWidth = view.frame.size.width
            let cellHeight = CGFloat(180)

            return CGSize(width: cellWidth, height: cellHeight)
        }
    }

}
