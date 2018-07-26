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

        _loadShowData(withToken: _token, showID: _showID)
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 300
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - IBActions -

    @IBAction private func _didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func _didTapAddEpisode(_ sender: Any) {
        let addEpisodeViewController = AddEpisodeViewController.initFromStoryboard(withToken: _token, showID: _showID)
        addEpisodeViewController.delegate = self

        let navigationController = UINavigationController.init(rootViewController: addEpisodeViewController)

        present(navigationController, animated: true, completion: nil)
    }

}

extension ShowDetailsViewController: Progressable, Alertable {

    // MARK: - Data loading -

    private func _loadShowData(withToken token: String, showID: String) {
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

// MARK: - UITableViewDelegate -

extension ShowDetailsViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource -

extension ShowDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row > 2 {
            _episodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.row {
        case 0, 1:
            return .none
        default:
            return .delete
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _episodes.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ShowImageTableViewCell",
                    for: indexPath
                    ) as! ShowImageTableViewCell
                // TODO: remove Image placeholder, use image url from ShowDetails
                if let image = UIImage(named: "img-placeholder-user1") {
                    cell.configure(image: image)
                }

                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ShowDescriptionTableViewCell",
                    for: indexPath
                ) as! ShowDescriptionTableViewCell
                if let showDetails = _showDetails {
                    cell.configure(showDetails: showDetails, episodesNumber: _episodes.count)
                }

                cell.selectionStyle = .none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "EpisodeTableViewCell",
                    for: indexPath
                ) as! EpisodeTableViewCell
                cell.configure(episode: _episodes[indexPath.row - 2])

                return cell
        }
    }

}


// MARK: - AddEpisodeViewControllerDelegate -

extension ShowDetailsViewController: AddEpisodeViewControllerDelegate {

    func succesfullyAddedEpisode() {
        _loadShowData(withToken: _token, showID: _showID)
    }

}
