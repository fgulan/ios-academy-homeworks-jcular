//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 24/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _episodeTitleLabel: UILabel!
    @IBOutlet private weak var _episodeMarkLabel: UILabel!

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _episodeTitleLabel.text = nil
        _episodeMarkLabel.text = nil
    }

    // MARK: - Public -

    public func configure(episode: Episode) {
        _episodeTitleLabel.text = episode.title
        // TODO: API doesn't return this property shown in the design.
        _episodeMarkLabel.text = "S0 Ep0"
    }

}
