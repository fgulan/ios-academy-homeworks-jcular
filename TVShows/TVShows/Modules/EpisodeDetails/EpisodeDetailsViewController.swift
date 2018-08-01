//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Jure Cular on 01/08/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit

class EpisodeDetailsViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _episodeImageView: UIImageView!
    @IBOutlet private weak var _episodeTitleLabel: UILabel!
    @IBOutlet private weak var _episodeMarkLabel: UILabel!
    @IBOutlet private weak var _episodeDescriptionLabel: UILabel!

    // MARK: - Private properties -

    private var _token: String!
    private var _episodeID: String!

    // MARK: - Init -
    public class func initFromStoryboard(withToken token: String, episodeID: String) -> EpisodeDetailsViewController {
        let episodeDetailsStoryboard = UIStoryboard(name: "EpisodeDetails", bundle: nil)
        let episodeDetailsViewController = episodeDetailsStoryboard.instantiateInitialViewController() as! EpisodeDetailsViewController
        episodeDetailsViewController._token = token
        episodeDetailsViewController._episodeID = episodeID

        return episodeDetailsViewController
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _loadEpisodeDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - IBActions -

    @IBAction private func _didTapCommentsButton(_ sender: Any) {
        let commentsViewController = CommentsViewController.initFromStoryboard(withToken: _token, episodeID: _episodeID)
        navigationController?.pushViewController(commentsViewController, animated: true)
    }

    @IBAction private func _didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -

    private func _configure(episode: Episode) {
        let episodeImageUrl = APIManager.createImageURL(withResource: episode.imageURL)
        _episodeImageView.kf.setImage(with: episodeImageUrl)
        _episodeTitleLabel.text = episode.title
        if
            let season = episode.season,
            let episodeNumber = episode.episodeNumber {
            _episodeMarkLabel.text = "S\(season)Ep\(episodeNumber)"
        } else {
            _episodeMarkLabel.text = "No information"
        }
        _episodeDescriptionLabel.text = episode.description
    }

}

extension EpisodeDetailsViewController: Progressable, Alertable {

    private func _loadEpisodeDetails() {
        showProgressView()

        firstly {
            APIManager.getEpisode(withToken: _token, episodeID: _episodeID)
        }.done { [weak self] (episode: Episode) in
            self?._configure(episode: episode)
        }.catch { [weak self] error in
            self?.showAlertView(title: "Failed to fetch episode",
                                message: "Failed to fetch episode, please check your internet connection." )
        }.finally { [weak self] in
            self?.hideProgress()
        }
    }

}
