//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Jure Cular on 24/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit

class ShowDetailsViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _tableView: UITableView! {
        didSet {
            _tableView.delegate = self
            _tableView.dataSource = self
        }
    }
    
    // MARK: - Private properties -

    private var _token: String!
    private var _showID: String!
    private var _showDetails: ShowDetails?
    private var _episodes: [Episode] = []

    // MARK: - Init -

    public class func initFromStoryboard(withToken token: String, showID: String) -> ShowDetailsViewController {
        let showDetailsStoryboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = showDetailsStoryboard.instantiateInitialViewController() as! ShowDetailsViewController
        showDetailsViewController._token = token
        showDetailsViewController._showID = showID

        return showDetailsViewController
    }

    // MARK: - Lifeciycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 300
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        _loadShowData(withToken: _token, showID: _showID)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - IBActions -

    @IBAction private func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func _didTapAddEpisode(_ sender: Any) {
    }

}

extension ShowDetailsViewController: Progressable, Alertable {

    // MARK: - Data loading -

    func _loadShowData(withToken token: String, showID: String) {
        showProgressView()

        firstly {
            APIManager.getShowDetails(withToken: token, showID: showID)
        }.then { [weak self] (showDetails: ShowDetails) -> Promise<[Episode]> in
            self?._showDetails = showDetails
            return APIManager.getShowEpisodes(withToken: token, showID: showID)
        }.done { [weak self] (episodes: [Episode]) in
            guard let `self` = self else { return }
            self._episodes = episodes
            self._tableView.reloadData()
        }.catch { [weak self] error in
            self?.showAlertView(title: "Failed to fetch show details",
                                message: "Failed to fetch show details, please check your internet connection.")
        }.finally{ [weak self] in
            self?.hideProgress()
        }
    }

}
